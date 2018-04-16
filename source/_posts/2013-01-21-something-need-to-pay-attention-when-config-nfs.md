---
author: ety001
comments: true
date: 2013-01-21 16:09:08+00:00
layout: post
slug: something-need-to-pay-attention-when-config-nfs
title: 一些做nfs时的注意事项
wordpress_id: 2291
tags:
- Server&OS
---

近期入手了一个Raspberry Pi，然后在折腾的时候，想把一台局域网内的机器的硬盘中的一个目录做nfs挂载过来，其间出了些问题，下面列举出来。

1、服务端的/etc/exports文件配置的时候，允许的ip地址和操作权限之间是没有空格的

2、cenos6做nfs服务器的时候，portmap已经更名为rpcbind

3、由于我的Raspberry Pi上安装的是archlinux，所以还需要安装nfs-utils，然后才能挂载nfs，否则挂载的时候会提示类型不识别

4、挂载的时候需要 -o nolock参数

5、如果你的客户端处在另一个网段下面，与服务端的通信经过了NAT，客户端mount的时候会有下面的报错

mount.nfs: access denied by server while mounting

那么你需要在服务端的权限配置中加入insecure的参数，不使用nfs预留端口，因为走NAT，所以端口都是大于1024的，这一点从服务器端查看log日志，

cat /var/log/messages | grep mount

就会发现端口非法（illegal port）。详情见这里：[http://blog.sina.com.cn/s/blog_5e66060c01017bpx.html](http://blog.sina.com.cn/s/blog_5e66060c01017bpx.html)

