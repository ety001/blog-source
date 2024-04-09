---
author: ety001
comments: true
date: 2013-09-17 09:05:33
layout: post
slug: about-php-control-the-process
title: 关于php控制进程
wordpress_id: 2461
tags:
- 编程语言
- 后端
---

最近在做的一个东西需要用到php去调用一个应用程序，而程序却不一定会第一时间就返回结果（执行效果有点像top命令），这就导致如果用php直接exec执行这个程序的话，php页面将会处于一直等待的状态中，直到最大超时时间到了后，会返回网关错误（我用的nginx做前端）。我自己曾试过在要执行的命令后面加&，使其变成后台程序，这样php就会立即返回了，不过用grep进程列表获取该程序的进程的时候，就发现如果多个空格就会导致搜索不到指定的进程，这样就没法kill掉这个进程了。于是又写了一个C程序，以实现这个C程序可以把一条命令转成守护进程执行，并且返回该守护进程的pid，这样我就可以直接在php里把返回的pid存起来，到时候直接kill掉就OK啦~

如果你以为这样就结束了，那你就错了，我在v2ex上发帖子希望能让大家帮我看看这个程序是否有安全隐患，没想到还有很多的解决措施，尤其是php自带的一些函数方法之前是不知道的。

1、pcntl系的函数。不过这个需要自己先安装这个扩展，在ext/pcntl下面，自己编译下就ok了，得到的so文件放到扩展目录，在php.ini中配置下就ok。不过就我刚才的测试来看，貌似还达不到我要的效果，pid的返回有些问题。

2、php-childprocess ：项目地址，[https://github.com/hfcorriez/php-childprocess](https://github.com/hfcorriez/php-childprocess)，这个还没有时间仔细来看是如何实现以及该怎么用，不过看上去是很强大的样子。

如果还有回复的话，我会再补充到这里。

我写的那段C程地址在这里：[https://github.com/ety001/mytools/tree/master/daemonRun](https://github.com/ety001/mytools/tree/master/daemonRun)



补充：

最后用shell脚本完爆啊。。

ffmpeg ******** >/dev/null 2>1 & echo $!

