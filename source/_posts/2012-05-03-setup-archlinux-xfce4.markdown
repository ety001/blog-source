---
author: ety001
comments: true
date: 2012-05-03 08:39:57+00:00
layout: post
slug: setup-archlinux-xfce4
title: 安装archlinux+xfce4
wordpress_id: 2106
tags:
- Server&OS
---

喜欢折腾的人是闲不住的，这几天就在自己的笔记本上把原来的LinuxDeepin干掉，然后安装上了archlinux+xfce4的环境。现在基本是能用了，就说下流程，一次也写不全，先写下来，以后有时间再补充，也算是自己做个笔记，方便日后再次重装。

1、系统的安装。我用的是U盘安装，整个流程在archlinux的wiki上有详细介绍。

2、系统升级。我习惯安装完系统后第一时间升级，由于archlinux采用的是滚动升级的模式，所以只需要一条命令即可。

pacman -Syu

升级可能遇到的问题：执行命令后，可能系统会问pacman版本过低应先升级pacman，是否跳过升级pacman，这里一定要选择N。另外一个问题就是会有类似下面的错误：

error: failed to commit transaction (conflicting files)
filesystem: /etc/mtab exists in filesystem
Errors occurred, no packages were upgraded.

<!-- more -->

我查了网山很多的资料，有很多人都是用pacman -S filesystem –force强制升级的，不过还有个方法我比较推荐，就是先检查这个文件的关联，然后如果没有关联就把他mv或者rm掉。

3、使用adduser命令添加一个普通用户。其中用户要包含在哪些其他的组里面，在wiki上有说。

4、安装visudo，vim

5、安装yaourt。建议用修改pacman源的方式进行安装。

6、安装无线网络。这里使用的是wiki上的方法，由于我的笔记本无线网卡的型号是BCM4312,所以说，直接用yaourt安装AUR中博通的无线网卡驱动即可，具体方法见这里：[https://wiki.archlinux.org/index.php/Broadcom_wireless_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)](https://wiki.archlinux.org/index.php/Broadcom_wireless_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。其中要注意的是，安装完驱动后，要用ip link set eth1 up命令启动端口（我的无线网卡名为eth1，这个详见wiki中wireless setup页面下半部分）。另外需要安装network manager，并且把rc.conf的DAEMONS中的network给换成networkmanager，并加上wl（这个wl在wiki页面有介绍，其实就是安装完驱动后，modprobe wl下）。另外，记得执行安装这些软件，pacman -S polkit-gnome gnome-keyring libgnome-keyring pyxdg，这些软件安装完毕你才能连接到加密的无线热点。

7、安装X，dbus，xfce，字体

8、启动xfce，安装chromium和flashplugins。

9、安装gstreamer0.10_base_plugins，这样在面板上就能添加个声音控制了。

10、安装slim，这样可以开机即可进入桌面。

以上就是大体的流程。下面是写问题总结：

1、win7下的硬盘已经能够看到，但是无法挂载，显示“Not authorized to perform operation”，但是以root登录的话就能挂载访问。经过各种搜索后，找到解决方案：

I solved it by modifying this file:
/etc/polkit-1/localauthority/50-local.d/50-filesystem-mount-system-internal.pkla

You can refer to the wiki entry ([https://wiki.archlinux.org/index.php/Ud … ormal_user](https://wiki.archlinux.org/index.php/Udev#Mount_internal_drives_as_a_normal_user)) for more info.

Basically you need to replace 'udisks' with 'udisks2':

    [Mount a system-internal device]
    Identity=*
    Action=org.freedesktop.udisks2.*
    ResultActive=yes

This should fix all mounting problems.

2、挂载后发现中文乱码，又是各种搜索后，发现可以在“系统”-》“dconf Editor”中可以设置“system”-》“locale”-》“region”的值为utf8,gbk。

3、[12年7月8号补充] 新买了dell inspiron 15TR 1728的笔记本，安装archlinux的时候，从光盘引导不成功，出现了黑屏，从wiki上看是intel显卡导致的问题，按照wiki上的配置设置下，就可以继续进行安装了。wiki地址：[https://wiki.archlinux.org/index.php/Beginners%27_Guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.90.AF.E5.8A.A8.E6.93.8D.E4.BD.9C.E7.B3.BB.E7.BB.9F](https://wiki.archlinux.org/index.php/Beginners%27_Guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.90.AF.E5.8A.A8.E6.93.8D.E4.BD.9C.E7.B3.BB.E7.BB.9F)
在安装完以后，也出现了启动不起来的问题，参考了这篇博文后问题解决，[https://www.deleak.com/blog/2010/09/19/solve-arch-boot-up-stopped/](https://www.deleak.com/blog/2010/09/19/solve-arch-boot-up-stopped/)，即在grub启动指令ro后面再加上nomodeset。
[未完]
