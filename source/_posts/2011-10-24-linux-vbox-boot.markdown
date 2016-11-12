---
author: ety001
date: 2011-10-24 12:32:00+00:00
layout: post
title: XP下装LinuxDeepin后XP无法引导解决办法
wordpress_id: 1732
tags:
- Server&OS
---

昨天给所里一哥们装双系统XP+LinuxDeepin（这是深度从ubuntu11.04改过来的，适合新手和喜欢偷懒的老手），结果安装完LD后，LD顺利能进入，但是XP进不去了，具体现象就是在选择系统的菜单里选择XP后，过两秒钟又跳回选择菜单了……

各种修改grub都没有成功。偶然间发现一条信息，说ubuntu默认安装的时候，会把引导装入mbr，这样会破坏XP的引导部分。于是乎，找了找修复mbr的命令，最终，利用一个原装的XP盘引导进故障控制台后，分别使用fixmbr和fixboot两天命令把XP的mbr修复OK，重启能够引导进入XP，然后又用LiveUSB引导进入LD，升级了一下grub２后，一切ok～
