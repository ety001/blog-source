---
author: ety001
comments: true
date: 2014-04-25 12:04:00+00:00
layout: post
slug: manual-extend-the-lvm-volume
title: 手动扩容LVM容量
wordpress_id: 2607
tags:
- Server&OS
---

1、创建PV

pvcreate  /dev/vdb

2、检查是否创建

pvscan

3、在已有的VG中加入新的PV

vgextend   [vg name]  /dev/vdb

4、检查VG

vgdisplay

得到Free PE/Size 中的PE数量

5、放大LV

lvresize  -l  +[PE数量]  [LV的物理地址]

例如：lvresize  -l  +25599   /dev/vg_livedvd/lv_root

6、完整的将LV扩容到整个文件系统

resize2fs  [LV的物理地址]
