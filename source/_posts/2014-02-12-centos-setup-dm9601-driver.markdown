---
author: ety001
comments: true
date: 2014-02-12 09:00:55+00:00
layout: post
slug: centos-setup-dm9601-driver
title: centos下安装dm9601驱动
wordpress_id: 2567
tags:
- Server&OS
---

新安装了centos6.2，要使用一个usb网卡，但是插上后没有反映，执行lsusb如下：
`[root@pangu dm9601]# lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 004: ID 0fe6:9700 Kontron (Industrial Computer Source / ICS Advent) DM9601 Fast Ethernet Adapter
Bus 003 Device 003: ID 04b3:3025 IBM Corp. NetVista Full Width Keyboard
Bus 005 Device 002: ID 1d57:0008 Xenta `
<!-- more -->
可以看到网卡的ID为0fe6:9700，

执行modinfo，查看dm9601，如下：
`[root@pangu dm9601]# modinfo dm9601
filename:       /lib/modules/2.6.32-431.el6.x86_64/kernel/drivers/net/usb/dm9601.ko
license:        GPL
description:    Davicom DM9601 USB 1.1 ethernet devices
author:         Peter Korsgaard <jacmet@sunsite.dk>
srcversion:     4F5EB9E08E2E987CF777DB0
alias:          usb:v0A46p9000d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0FE6p8101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A47p9601d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A46p8515d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A46p0268d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A46p6688d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A46p9601d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp9601d*dc*dsc*dp*ic*isc*ip*
depends:        mii,usbnet
vermagic:       2.6.32-431.el6.x86_64 SMP mod_unload modversions
`

其中，有一个alias: usb:v0FE6p8101d*dc*dsc*dp*ic*isc*ip*，驱动已知设备中缺少我们的设备id，尝试下升级，yum update。
没有成功。

按照网上说的，手动添加也失败了。折腾了一天后，发现可以在centos5.3下直接编译成功，果断放弃centos6。。

参考：[http://tech.firdooze.com/2011/11/16/how-to-instal-davicom-9601-drivers-dm9601-on-linux/](http://tech.firdooze.com/2011/11/16/how-to-instal-davicom-9601-drivers-dm9601-on-linux/)

2月13号补充：如何让dm9601驱动在centos5.3上开机自动加载

编辑/etc/modprobe.conf
增加以下内容
alias eth1 dm9601
install dm9601 /sbin/insmod /lib/modules/2.6.18-128.el5/kernel/drivers/net/dm9601.ko

在/etc/sysconfig/network-scripts/目录下增加一个ifcfg-eth1的配置文件，把其中的ip等信息设置好（如果是复制的eth0的配置文件，不要忘记修改mac地址），重启网络看看是否成功，如果成功，重启电脑看下，是否可以自动加载。

modprobe的手册文件：[http://www.linuxmanpages.com/man5/modprobe.conf.5.php](http://www.linuxmanpages.com/man5/modprobe.conf.5.php)
