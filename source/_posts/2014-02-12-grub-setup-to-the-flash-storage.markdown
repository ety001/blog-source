---
author: ety001
comments: true
date: 2014-02-12 08:59:20+00:00
layout: post
slug: grub-setup-to-the-flash-storage
title: u盘安装linux，将grub安装到了u盘，导致没U盘系统无法引导启动的解决方法
wordpress_id: 2569
tags:
- Server&OS
---

转自：http://blog.csdn.net/xhu_eternalcc/article/details/13632643

今天用U盘装linux时候不小心将grub安装到了U盘上，导致每次启动系统都得插U盘，下面是解决办法，拷贝时忘了记下转载出处，实在不好意思。

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


装CentOS的时候用的是u盘安装，不小心把grub装在了u盘上，然后每次都要从u盘启动，当然不能容忍这样子，以下就是修复grub的过程：
<!-- more -->
u盘引导进入系统后,首先查看系统安装位置，也就是执行df -k 查看系统盘/boot位置

[root@localhost /]#df -k        #可能会得到/dev/hda1

[root@localhost /]#/sbin/grub   #进入grub命令行模式

grub> find /boot/grub/stage1    find /grub/stage1      find stage1 #命令行下输入下列三条命令，总有一条会返回一个正确的grub位置

grub> find /grub/stage1

find /grub/stage1

（hd1,1）

grub>root （hd0,0）        #第一条
grub>setup （hd0）         #第二条
grub>quit                  #第三条   grub环境下连续执行这三条命令返回SHELL

最后修改grub.conf和menu.lst里面的（hd1,1）为（hd0,0）重新启动即可。
[root@localhost /]#vi /boot/grub/grub.conf ...   vi /boot/grub/menu.1st ...

[root@localhost /]init 6

大功告成！
================================================================================
后记：
需要特别说明的是，CENTOS 默认在VG上把BOOT分为一个独立的分区，所以开始启动的时候和系统启动开的根目录是不一样的，也就是说系统引导的时候的/，就是LINUX里的/BOOT,所以，GRUB的配置文件在系统里的位置应该在/BOOT/BOOT/GRUB/GRUB.CONF.

----------------------------

说明：你可能在find /boot/grub/stage1 的时候发现就是 (hd0,0)，那就可能是grub.conf和menu.lst里面有hd(1,1)，同样按作者的方法也能解决。
