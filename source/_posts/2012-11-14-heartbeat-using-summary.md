---
author: ety001
comments: true
date: 2012-11-14 10:02:15+00:00
layout: post
slug: heartbeat-using-summary
title: heartbeat入手总结
wordpress_id: 2227
tags:
- Server&OS
---

最近在搞双机热备，准备用heartbeat和DRBD来实现，由于之前没有接触过，于是想先逐个研究下，然后再集成起来。

在自己本上搭了两个虚拟机，具体环境是

centos5.3系统，
一键lnmp包，
    VIP：192.168.1.150，
    RIP1：192.168.1.190，心跳IP1：192.168.2.190，
    RIP2：192.168.1.191，心跳IP2：192.168.2.191。

从昨天晚上8点一直折腾到今天5点终于是做好了。下面就是相关的总结：

1、安装heartbeat我是直接用的yum，这个就挺好用的，也不用担心安装顺序，系统自动按顺序安装，只是注意一点，就是第一次安装的时候，一共安装3个包，第三个包才是heartbeat，但是程序会在安装第三个包的时候报错，提示hacluster用户已存在，这个时候，你直接再来一遍yum install heartbeat就安装好了。。。在这里我卡住了1个多小时，现在还没有仔细考虑是什么原因。

2、配置方面的文章，网上有很多，经过我的实验过程，我觉得这一篇还是不错的，我也是看了这一篇文章后，才知道是什么原因卡住了我10多个小时。文章地址：[http://sushan.blog.51cto.com/3532080/733484](http://sushan.blog.51cto.com/3532080/733484)

3、haresource这个配置文件，主从节点是一样的。这个之前我配错了，所以卡住了10个多小时，具体的错误表现是，主从节点都绑定了VIP。

4、如果你是先安装了一台虚拟机，并且配置好了heartbeat后，通过复制得到从节点的话，那么你需要在从节点卸载掉heartbeat，然后删除/var/lib/heartbeat目录，然后再重装heartbeat，因为uuid会有冲突。

