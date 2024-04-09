---
author: ety001
comments: true
date: 2014-01-19 07:32:52
layout: post
slug: opencv-program-cannot-find-lib-after-compile
title: opencv程序编译后执行找不到库
wordpress_id: 2556
tags:
- Server&OS
- 编程语言
---

在ubuntu下编译opencv程序后，执行报下面到错误：

error while loading shared libraries: libopencv_core.so.2.4: cannot open shared object file: No such file or directory

解决方法：找到libopencv_开头到库的目录，在/usr/local/lib下面，在/etc/ld.so.conf.d/下面新建一个opencv.conf，里面写入/usr/local/lib，最后执行下sudo ldconfig -v即可。

参考：http://stackoverflow.com/questions/12335848/opencv-program-compile-error-libopencv-core-so-2-4-cannot-open-shared-object-f

