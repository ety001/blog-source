---
author: ety001
comments: true
date: 2012-01-22 03:03:44+00:00
layout: post
slug: php-fpm-optimization
title: php-fpm优化
wordpress_id: 1905
tags:
- 理论
- 后端
---

转载：[http://hi.baidu.com/cpu686/blog/item/ad8caa0f05c652e1ab645709.html](http://hi.baidu.com/cpu686/blog/item/ad8caa0f05c652e1ab645709.html)

于Nginx对高并发的优良性能，故配了个Nginx+php-fpm来跑在线代理程序，是按照张宴文章配的，刚配置好时运行正常，但运行一段时间 后，网站打开很慢，打开网站后，在输入框输入要访问的网站，也慢得不行。在网站打开慢时，在SSH终端上输入命令也慢，怀疑是机房网速问题，但在ssh上 输入

w3m www.example.com

这个打开也慢，基本可以排除机房的网速问题。

当打开网站慢时，把服务器重启后，就会快起来，后来发现，用

/usr/local/webserver/php/sbin/php-fpm restart

把fastcgi重启下也会快起来，最把它加入计划任务，每小时重启下，基本保证网站不会慢，但终究不是办法。

查看了nginx.log和php-fpm.log，根据里面的错误，找了以上转载的几篇文章，总算是把问题解决了，主要修改了两个地方
1、
问题：
发现/usr/local/webserver/php/etc/php-fpm.conf文件里定义的打开文件描述符的限制数量是
<value name="rlimit_files">51200</value>
但用 命令ulimit -n查看，发现只有1024

我已在/etc/rc.local里添加了
ulimit -SHn 51200

竟然没生效

解决：
vi /etc/security/limits.conf

文件最后加上
*        soft    nofile 51200
*        hard    nofile 51200

<!-- more -->2、
问题：
用命令

netstat -np | grep 127.0.0.1:9000 |wc -l

发现只有100多

解决：
根据服务器内存情况，可以把PHP FastCGI子进程数调到100或以上，在4G内存的服务器上200就可以
服务器上内存为8G，我把PHP FastCGI子进程数调整到300

vi /usr/local/webserver/php/etc/php-fpm.conf
将max_children修改为300
<value name="max_children">300</value>

重启服务器，这样，网站打开速度快，而且稳定了。




When you running a highload website with PHP-FPM via FastCGI, the following tips may be useful to you : )
如果您高负载网站使用PHP-FPM管理FastCGI，这些技巧也许对您有用：)

1. Compile PHP’s modules as less as possible, the simple the best (fast);
1.尽量少安装PHP模块，最简单是最好（快）的

2. Increas PHP FastCGI child number to 100 and even more. Sometime, 200 is OK! ( On 4GB memory server);
2.把您的PHP FastCGI子进程数调到100或以上，在4G内存的服务器上200就可以
注：我的1g测试机，开64个是最好的，建议使用压力测试获取最佳值

3. Using SOCKET PHP FastCGI, and put into /dev/shm on Linux;
3.使用socket连接FastCGI，linux操作系统可以放在 /dev/shm中
注：在php-fpm.cnf里设置<value name="listen_address">/tmp/nginx.socket</value>就可以通过socket连接FastCGI了，/dev/shm是内存文件系统，放在内存中肯定会快了

4. Increase Linux “max open files”, using the following command (must be root):
# echo ‘ulimit -HSn 65536′ >> /etc/profile
# echo ‘ulimit -HSn 65536 >> /etc/rc.local
# source /etc/profile
4.调高linux内核打开文件数量，可以使用这些命令(必须是root帐号)
echo 'ulimit -HSn 65536' >> /etc/profile
echo 'ulimit -HSn 65536' >> /etc/rc.local
source /etc/profile
注：我是修改/etc/rc.local，加入ulimit -SHn 51200的

5. Increase PHP-FPM open file description rlimit:
# vi /path/to/php-fpm.conf
Find “<value name=”rlimit_files”>1024</value>”
Change 1024 to 4096 or higher number.
Restart PHP-FPM.
5. 增加 PHP-FPM 打开文件描述符的限制:
# vi /path/to/php-fpm.conf
找到“<value name="rlimit_files">1024</value>”
把1024 更改为 4096 或者更高.
重启 PHP-FPM.


6. Using PHP code accelerator, e.g eAccelerator, XCache. And set “cache_dir” to /dev/shm on Linux.
6.使用php代码加速器，例如 eAccelerator, XCache.在linux平台上可以把`cache_dir`指向 /dev/shm
