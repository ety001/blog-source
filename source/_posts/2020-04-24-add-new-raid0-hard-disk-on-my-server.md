---
author: ety001
layout: post
title: 今天把家里的服务器新配了Raid0硬盘
tags:
  - 服务器
  - 经验
  - 配置
  - Server&OS
---

鉴于现在家里的服务器，跑的服务太多了，尤其是近期跑起来 `hivemind` 和 `account history node`，明显感觉硬盘读写跟不上节奏了。

之前为了降低成本，买的硬盘都是希捷最便宜的硬盘。一块2T的和一块6TB的，加起来才 ￥1618。然后通过 LVM 把这两块硬盘做成了一个整体。

这次为了保证读写速度，也是多花了些钱，买了稍微上点档次的硬盘。西数的企业级硬盘，两块4TB的硬盘，加起来将近 ￥2000。

除了买的硬盘贵了些，还打算做成 `Raid0` 来提升读写速度。

`RAID`，`Redundant Arrays of Independent Disks`，即磁盘阵列，有“独立磁盘构成的具有冗余能力的阵列”之意。

这是一个可以让你用廉价硬盘去实现更高可靠的存储介质的技术方案。`RAID` 有好几个等级，其中 `RAID0` 是几种等级里，对读写速度提升最大，但是数据安全最差的。具体的原理，请自行搜索。

这次我使用 `LVM` 来实现 `RAID0`，实现步骤：

```
# pvcreate /dev/sd{d,e}1
# vgcreate raid0 /dev/sd{d,e}1
# lvcreate -l +100%free -i 2 -I 128 raid0 -n raid0_lv
# mkfs.ext4 /dev/raid0/raid0_lv
# mount /dev/raid0/raid0_lv /data/
```

> 注意：
> 1.如果你的硬盘容量大于2TB，请先使用 `fdisk` 把硬盘分区表改为 `GPT`
> 2.使用 `fdisk` 把磁盘的标记选择为 `Linux LVM`，然后再执行 `pvcreate`
> 3.`lvcreate` 命令里 `-i` 设置驱动器数量，`-I` 设置 stripesize

配置好以后，测试了下写入速度，真是快的飞起

![](/upload/202004/4pd3RNz6xuTe35R2KeP6cR7NTfsPB5quJSpMUl2M.png)

接下来就是把 `hivemind` 那些数据转移到新的硬盘下，进行工作了！


---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
