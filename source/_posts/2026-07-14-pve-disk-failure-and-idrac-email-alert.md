---
author: ety001
title: PVE 宿主机磁盘故障排查与 iDRAC 邮件告警配置
date: 2026-07-14 21:00:00
layout: post
tags:
- Server&OS
- PVE
- 硬件
- Dell
---

## 背景

Dell R730xd 上跑着 PVE（Proxmox VE），12 块物理盘挂在 PERC H730P Mini 硬件 RAID 卡下面。某天 Steem witness 节点开始极度不稳定，频繁出块失败，同时 SSH 到内网其他机器也变慢。

本文记录了从故障排查到磁盘迁移、再到 iDRAC 邮件告警配置的完整过程。

## 一、故障现象

- VM 100 (witness) 频繁 RCU stall，steemd 进程周期性冻结
- 区块同步出现 90+ 秒的 Block Time Offset
- 532 次 unlinkable_block / fork 事件
- 从其他网段 SSH 到 PVE 内网机器明显变慢

## 二、排查过程

### 2.1 定位故障盘

PVE 宿主机 `dmesg` 中发现大量 I/O 错误：

```
[Mon Jul 13 12:12:04 2026] sd 0:0:9:0: [sdb] tag#518 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=170s
[Mon Jul 13 12:12:04 2026] I/O error, dev sdb, sector 6200037536 op 0x0:(READ) flags 0x80700 phys_seg 64 prio class 0
```

`cmd_age` 最长达到 170 秒，意味着一个 I/O 请求卡了将近 3 分钟。

SMART 检查发现这块 Seagate ST6000NM0115 (6TB) 已经严重损坏：

| SMART 属性 | 值 | 说明 |
|---|---|---|
| Reallocated_Sector_Ct | 38808 | 重映射扇区近 4 万 |
| Reported_Uncorrect | 187 | 不可纠正错误 |
| Seek_Error_Rate | 11 亿+ | 磁头寻道异常 |
| G-Sense_Error_Rate | 109347 | 物理冲击记录 |
| 通电时间 | 42750 小时 | 约 4.9 年 |

### 2.2 根因分析

关键发现：**sdb 每次 I/O 错误卡住时，PVE 宿主机内核 I/O 子系统全局阻塞，所有 VM 跟着冻结。**

虽然 sdb 只挂在一个 VM (102/steem) 上作为数据盘，但内核处理 I/O 错误时是全局阻塞的，导致：
- VM 100 (witness) 内核触发 RCU soft lockup
- steemd 停摆，收到的区块 Block Time Offset 飙到 90+ 秒
- 分叉和 unlinkable block 大量出现

VM 100 的 RCU stall 时间和 sdb 的 I/O 错误时间完全吻合。

### 2.3 硬件 RAID 卡下的磁盘监控

PVE 是 Dell R730xd，12 块物理盘在 PERC H730P Mini 硬件 RAID 卡后面。OS 看到的 `/dev/sdX` 大多是 RAID 逻辑卷，不是物理盘。

**smartmontools 可以穿透硬件 RAID 卡**，使用 `-d megaraid,N` 参数直接读取每块物理盘的 SMART 数据：

```bash
# 查看 RAID 卡后面的物理盘
smartctl -a -d megaraid,9 /dev/sdc

# 物理盘列表（megaraid,0 ~ megaraid,11）
for i in $(seq 0 11); do
    echo "=== megaraid,$i ==="
    smartctl -i -d megaraid,$i /dev/sdc 2>&1 | grep -E "Device Model|Serial|Capacity"
done
```

12 块物理盘的映射关系：

| megaraid | 型号 | 容量 | RAID 卷 | PVE 存储 |
|---|---|---|---|---|
| 0-5 | ST4000NM000B/A | 4TB ×6 | rd0 (RAID-10) | /mnt/pve/rd0 |
| 6-7 | Colorful SL500 | 2TB ×2 | ssd (RAID-0) | /mnt/pve/ssd |
| 8 | WDC WD20EARS | 2TB | tc (JBOD) | /mnt/pve/tc |
| 9 | ST6000NM0115 | 6TB | single (JBOD) | /mnt/pve/single (故障盘) |
| 10-11 | ST1000DM010 | 1TB ×2 | rd1 (RAID-1) | 系统盘 |

## 三、磁盘迁移

### 3.1 创建新盘

在健康的 rd0 存储上创建一块 4T 虚拟磁盘替代故障盘：

```bash
fallocate -l 4096G /mnt/pve/rd0/images/102/vm-102-disk-2.raw
qm set 102 --scsi3 rd0:102/vm-102-disk-2.raw,cache=writeback,size=4T
```

### 3.2 数据迁移

通过 qemu-nbd 在 PVE 宿主机上直接操作两块虚拟磁盘：

```bash
# 挂载旧盘和新盘
qemu-nbd -c /dev/nbd1 -f raw /mnt/pve/single/images/102/vm-102-disk-0.raw
qemu-nbd -c /dev/nbd2 -f raw /mnt/pve/rd0/images/102/vm-102-disk-2.raw

mount -o ro /dev/nbd1 /mnt/tmp
mount /dev/nbd2 /mnt/newbackup

# rsync 迁移
rsync -aHAXx --info=progress2 /mnt/tmp/ /mnt/newbackup/

# 清理
umount /mnt/tmp /mnt/newbackup
qemu-nbd --disconnect /dev/nbd1
qemu-nbd --disconnect /dev/nbd2
```

### 3.3 移除故障盘配置

```bash
# 从 VM 配置移除旧盘
qm set 102 --delete scsi1

# 从 PVE 存储配置移除
pvesm remove single
```

## 四、smartd 配置

默认的 `DEVICESCAN` 只能扫描到 JBOD 直通的盘，RAID 卡后面的 10 块物理盘完全没监控到。

替换 `/etc/smartd.conf`，显式列出所有 12 块物理盘：

```
# rd0: RAID-10 (6x ST4000NM 4TB HDD)
/dev/sdc -d megaraid,0 -a -H -l error -l selftest -C 197 -U 198 -W 4,45,55 -m root
/dev/sdc -d megaraid,1 -a -H -l error -l selftest -C 197 -U 198 -W 4,45,55 -m root
# ...（0-5 共 6 块）

# ssd: RAID-0 (2x Colorful SL500 2TB SSD)
/dev/sdc -d megaraid,6 -a -H -l error -l selftest -m root
/dev/sdc -d megaraid,7 -a -H -l error -l selftest -m root

# JBOD 直通盘
/dev/sda -a -H -l error -l selftest -C 197 -U 198 -W 4,45,55 -m root
/dev/sdb -a -H -l error -l selftest -C 197 -U 198 -W 4,45,55 -m root

# rd1: RAID-1 系统盘 (2x ST1000DM010 1TB)
/dev/sdc -d megaraid,10 -a -H -l error -l selftest -C 197 -U 198 -W 4,45,55 -m root
/dev/sdc -d megaraid,11 -a -H -l error -l selftest -C 197 -U 198 -W 4,45,55 -m root
```

## 五、磁盘健康巡检脚本

写了一个 cron 脚本每 4 小时巡检一次，检测到 SMART 异常时通过 Telegram 通知。

脚本的关键点：

1. **使用 smartctl 绝对路径**：cron 环境下 PATH 可能不包含 `/usr/sbin`
2. **timeout 包裹 smartctl**：坏盘的 SMART 查询可能卡住
3. **检测关键指标**：Reallocated_Sector_Ct、Current_Pending_Sector、Offline_Uncorrectable、Reported_Uncorrect
4. **Telegram 通知走 HTTP 代理**：国内服务器直连不了 api.telegram.org

```bash
#!/bin/bash
source /data/serv-conf/shell/.tg.env

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
SMARTCTL=/usr/sbin/smartctl
PROXY="http://192.168.30.4:8001"

check_disk() {
    local label="$1" dev="$2" opt="$3"
    local result
    result=$(timeout 15 $SMARTCTL -H $opt $dev 2>&1)
    if ! echo "$result" | grep -q "PASSED"; then
        ALERT="${ALERT}⚠️ ${label}: SMART FAILED\n"
    fi
}

# ...检查所有 12 块盘...
```

crontab 配置：

```
0 */4 * * * /data/serv-conf/shell/disk-health-check.sh > /dev/null 2>&1
```

## 六、iDRAC 邮件告警配置

### 6.1 网络层问题排查

iDRAC 配置 SMTP 发送测试邮件一直报 `RAC0225：发送测试邮件失败`。通过在路由器上用 tcpdump 抓包定位：

```bash
# 在 OpenWrt 路由器上抓 iDRAC 的 SMTP 流量
tcpdump -i br-lan host 192.168.30.20 and port 25 -n -A -s 0
```

抓到了 iDRAC 到邮件服务器的完整 SMTP 交互：

```
iDRAC: EHLO mypi.win
rack3: 250-STARTTLS, 250-AUTH PLAIN LOGIN ...
iDRAC: STARTTLS
rack3: 220 Ready to start TLS
iDRAC: <TLS ClientHello>
rack3: <7 bytes> → FIN 断开
```

### 6.2 TLS 证书问题

**根因：邮件服务器只有 ECC (ECDSA) 证书，iDRAC 的 TLS 客户端不支持。**

iDRAC 强制要求 STARTTLS，但 Dell iDRAC 的 TLS 实现比较老，只支持 RSA 证书。TLS 握手时服务器只有 ECC 证书，无法完成 RSA 密钥交换，握手失败。

### 6.3 解决方案：Postfix 双证书

Postfix 3.4+ 支持 `smtpd_tls_chain_files`，可以同时配置 RSA + ECC 证书，TLS 握手时根据客户端 ClientHello 自动选择。

在 [快速搭建一个SMTP邮件服务]({% post_path 2022-06-10-smtp %}) 中部署的 postfix 基础上：

**1. 用 acme.sh 签一张 RSA 证书（已有 ECC 证书保留）：**

```bash
~/.acme.sh/acme.sh --issue --dns dns_cf -d mypi.win --keylength 2048 --server letsencrypt
```

**2. 安装 RSA 证书到 TLS 目录：**

```bash
cp ~/.acme.sh/mypi.win/mypi.win.key /etc/postfix_conf/tls/mypi.win.rsa.key
cp ~/.acme.sh/mypi.win/fullchain.cer /etc/postfix_conf/tls/mypi.win.rsa.crt
chmod 400 /etc/postfix_conf/tls/mypi.win.rsa.*
```

**3. 配置 Postfix 双证书：**

```bash
# 用 smtpd_tls_chain_files 替代单独的 cert/key 配置
postconf -e "smtpd_tls_chain_files = /etc/postfix/tls/mypi.win.key /etc/postfix/tls/mypi.win.crt /etc/postfix/tls/mypi.win.rsa.key /etc/postfix/tls/mypi.win.rsa.crt"
postconf -e "smtpd_tls_cert_file ="
postconf -e "smtpd_tls_key_file ="
# 出站邮件同样配置
postconf -e "smtp_tls_chain_files = /etc/postfix/tls/mypi.win.key /etc/postfix/tls/mypi.win.crt /etc/postfix/tls/mypi.win.rsa.key /etc/postfix/tls/mypi.win.rsa.crt"
postconf -e "smtp_tls_cert_file ="
postconf -e "smtp_tls_key_file ="

postfix reload
```

**4. iDRAC 面板 SMTP 配置：**

- SMTP 服务器：邮件服务器 IP
- 端口：25
- 启用 SMTP 认证
- 用户名/密码：见 SASL 配置

### 6.4 验证

配置完成后，从 iDRAC 面板发送测试邮件成功。

## 七、经验总结

1. **硬件 RAID 卡不是 SMART 监控的黑洞**：`smartctl -d megaraid,N` 可以穿透 RAID 卡读取物理盘 SMART 数据
2. **一块坏盘可以拖垮整个宿主机**：内核 I/O 子系统全局阻塞，所有 VM 跟着冻结，不要误以为是单个 VM 的问题
3. **cron 环境的 PATH 陷阱**：cron 的默认 PATH 可能不包含 `/usr/sbin`，脚本中必须用绝对路径或显式 export PATH
4. **ECC 证书兼容性**：老设备（iDRAC、旧客户端）可能不支持 ECDSA 证书，配置双证书（RSA + ECC）是最通用的方案
5. **tcpdump 是排查 SMTP 问题的利器**：当应用层日志不可见时，在网络层抓包能看到完整的 SMTP 交互过程
