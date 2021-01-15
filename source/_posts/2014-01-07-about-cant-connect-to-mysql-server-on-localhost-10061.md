---
author: ety001
comments: true
date: 2014-01-07 16:39:33+00:00
layout: post
slug: about-cant-connect-to-mysql-server-on-localhost-10061
title: 关于Can't connect to MySQL server on 'localhost' (10061)
wordpress_id: 2550
tags:
- Server&OS
---

今天晚上大约10点左右，实验室的OA服务器莫名重启，然后mysql就一直是连不上的样子，经过各种尝试无果后，用搜索引擎找到了解决方法，其实也怨我不仔细，在用netstat查端口开放的时候，忽略了ipv6的端口，在my.ini的mysqld下面设置bind-address为0.0.0.0或者127.0.0.1即可解决问题了。睡觉。。。

[![ipv6-port](/img/2014/01/QQ20140108-1-300x13.png)](/img/2014/01/QQ20140108-1.png)

