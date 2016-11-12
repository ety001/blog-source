---
author: ety001
comments: true
date: 2012-11-16 13:54:52+00:00
layout: post
slug: retalk-heartbeat-and-drbd
title: 再谈heartbeat+DRBD
wordpress_id: 2235
tags:
- Server&OS
---

今天开始上服务器上实战了，不得不说在虚拟机的演习跟在服务器上的实战差距还是很大的。现在说遇到的问题：

1、一共两台2U的服务器，其中一台2U机器的一个网卡貌似挂掉了，现在把心跳线合并进了另外那个RIP的网卡。其实这个网卡有问题，还是因为通过网络安装系统的时候发现的。

2、每个服务器上一共有8块硬盘，每块1个T，其中之前服务器的每块硬盘都是用过的，而我在做drbdadm create-md的时候，提示下面的错误：

`md_offset
al_offset
bm_offset
Found ext3 filesystem which uses
Device size would be truncated, which
would corrupt data and result in
'access beyond end of device' errors.
You need to either
* use external meta data (recommended)
* shrink that filesystem first
* zero out the device (destroy the filesystem)
Operation refused.
Command 'drbdmeta`

看意思是原来的分区的文件系统还存在，没法初始化成drbd设备，用下面这条命令处理下：

`#dd if=/dev/zero bs=1M count=1 of=/dev/sda1; sync`

然后再执行create-md，我是执行了两边才成功的，如下：

`[root@node2 ~]# drbdadm create-md zentao
v08 Magic number not found
v07 Magic number not found
v07 Magic number not found
v08 Magic number not found
Writing meta data...
initialising activity log
NOT initialized bitmap
New drbd meta data block sucessfully created.
[root@node2 ~]# drbdadm create-md zentao
v07 Magic number not found
v07 Magic number not found
You want me to create a v08 style flexible-size internal meta data block.
There apears to be a v08 flexible-size internal meta data block
already in place on /dev/sdd1 at byte offset 1000202235904
Do you really want to overwrite the existing v08 meta-data?
[need to type 'yes' to confirm] yes`

Writing meta data...
initialising activity log
NOT initialized bitmap
New drbd meta data block sucessfully created.

3、再就是我的drbd一直是secondery/unknown，<del>更改了一下syncer的100M为10M后可以了。</del>又出现了这个问题，发现其实是防火墙导致的节点之间通信失败。
