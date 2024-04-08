---
author: ety001
comments: true
date: 2012-11-13 17:41:46+00:00
layout: post
slug: heartbeat-setup-user-hacluster-exsits
title: HeartBeat安装过程中出现hacluster用户已存在
wordpress_id: 2224
tags:
- Server&OS
---

HeartBeat安装
[root@ha ~]# yum -y install heartbeat
安装过程中会报错：
useradd: user hacluster exists
error: %pre(heartbeat-2.1.3-3.el5.centos.i386) scriptlet failed, exit status 9
error:   install: %pre scriptlet failed (2), skipping heartbeat-2.1.3-3.el5.centos
退出后，再次执行：
[root@ha ~]# yum -y install heartbeat

