---
author: ety001
comments: true
date: 2012-02-08 06:16:37+00:00
layout: post
slug: burstnet-openvz-openvpn
title: BurstNet的OpenVZ架构的vps搭建VPN
wordpress_id: 1930
tags:
- Server&OS
---

最近买了一个BurstNet的VPS来玩玩，的确是很给力的，性价比超高，关键是有两个公网IP，并且可以再装cpanel之类的面板，操作系统的可选择性也极高，centos5，centos5.5，centos6.2，ubuntu，fedora，gentoo等等，并且系统貌似都是经过精简过的，就像我安装的centos5，安装完居然只占13M内存，硬盘也是只花费了550M。

为了测试一下这款VPS是否能搭建VPN，我从网上搜索了很多资料，最终了解到，OpenVZ架构的VPS只能安装OpenVPN，并且还需要开启TUN支持和iptables_nat模块支持（这个其实可以换一个iptables语句的）。

我参考了以下两篇博文，http://wty.name/centos-install-openvpn/ 和 http://www.xiaozhou.net/ittech/linux-ittech/configure_openvpn_on_burstnet_vps-2010-03-28.htm

其中需要注意的两点，一个是第一篇博文中有一键安装包，那个shell脚本里的ip地址并没有获取到，导致生成的.ovpn文件中的remote的ip地址是空白，再一点就是shell里面涉及到iptables转发的问题，在第二篇博文的评论中有提到解决方案。这个问题在网上其实也是很多的，就是执行

iptables -t nat -A POSTROUTING -s 192.168.21.0/24 -o eth0 -j MASQUERADE

的时候，会出现如下错误提示，

iptables：Unknown error 4294967295

解决方法是，改为下面的语句去执行：

/sbin/iptables -t nat -A POSTROUTING -s 192.168.21.0/24 -j SNAT --to-source YourVpsIP

这个vps的vpn配置我算是折腾了两天了，不过现在终于是可以翻墙出去啦，吼吼~
