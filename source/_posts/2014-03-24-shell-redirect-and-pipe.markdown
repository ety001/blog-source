---
author: ety001
comments: true
date: 2014-03-24 15:04:27+00:00
layout: post
slug: shell-redirect-and-pipe
title: shell重定向和管道
wordpress_id: 2590
tags:
- Server&OS
- 编程语言
---

今天在调一个命令的时候遇到的问题，有一个capture程序，有一个处理程序（就叫做abc吧），执行命令差不多类似于下面这样：
`capture -r 1 -f pipe:1 | abc -v 5 -r 3 > /dev/null 2> /dev/null &`
但是执行的时候，有时候成功有时候失败，失败的时候，abc报错内容大致就是没有收到capture程序的标准输出的数据。
网上查了下重定向和管道，发现了一篇文章，讲两者的区别，里面有个例子跟我这个类似，但是例子中多加了个括号，于是模仿一下，执行就成功了。
`(capture -r 1 -f pipe:1 | abc -v 5 -r 3) > /dev/null 2> /dev/null &`
于是猜测可能原因是重定向导致abc拿不到capture的数据了。

参考文章：[http://www.cnblogs.com/chengmo/archive/2010/10/21/1856577.html](http://www.cnblogs.com/chengmo/archive/2010/10/21/1856577.html)
