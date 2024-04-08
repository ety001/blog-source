---
author: ety001
comments: true
date: 2012-03-15 06:55:07+00:00
layout: post
slug: unixbench
title: UnixBench：测试Linux VPS性能
wordpress_id: 2018
tags:
- Server&OS
---

转自：http://www.vpser.net/opt/unixbench.html

UnixBench是一款不错的Linux下的VPS性能测试软件，现在说一下具体用法。

UnixBench 4.10 下载地址：[http://soft.vpser.net/test/unixbench/unixbench-4.1.0-wht.tar.gz](http://soft.vpser.net/test/unixbench/unixbench-4.1.0-wht.tar.gz)

[root@noc ~]# wget http://soft.vpser.net/test/unixbench/unixbench-4.1.0-wht.tar.gz


[root@noc ~]# tar xzf unixbench-4.1.0-wht.tar.gz
[root@noc ~]# ls
unixbench-4.1.0-wht-2  unixbench-4.1.0-wht.tar.gz


[root@noc ~]# cd unixbench-4.1.0-wht-2/
[root@noc unixbench-4.1.0-wht-2]# make
如果遇到 Error: Please install /usr/bin/time. 错误提示
centos/fedora 下运行 yum install time
ubuntu/debian 下运行 apt-get install time

[root@noc unixbench-4.1.0-wht-2]# ./Run

-----------------------以上为转载内容-----------------------

```
-----------------------下面是我现在博客用vps性能测试-----------------------

==============================================================
BYTE UNIX Benchmarks (Version 4.1-wht.2)
System -- Linux MyVPS1128 2.6.18-274.17.1.el5xen #1 SMP Tue Jan 10 18:45:09 EST 2012 i686 i686 i386 GNU/Linux
                      16061852   3311812  11922776  22% /

Start Benchmark Run: Thu Mar 15 14:46:20 CST 2012
 14:46:20 up 25 days, 16:12,  2 users,  load average: 0.00, 0.00, 0.00

End Benchmark Run: Thu Mar 15 14:57:03 CST 2012
 14:57:03 up 25 days, 16:22,  1 user,  load average: 15.58, 6.74, 2.98


                     INDEX VALUES            
TEST                                        BASELINE     RESULT      INDEX

Dhrystone 2 using register variables        376783.7 10077205.9      267.5
Double-Precision Whetstone                      83.1     1262.3      151.9
Execl Throughput                               188.3     2721.0      144.5
File Copy 1024 bufsize 2000 maxblocks         2672.0    87593.0      327.8
File Copy 256 bufsize 500 maxblocks           1077.0    27004.0      250.7
File Read 4096 bufsize 8000 maxblocks        15382.0   641324.0      416.9
Pipe-based Context Switching                 15448.6   138134.4       89.4
Pipe Throughput                             111814.6   851785.8       76.2
Process Creation                               569.3     3992.0       70.1
Shell Scripts (8 concurrent)                    44.8      553.8      123.6
System Call Overhead                        114433.5   558929.2       48.8
                                                                 =========
     FINAL SCORE                                                     144.7
```

