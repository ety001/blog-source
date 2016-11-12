---
author: ety001
comments: true
date: 2012-09-12 04:03:05+00:00
layout: post
slug: move-goahead-webserver-to-android
title: 移植goahead到android或其他嵌入式linux系统上
wordpress_id: 2184
tags:
- Server&OS
---

从用上android平板开始就在想能不能把web服务器移植到平板上来，这样就能实现移动开发了，比带着笔记本方便多了，没想到这个已经是有人实现出来了，本文转载自：[http://alex-yang-xiansoftware-com.iteye.com/blog/1498536](http://alex-yang-xiansoftware-com.iteye.com/blog/1498536)

GoAhead是一款强大的嵌入式的web服务器，广泛应用在各种潜入式的系统中。支持各种多种操作系统。可以使用静态html，cgi或ASP以及嵌入式的JavaScript。而现在android又在嵌入式系统中应用越来越广泛，以下为在android上移植goahead的详细步骤，其他嵌入式linux与此相同：

**1.下载goahead的源码**

[https://github.com/embedthis/goahead/downloads](https://github.com/embedthis/goahead/downloads)

**2.下载和解压arm-linux-gcc**
比如解压到/usr/local/arm-gcc目录

**3.修改goahead的mkfile文件**

打开goahead/LINUX/Makefile文件，修改gcc和ar变量，如下两行：

CC=/usr/local/arm-gcc/opt/FriendlyARM/toolschain/4.4.3/bin/arm-none-linux-gnueabi-gcc
AR=/usr/local/arm-gcc/opt/FriendlyARM/toolschain/4.4.3/bin/arm-none-linux-gnueabi-ar

为了省去链接的麻烦，修改CFLAGS变量，添加static参数，直接修改为静态链接(否则在
执行编译后的目标码时一直报webs not found错误)：

CFLAGS = -static -DWEBS -DOS=&quot;LINUX&quot; -  DLINUX $(UMSW) $(DASW) $(SSLSW) $(IFMODSW)
<!-- more -->
**4.将goahead/LINUX/main.c的initWebs函数中的如下代码注释：**

if (gethostname(host, sizeof(host)) < 0) {
error(E_L, E_LOG, T("Can't get hostname"));
return -1;
}
if ((hp = gethostbyname(host)) == NULL) {
error(E_L, E_LOG, T("Can't get host address"));
return -1;
}
memcpy((char *) &intaddr, (char *) hp->h_addr_list[0],
(size_t) hp->h_length);

修改端口号为8080:

static int   port = 8080;

**5.修改web服务器的根路径,在goahead/LINUX/initWebs函数中修改**
修改如下两行：

static char_t  *rootWeb = T(/data/local/webroot);    /* Root web directory */
static char_t   *demoWeb = T(/data/local/webrootdemo);  /* Root web directory */
修改如下代码：

sprintf(webdir, %s/%s, dir, demoWeb);为:

sprintf(webdir, %s,  demoWeb);

修改如下代码：

sprintf(webdir, %s/%s, dir, demoWeb);为：

sprintf(webdir, %s,  rootWeb);
**6.添加监听端口的提示：**
在在goahead/webs.c的websOpenListen函数的倒数第二行增加如下代码:
fprintf(stderr,"goahead has started!\nlistener port:%d\n",port);
使goahead运行起来我们可以看到它的监听端口。

**7.编译：**

在goahead/LINUX下执行make命令进行编译，在此目录下生产webs可执行文件

**8.创建相关目录**
创建/data/local目录；
然后在此目录下创建webroot文件夹和webrootdemo文件夹；
在webroot目录下创建cgi-bin目录
在cgi-bin目录下创建tmp目录

**8.运行**
拷贝webs到android的/data/local目录下，并且修改为可执行权限，然
后在/data/local目录下，执行如下命令./webs &

**9.测试**
在/data/local/webroot文件夹下放入测试的静态网页hello.html
在android的浏览器上输入
http://ip:8080/hello.html
就可以看到hello.html网页的内容了；
在/data/local/webroot放入goahead/wwwdemo/asptest.asp
然后在android的浏览器上输入
http://ip:8080/asptest.asp,就可以看到asptest.asp的执行结果了。
在/data/local/webroot/cgi-bin目录下放入
goahead/wwwdemo/cgi- bin/cgitest
然后在android的浏览器上输入
http://ip:8080/cgi-bin/cgitest,就可以看到cgi的执行结果了。
也可以使用pc测试(前提是pc的ip应该和运行goahead程序的android或linux在同
一网段)，结果一样。
