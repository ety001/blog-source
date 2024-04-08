---
author: ety001
comments: true
date: 2013-11-03 20:12:30+00:00
layout: post
slug: solve-the-problem-when-selecting-the-bridge-network-card-in-the-vbox
title: 解决vbox桥接网卡时的报错问题
wordpress_id: 2523
tags:
- Server&OS
---

升级了下Archlinux后，发现vbox启动不起来了，具体报错跟这个帖子很像

[https://bbs.archlinux.org/viewtopic.php?id=85956](https://bbs.archlinux.org/viewtopic.php?id=85956)

解决方法是按照4L的方法加载了个驱动就好了。。。


    <code>sudo modprobe vboxnetflt</code>

