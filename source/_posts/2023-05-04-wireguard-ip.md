---
author: ety001
date: 2023-05-04 13:25:31+00:00
layout: post
title: Demo code about how to create a new account by Steem JS SDK
tags:
- Server&OS
- 服务器
- 配置
- 经验
---

# 前置信息

之前两个局域网是靠 zerotier 连接的，但是 zerotier 在国内的网络环境实在是太糟糕了，即使我用了黑科技在国内服务器上搭建两 planet ，依旧是不稳定。

于是放弃 zerotier ，转而使用 wireguard 组建我的工作 VPN。

网络信息如下：
* 局域网A:  192.168.196.0/22，  做节点的机器A的 IP: 192.168.199.81
* 局域网B:  192.168.31.0/24，  做节点的机器B的 IP: 192.168.31.5
* 服务器: x.x.x.x

公私钥信息如下：
* 机器A:    PubKeyA/PrivKeyA
* 机器B:    PubKeyB/PrivKeyB
* 服务器:    PubKeyServ/PrivKeyServ

> 公私钥生成命令：
```
wg genkey | tee privatekey | wg pubkey > publickey
```

# 步骤

1.三台机器都开启转发
```
# 添加下面的配置到 /etc/sysctl.conf 后执行 sysctl -p 生效
net.ipv4.ip_forward = 1
```

2.三台机器都安装 wireguard

3.机器A配置 /etc/wireguard/wg0.conf

```
[Interface]
PrivateKey = PrivKeyA
Address = 10.0.1.2/32
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = PubKeyServ
AllowedIPs = 10.0.1.1/32, 192.168.31.0/24
Endpoint = x.x.x.x:51820
PersistentKeepalive = 25
```

4.机器B配置 /etc/wireguard/wg0.conf

```
[Interface]
PrivateKey = PrivKeyB
Address = 10.0.1.3/32
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = PubKeyServ
AllowedIPs = 10.0.1.1/32, 192.168.196.0/22
Endpoint = x.x.x.x:51820
PersistentKeepalive = 25
```

5.服务器配置 /etc/wireguard/wg0.conf
```
[Interface]
PrivateKey = PrivKeyServ
Address = 10.0.1.1/24
ListenPort = 51820
PostUp = iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE

[Peer]
# HostA
PublicKey = PubKeyA
AllowedIPs = 10.0.1.2/32, 192.168.196.0/22
PersistentKeepalive = 25

[Peer]
# HostB
PublicKey = PubKeyB
AllowedIPs = 10.0.1.3/32, 192.168.31.0/24
PersistentKeepalive = 25
```

6.局域网A的openwrt路由器上添加静态路由
* 接口: lan
* 目的地址: 192.168.31.0/24
* 路由ip: 192.168.199.81
* 类型: unicast

7.局域网A的openwrt路由器上添加静态路由
* 接口: lan
* 目的地址: 192.168.196.0/22
* 路由ip: 192.168.31.5
* 类型: unicast

# 总结

主要难点就是各个节点的 AllowedIPs 和防火墙规则配置。
