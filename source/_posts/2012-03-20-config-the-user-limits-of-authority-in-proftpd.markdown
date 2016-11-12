---
author: ety001
comments: true
date: 2012-03-20 03:49:32+00:00
layout: post
slug: config-the-user-limits-of-authority-in-proftpd
title: 配置proftpd的用户权限
wordpress_id: 2047
tags:
- Server&OS
---

今天需要在服务器上配置两个ftp账户a和b，两个账户需要在同一个组，并且a允许ssh登陆，而b不允许ssh登陆。两个用户登陆ftp的时候都必须要限制在自己的家目录内。

具体配置不详说，只说一下几个关键点：

1、b用户因为不具备ssh登陆权限，所以在proftpd的配置文件里要加下面这行配置
RequireValidShell               off
这个配置的作用就是允许没有ssh登陆权限的用户登陆ftp

2、限制某个用户组只能访问自己家目录的配置：
DefaultRoot    ~ groupname
其中 ~指的是家目录，groupname指的是你要限制的用户组。
