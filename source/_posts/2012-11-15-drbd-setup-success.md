---
author: ety001
comments: true
date: 2012-11-15 18:50:22+00:00
layout: post
slug: drbd-setup-success
title: drbd安装调试成功
wordpress_id: 2232
tags:
- Server&OS
---

很久木有大半夜的写技术文章了，最早可以追溯到四年前的大一上学期，在网吧，周边一圈打游戏看电影聊天的人，就我自己拿着本ASP，在敲代码。。。。

扯远了，接着昨天把heartbeat跑通后（貌似准确的来说是前天了。。。现在是16号凌晨了。。暂且就当做是15号吧![](file:///C:\Users\ETY001\AppData\Roaming\Tencent\QQPinyin\Face\ImageCache\28.gif)o(︶︿︶)o），今天下午恶补和复习了n多的知识，比如LVM，硬盘分区之类的，然后晚上开工了，整个过程参考了这篇文章，http://linux.chinaunix.net/techdoc/database/2008/10/28/1041372.shtml。

这篇文章已经说的很详细了，只是说一下我在实现中遇到的问题和解决方法。

总的来说今天基本上没有遇到什么问题，一切很顺利，首先要说的是，我用的centos5.3，在DRBD官网上看到，centos5以上的可以用yum install drbd kmod-drbd 来安装软件和模块，瞬间就感到很幸福，但是在我实践的时候，并没有成功，提示kmod版本冲突，经过思考和观察，我试了下yum install drbd82 kmod-drbd82就成功了，应该是源里面只有8.2版本的吧。。。

貌似就这一条。。。

再就是现在还没有解决的问题就是两台机器都重启后，两台机器都处于secondary状态，不解中，感觉好像是heartbeat的haresource配置文件配置的不对，还在调试。

2：54补充：果然是haresource的问题。。。。shell命令和IP间掉了个空格。。。

