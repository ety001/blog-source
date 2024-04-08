---
author: ety001
comments: true
date: 2012-02-14 12:35:38+00:00
layout: post
title: Aptana Studio的failed to create the java virtual machine错误
wordpress_id: 1948
tags:
- 配置
---

最近不知道怎么安装过什么东西，导致了双击PHP文件打开Aptana Studio的时候，总是弹出failed to create the java virtual machine的错误提示框，但是Aptana Studio如果手动是能开启的。这个事情非常的让人郁闷，上百度搜了一圈都是说eclipse的处理方式的，后来在google上找到一篇英文的（[http://kisdigital.wordpress.com/2011/06/16/speeding-up-aptana-studio-3/](http://kisdigital.wordpress.com/2011/06/16/speeding-up-aptana-studio-3/)），大体意思是说按照eclipse的那个方法修改Aptana的配置文件也是可以成功的，于是我就复制了一下他给的配置文件，然后就好了，现在贴出来配置文件：

```
--launcher.XXMaxPermSize
256m
--launcher.defaultAction
openFile
-name
Aptana Studio 3
-vmargs
-Xms512m
-Xmx512m
-Declipse.p2.unsignedPolicy=allow
-Djava.awt.headless=true
-XX:PermSize=128m
-XX:MaxPermSize=128m
-Xverify:none
-XX:+UseParallelGC
-XX:+AggressiveOpts
-XX:+UseFastAccessorMethods
```

