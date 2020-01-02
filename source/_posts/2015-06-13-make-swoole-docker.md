---
author: ety001
layout: post
title: 制作swoole的docker
tags:
- Server&OS
---

1、由于使用的是docker hub 中的 `centos:6` ，因此一上来需要先安装开发包，
为了省事，我直接就用下面这条命令了：

    yum groupinstall "Development Libraries" "Development Tools"

2、去下载php官网比较新的源码，我下载的是 `php-5.6.10`。

3、安装libxml2-devel

    yum install libxml2-devel

4、解压下载后的php源码包，直接 `./configure` 然后结束后执行 `make && make install`。

5、编译安装结束后，下载swoole的源码，我下载的是 `swoole-1.7.17` ，解压，然后依次执行：
`phpize` `./configure` `make && make install`

6、编辑php.ini，加入 `extension=swoole.so`

7、安装完毕，开始瘦身，我主要是删掉 `/usr/share` `/usr/local` `/usr/src`
下面的一些文件，最终初步瘦身从800M到300M。

8、删除完文件后，回到根目录，执行

    mkdir /rootfs
    mkdir bin etc dev dev/pts lib usr proc sys tmp
    mkdir -p usr/lib64 usr/bin usr/local/bin
    wget http://busybox.net/downloads/binaries/1.21.1/busybox-x86_64 /sbin/busybox
    chmod +x /sbin/busybox
    cp /sbin/busybox bin
    busybox –install -s bin
    cp -r /bin /rootfs/bin
    cp -r /etc /rootfs/etc
    cp -r /lib /rootfs/lib
    cp -r /usr /rootfs/usr
    cd /rootfs
    tar cf /rootfs.tar .

9、把生成的 rootfs.tar 从 container 中 scp 出来，在放置 rootfs.tar 的目录下，
新建个 Dockerfile 文件，内容如下：

    FROM scratch
    MAINTAINER ety001 <work@akawa.ink>
    ADD rootfs.tar /

10、等待完成后，就可以用 `docker images` 命令看到新做的这个镜像了。
