---
author: ety001
date: 2011-12-14 13:13:09
layout: post
title: Linux vps生成100mb.bin文件测试下载速度
wordpress_id: 1815
tags:
- Server&OS
---

　　大家买了vps之后是不是都迫不及待的想让朋友们帮忙测试下下载速度，很多vps商或者独立服务器都提供100mb.bin 或者1000mb.bin的文件下载，当然这些文件都不是上传上去的，用服务器自动生成即可。
　　进入你的网站目录，指向命令：


    dd if=/dev/zero of=100mb.bin bs=100M count=1

其中的文件大小和数量，你自己决定吧！

生成之后可以直接在浏览器输入文件的网址，测试单线程的下载速度，如果想测试极限速度可以找几家国外的vps或者服务器，下载你的文件试试。

