---
author: ety001
comments: true
date: 2012-12-28 13:39:22+00:00
layout: post
slug: archlinux-double-video-cards
title: Archlinux双显卡问题
wordpress_id: 2260
tags:
- Server&OS
---

我的笔记本是Dell Inspiron 15R Turbo 1728，一块Intel集成显卡外加一块ATI显卡。问题出现的情况是：每次启动Archlinux起来，屏幕基本上都是最暗的，偶尔会出现一次正常情况。

我装系统的时候，先装的xf86-video-intel，然后装的xf86-video-ati，其实有尝试装catalyst-dkms，但是catalyst-dkms安装的时候有个gpl跟xf86-video-intel的冲突，需要删掉，并且安装完catalyst-dkms后，重启也是起不来桌面的。。。

当时以为能装上私有驱动后，应该问题就能解决，但是后来因为catalyst-dkms安装失败，我也就放弃了。转机出现，是我在Archlinux的wiki上搜索别的资料的时候，发现了一个文章介绍Sony笔记本Archlinux的相关配置，链接：[https://wiki.archlinux.org/index.php/Sony_vaio_VGN-SA/SB](https://wiki.archlinux.org/index.php/Sony_vaio_VGN-SA/SB)。

这篇文章里面就提到了关于ATI独显和Intel板载显卡关闭的问题，简要的说就是要先挂载debugfs，
# mount -t debugfs debugfs /sys/kernel/debug
或者用在/etc/fstab中加入
debugfs /sys/kernel/debug debugfs 0 0

我表示我的系统已经挂好了这个了，所以我直接进入下一步，加载ATI的模块，
# modprobe radeon

关掉不在使用中的显卡
# echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

检查下设置的效果
# cat /sys/kernel/debug/vgaswitcheroo/switch

结果：
0:IGD:+:Pwr:0000:00:02.0
1:DIS: :Off:0000:01:00.0

注意带+号的表示现在正在用的显卡，IGD就是Intel的板载显卡，DIS就是ATI的那块独显。

如果想重新打开就执行
# echo ON > /sys/kernel/debug/vgaswitcheroo/switch

其他的详情看这篇文章吧，不多说了。

<del>再就是吐槽一下，我是最近用最新的镜像重装了下archlinux，原因是大版本变动的升级虽然升级成功了，但是有几个很纠结的小问题实在是没心情解决了，遂重装了，但是没想到这次重装后，发现又有变化就是之前的Sysvinit被systemd替换了。表示对于不会shell脚本的人来说，写一个能开机自动关掉显卡的service文件着实的蛋疼，虽然最终也算是成功了。在wiki上没有看到有关原来rc.local中开机自动执行脚本用systemd实现的方法，有知道的朋友，能否点播下我，谢啦～</del>

vim /usr/lib/systemd/system/rc-local.service

内容如下：

[Unit]

Description="/etc/rc.d/rc.local Compatibility"

After=network.target



[Service]

Type=forking

ExecStart=/etc/rc.d/rc.local start

TimeoutSec=0

StandardInput=tty

RemainAfterExit=yes

SysVStartPriority=99



[Install]

WantedBy=multi-user.target



启用脚本

systemctl enable rc-local.service



创建启动文件rc.local,



vim /etc/rc.d/rc.local

chmod +x /etc/rc.d/rc.local

