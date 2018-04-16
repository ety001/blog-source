---
author: ety001
date: 2010-12-27 06:22:15+00:00
layout: post
title: apache限制并发数 IP 带宽设置教程
wordpress_id: 791
tags:
- 理论
- 后端
---

**限制并发数**
下载模块：

到官方网址： [http://www.nowhere-land.org/programs/mod_vhost_limit/](http://www.nowhere-land.org/programs/mod_vhost_limit/)下载模块

http://www.nowhere-land.org/programs/mod_vhost_limit/mod_vhost_limit-0.4.tar.gz

安装：
apxs -c mod_vhost_limit.c -o /path/to/libexec/mod_vhost_limit.so

在 httpd.conf 加入：

LoadModule vhost_limit_module libexec/mod_vhost_limit.so
AddModule mod_vhost_limit.c

配置：

MaxClients 150
ExtendedStatus On

NameVirtualHost *

<VIRTUALHOST * />
ServerName       server1
DocumentRoot     /some/where/1
MaxVhostClients  100

<VIRTUALHOST * />
ServerName       server2
DocumentRoot     /some/where/2
MaxVhostClients  30

<VIRTUALHOST * />
ServerName       server3
DocumentRoot     /some/where/3

其中： server1 被限制为 100 个并发线程数。 server2 被限制为 30 个并发线程数。 server3 没有被限制。

注：需 mod_status 的 ExtendedStatus On 支持！！

如超出限制的并发数在客户端就会出现503错误

**<!-- more -->----------------------------------------------------------------------------------------------**

**限制****IP****连接数**** **

到这里下载模块 [http://dominia.org/djao/limit/mod_limitipconn-0.04.tar.gz](http://dominia.org/djao/limit/mod_limitipconn-0.04.tar.gz)

安装:
tar zxvf mod_limitipconn-0.04.tar.gz
cd mod_limitipconn-0.04
make APXS=/usr/local/apache/bin/apxs  ß-----这里要按你自己的路径设置
make install APXS=/usr/local/apache/bin/apxs ß-----这里要按你自己的路径设置

编辑httpd.conf
添��
全局变量:
< IfModule mod_limitipconn.c >
< Location / >   # 所有虚拟主机的/目录
MaxConnPerIP 3     # 每IP只允许3个并发连接
NoIPLimit image/*  # 对图片不做IP限制
< /Location >

< Location /mp3 >  # 所有主机的/mp3目录
MaxConnPerIP 1         # 每IP只允许一个连接请求
OnlyIPLimit audio/mpeg video    # 该限制只对视频和音频格式的文件
< /Location >
< /IfModule >

或者虚拟主机的:
< VirtualHost xx.xxx.xx.xx > ##ip 地址
ServerAdmin [easy@phpv.net](mailto:easy@phpv.net)
DocumentRoot /home/easy
ServerName www.phpv.net
< IfModule mod_limitipconn.c >
< Location / >
MaxConnPerIP 5
NoIPLimit image/*
< /Location >
< Location /mp3 >    # 所有主机的/mp3目录
MaxConnPerIP 2         # 每IP只允许一个连接请求
OnlyIPLimit audio/mpeg video # 该限制只对视频和音频格式的文件
< /Location >
< /IfModule >
< /VirtualHost >

** **

**----------------------------------------------------------------------------------------------**

**限制带宽：**

下载模块 [ftp://ftp.cohprog.com/pub/apache/module/1.3.0/mod_bandwidth.c](ftp://ftp.cohprog.com/pub/apache/module/1.3.0/mod_bandwidth.c)
安装:
/usr/local/apache/bin/apxs -c ./mod_bandwidth.c -o /usr/local/apache/libexec/mod_bandwidth.so

<-------以上/usr/local/apache请设置为你的路径

编辑httpd.conf
添加：
LoadModule bandwidth_module libexec/mod_bandwidth.so
AddModule mod_bandwidth.c

重启你的apache

相关文档：

**Global configuration directives :**




  * **BandWidthDataDir**
Syntax : BandWidthDataDir <directory>
Default : "/tmp/apachebw"
Context : server config


Sets the name of the root directory used by mod_bandwidth to store its internal temporary information. Don't forget to create the needed directories : <directory>/master and <directory>/link


  * **BandWidthModule**
Syntax : BandWidthModule <On|Off>
Default : Off
Context : per server config


Enable or disable totaly the whole module. By default, the module is disable so it is safe to compile it in the server anyway.

PLEASE, NOTE THAT IF YOU SET A BANDWIDTH LIMIT INSIDE A VIRTUALHOST BLOCK, YOU ALSO __NEED__ TO PUT THE "BandWidthModule On" DIRECTIVE INSIDE THAT VIRTUALHOST BLOCK !

IF YOU SET BANDWIDTH LIMITS INSIDE DIRECTORY BLOCKS (OUTSIDE OF ANY VIRTUALHOST BLOCK), YOU ONLY NEED TO PUT THE "BandWidthModule On" DIRECTIVE ONCE, OUTSIDE OF ANY VIRTUALHOST OR DIRECTORY BLOCK.


  * **BandWidthPulse**
Syntax : BandWidthPulse <microseconds>
Default :
Context : per server config


Change the algorithm used to calculate bandwidth and transmit data. In normal mode (old mode), the module try to transmit data in packets of 1KB. That mean that if the bandwidth available is of 512B, the module will transmit 1KB, wait 2 seconds, transmit another 1KB and so one.

Seting a value with "BandWidthPulse", will change the algorithm so that the server will always wait the same amount of time between sending packets but the size of the packets will change. The value is in microseconds. For example, if you set "BandWidthPulse 1000000" (1 sec) and the bandwidth available is of 512B, the sever will transmit 512B, wait 1 second, transmit 512B and so on.

The advantage is a smother flow of data. The disadvantage is a bigger overhead of data transmited for packet header. Setting too small a value (bellow 1/5 of a sec) is not realy useful and will put more load on the system and generate more traffic for packet header.

Note also that the operating system may do some buffering on it's own and so defeat the purpose of setting small values.

This may be very useful on especialy crowded network connection : In normal mode, several seconds may happen between the sending of a full packet. This may lead to timeout or people may believe that the connection is hanging. Seting a value of 1000000 (1 sec) would guarantee that some data are sent every seconds...

