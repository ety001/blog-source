---
author: ety001
comments: true
date: 2012-03-29 01:39:01+00:00
layout: post
slug: remove-software-in-centos
title: 在centos下手动卸载软件
wordpress_id: 2059
tags:
- Server&OS
---

由于工作需要在godaddy上买了最便宜的那款centos系统的VDS，没想到，把预装的apache，mysql，php，sendmail干掉后，居然内存占用仅9M多，真神奇。

下面就说下怎么手动卸载，首先要rpm -qa|grep mysql，这条命令可以找出安装的mysql的包，然后根据返回的信息，一个包一个包的用rpm -e 这条命令卸载即可。
