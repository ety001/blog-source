---
author: ety001
comments: true
date: 2014-12-01 21:46:00+08:00
layout: post
slug: mount-vbox-share-in-the-virtual-machine
title: 在vbox的linux虚拟机中挂载vbox共享
tags:
- Server&OS
---

只需要一条命令即可：

> mount -t vboxsf home_wwwroot /home/wwwroot/

其中，home_wwwroot是在vbox中设置的共享的名字，/home/wwwroot是在虚拟机中要挂载到的路径。
