---
author: ety001
comments: true
date: 2013-10-22 09:49:00+00:00
layout: post
slug: usb-storage-device-auto-mounts-under-the-linux-text-mode
title: 文本模式下实现U盘自动挂载
wordpress_id: 2516
tags:
- Server&OS
---

参考：[http://forum.ubuntu.org.cn/viewtopic.php?t=296420](http://forum.ubuntu.org.cn/viewtopic.php?t=296420)

使用udev来实现，udev是linux2.6内核以上的功能，read more：[http://www.domyself.me/archives/some-nifty-udev-rules-and-examples/](http://www.domyself.me/archives/some-nifty-udev-rules-and-examples/)

具体实现方法：

如实现U盘自动挂载
Vim 11-add-usb.rules

添加如下内容
ACTION!="add",GOTO="farsight"
KERNEL=="sd[a-z][0-9]",RUN+="/sbin/mount-usb.sh %k"
LABEL="farsight"

这个文件中ACTION后是说明是什么事件，KERNEL后是说明是什么设备比如sda1，mmcblk0p1 等，RUN这个设备插入后去执行哪个程序%k是传入这个程序的参数，这里%k=KERNEL的值也就是sda1等。

在/sbin/下创建mount-usb.sh文件添加如下内容
#!/bin/sh
/bin/mount -t vfat /dev/$1 /tmp
sync

修改文件权限为其添加可执行的权限。

这样就实现了U盘的自动挂载，下面附上U盘的卸载规则文件和sd卡的文件

Usb卸载

11-add-remove.rules
ACTION !="remove",GOTO="farsight"
SUBSYSTEM!="block",GOTO="farsight"
KERNEL=="sd[a-z][0-9]",RUN+="/sbin/umount-usb.sh"
LABEL="farsight"

umount-usb.sh
#!/bin/sh
sync
umount /tmp/



需要注意的是rule文件中的一些符号，比如!=和==，在ubuntu下，如果你的符号有问题，文字的显示颜色会是白色的。
