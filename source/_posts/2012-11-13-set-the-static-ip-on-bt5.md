---
author: ety001
comments: true
date: 2012-11-13 13:39:15
layout: post
slug: set-the-static-ip-on-bt5
title: bt5设置静态ip
wordpress_id: 2215
tags:
- Hacker
- Server&OS
---

vim /etc/network/interfaces

找到对应的网卡加入相关的信息，比如：

    auto eth0
    iface eth0 inet static
    address 192.168.1.101
    netmask 255.255.255.0
    gateway 192.168.1.1
    network 192.168.1.0
    broadcast 192.168.1.255

