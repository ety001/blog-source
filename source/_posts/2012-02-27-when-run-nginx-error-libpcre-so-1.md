---
author: ety001
comments: true
date: 2012-02-27 06:51:11
layout: post
slug: when-run-nginx-error-libpcre-so-1
title: Nginx启动出错
wordpress_id: 1987
tags:
- Server&OS
---

转自：[http://www.forzw.com/archives/652](http://www.forzw.com/archives/652)


启动nginx时出错。。。

/usr/local/webserver/nginx/sbin/nginx
/usr/local/webserver/nginx/sbin/nginx: error while loading shared libraries: libpcre.so.1: cannot open shared object file: No such file or directory

从错误看出是缺少lib文件导致，进一步查看下


[root@vps1 pcre-8.30]# ldd $(which /usr/local/webserver/nginx/sbin/nginx)

linux-vdso.so.1 => (0x00007fff5dd56000)
libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fa8c1857000)
libcrypt.so.1 => /lib64/libcrypt.so.1 (0x00007fa8c161f000)
libpcre.so.1 => not found
libssl.so.6 => /lib64/libssl.so.6 (0x00007fa8c13d3000)
libcrypto.so.6 => /lib64/libcrypto.so.6 (0x00007fa8c1082000)
libdl.so.2 => /lib64/libdl.so.2 (0x00007fa8c0e7e000)
libz.so.1 => /lib64/libz.so.1 (0x00007fa8c0c6a000)
libc.so.6 => /lib64/libc.so.6 (0x00007fa8c0912000)
/lib64/ld-linux-x86-64.so.2 (0x00007fa8c1a72000)
libgssapi_krb5.so.2 => /usr/lib64/libgssapi_krb5.so.2 (0x00007fa8c06e4000)
libkrb5.so.3 => /usr/lib64/libkrb5.so.3 (0x00007fa8c044f000)
libcom_err.so.2 => /lib64/libcom_err.so.2 (0x00007fa8c024d000)
libk5crypto.so.3 => /usr/lib64/libk5crypto.so.3 (0x00007fa8c0028000)
libkrb5support.so.0 => /usr/lib64/libkrb5support.so.0 (0x00007fa8bfe20000)
libkeyutils.so.1 => /lib64/libkeyutils.so.1 (0x00007fa8bfc1e000)
libresolv.so.2 => /lib64/libresolv.so.2 (0x00007fa8bfa09000)
libselinux.so.1 => /lib64/libselinux.so.1 (0x00007fa8bf7f1000)
libsepol.so.1 => /lib64/libsepol.so.1 (0x00007fa8bf5ab000)

可以看出 libpcre.so.1 => not found 并没有找到，进入/lib64目录中手动链接下

[root@vps1 lib64]# ln -s libpcre.so.0.0.1 libpcre.so.1


之后启动正常。

