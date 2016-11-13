---
author: ety001
date: 2011-08-27 23:41:09+00:00
layout: post
title: Wordpress打不开的解决方案
wordpress_id: 1495
tags:
- 网站日志
---

今天，访问我的博客的时候，发现博客打开后是空白页，什么都不显示，访问后台登录页面也是空白页，不知道哪个地方又出错了。

于是登录服务器的ssh，把wp-content目录重命名，然后再次访问后台登录页面，可以访问了，不过是英文界面，因为缺少了wp-content目录下的语言包的翻译，但是这个不影响我们操作。

初步断定是wp-content目录内的文件导致的问题，于是逐步缩小搜查范围，把wp-content的名字改回来，逐一把wp-content文件夹内的各个文件夹改名，

最后发现是我使用的D4主题出现了错误，遂进入后台把之前使用过的另一个主题启用，一切恢复正常～
