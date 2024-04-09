---
author: ety001
comments: true
date: 2013-01-19 15:24:52
layout: post
slug: linux-lib-menu-set
title: Linux 静态库与动态库搜索路径设置
wordpress_id: 2279
tags:
- Server&OS
---

1. 连接和运行时库文件搜索路径到设置

库文件在连接（静态库和共享库）和运行（仅限于使用共享库的程序）时被使用，其搜索路径是在系统中进行设置的。一般 Linux 系统把 /lib 和 /usr/lib 两个目录作为默认的库搜索路径，所以使用这两个目录中的库时不需要进行设置搜索路径即可直接使用。对于处于默认库搜索路径之外的库，需要将库的位置添加到库的搜索路径之中。设置库文件的搜索路径有下列两种方式，可任选其一使用：

(1). 在 /etc/ld.so.conf 文件中添加库的搜索路径。(或者在/etc/ld.so.conf.d 下新建一个.conf文件，将搜索路径一行一个加入-junziyang)

将自己可能存放库文件的路径都加入到/etc/ld.so.conf中是明智的选择添加方法也极其简单，将库文件的绝对路径直接写进去就OK了，一行一个。例如：

    /usr/X11R6/lib

    /usr/local/lib

    /opt/lib

需要注意的是：这种搜索路径的设置方式对于程序连接时的库（包括共享库和静态库）的定位已经足够了，但是对于使用了共享库的程序的执行还是不够的。这是因为为了加快程序执行时对共享库的定位速度，避免使用搜索路径查找共享库的低效率，所以是直接读取库列表文件 /etc/ld.so.cache 从中进行搜索的。/etc/ld.so.cache 是一个非文本的数据文件，不能直接编辑，它是根据 /etc/ld.so.conf 中设置的搜索路径由 /sbin/ldconfig 命令将这些搜索路径下的共享库文件集中在一起而生成的（ldconfig 命令要以 root 权限执行）。
<!-- more -->
因此，为了保证程序执行时对库的定位，在 /etc/ld.so.conf 中进行了库搜索路径的设置之后，还必须要运行 /sbin/ldconfig 命令更新 /etc/ld.so.cache 文件之后才可以。ldconfig ,简单的说，它的作用就是将/etc/ld.so.conf列出的路径下的库文件缓存到/etc/ld.so.cache 以供使用。因此当安装完一些库文件，(例如刚安装好glib)，或者修改ld.so.conf增加新的库路径后，需要运行一下 /sbin/ldconfig使所有的库文件都被缓存到ld.so.cache中，如果没做，即使库文件明明就在/usr/lib下的，也是不会被使用的，结果编译过程中抱错，缺少xxx库，去查看发现明明就在那放着，搞的想大骂computer蠢猪一个。

在程序连接时，对于库文件（静态库和共享库）的搜索路径，除了上面的设置方式之外，还可以通过 -L 参数显式指定。因为用 -L 设置的路径将被优先搜索，所以在连接的时候通常都会以这种方式直接指定要连接的库的路径。

这种设置方式需要 root 权限，以改变 /etc/ld.so.conf 文件并执行 /sbin/ldconfig 命令。而且，当系统重新启动后，所有的基于 GTK2 的程序在运行时都将使用新安装的 GTK+ 库。不幸的是，由于 GTK+ 版本的改变，这有时会给应用程序带来兼容性的问题，造成某些程序运行不正常。为了避免出现上面的这些情况，在 GTK+ 及其依赖库的安装过程中对于库的搜索路径的设置将采用另一种方式进行。这种设置方式不需要 root 权限，设置也简单。

(2). 在环境变量 LD_LIBRARY_PATH 中指明库的搜索路径。

设置方式：

export LD_LIBRARY_PATH=/opt/gtk/lib:$LD_LIBRARY_PATH

可以用下面的命令查看 LD_LIBRAY_PATH 的设置内容：

echo $LD_LIBRARY_PATH

至此，库的两种设置就完成了。

2.交叉编译时候如何配置连接库的搜索路径

交叉编译的时候不能使用本地（i686机器，即PC机器，研发机器）机器上的库，但是在做编译链接的时候默认的是使用本地库，即/usr/lib, /lib两个目录。因此，在交叉编译的时候，要采取一些方法使得在编译链接的时候找到需要的库。

首先，要知道：编译的时候只需要头文档，真正实际的库文档在链接的时候用到。 （这是我的理解，假如有不对的地方，敬请网上各位大侠指教） 然后，讲讲如何在交叉编译链接的时候找到需要的库。

（1）交叉编译时候直接使用-L和-I参数指定搜索非标准的库文档和头文档的路径。例如：

arm-linux-gcc test.c -L/usr/local/arm/2.95.3/arm-linux/lib -I/usr/local/arm/2.95.3/arm-linux/include

（2）使用ld.so.conf文档，将用到的库所在文档目录添加到此文档中，然后使用ldconfig命令刷新缓存。

（3）使用如下命令：

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/arm/2.95.3/arm-linux-lib

参见《ld.so.conf 文档和PKG_CONFIG_PATH变量》这篇文章。

通过环境变量LD_LIBRARY_PATH指定动态库搜索路径（！）。

通过设定环境变量LD_LIBRARY_PATH也可以指定动态库搜索路径。当通过该环境变量指定多个动态库搜索路径时，路径之间用冒号"："分隔。

不过LD_LIBRARY_PATH的设定作用是全局的，过多的使用可能会影响到其他应用程序的运行，所以多用在调试。（LD_LIBRARY_PATH 的缺陷和使用准则，可以参考《Why LD_LIBRARY_PATH is bad》 ）。通常情况下推荐还是使用gcc的-R或-rpath选项来在编译时就指定库的查找路径，并且该库的路径信息保存在可执行文件中，运行时它会直接到该路径查找库，避免了使用LD_LIBRARY_PATH环境变量查找。

（4）交叉编译时使用软件的configure参数。例如我编译minigui-1.3.3，使用如下配置：

#!/bin/bash

rm -f config.cache config.status

./configure --build=i686-linux --host=arm-linux --target=arm-linux /

CFLAGS=-I/usr/local/arm/2.95.3/arm-linux/include /

LDFLAGS=-L/usr/local/arm/2.95.3/arm-linux/lib /

--prefix=/usr/local/arm/2.95.3/arm-linux /

--enable-lite /

--disable-galqvfb /

--disable-qvfbial /

--disable-vbfsupport /

--disable-ttfsupport /

--disable-type1support /

--disable-imegb2312py /

--enable-extfullgif /

--enable-extskin /

--disable-videoqvfb /

--disable-videoecoslcd

这里我配置了CFLAGS和LDFLAGS参数，这样一来，我就不用去修改每个Makefile里-L和-I参数了，也不用再去配置 LD_LIBRARY_PATH或改写ld.so.conf文档了。


**Linux下动态库使用小结**

1. 静态库和动态库的基本概念
静态库，是在可执行程序连接时就已经加入到执行码中，在物理上成为执行程序的一部分；使用静态库编译的程序运行时无需该库文件支持，哪里都可以用，但是生成的可执行文件较大。动态库，是在可执行程序启动时加载到执行程序中，可以被多个可执行程序共享使用。使用动态库编译生成的程序相对较小，但运行时需要库文件支持，如果机器里没有这些库文件就不能运行。

2． 如何使用动态库
如何程序在连接时使用了共享库，就必须在运行的时候能够找到共享库的位置。linux的可执行程序在执行的时候默认是先搜索/lib和/usr/lib这两个目录，然后按照/etc/ld.so.conf里面的配置搜索绝对路径。同时，Linux也提供了环境变量LD_LIBRARY_PATH供用户选择使用，用户可以通过设定它来查找除默认路径之外的其他路径，如查找/work/lib路径,你可以在/etc/rc.d/rc.local或其他系统启动后即可执行到的脚本添加如下语句：LD_LIBRARY_PATH =/work/lib:$(LD_LIBRARY_PATH)。并且LD_LIBRARY_PATH路径优先于系统默认路径之前查找（详细参考《使用 LD_LIBRARY_PATH》）。

不过LD_LIBRARY_PATH的设定作用是全局的，过多的使用可能会影响到其他应用程序的运行，所以多用在调试。（LD_LIBRARY_PATH 的缺陷和使用准则，可以参考《Why LD_LIBRARY_PATH is bad》）。通常情况下推荐还是使用gcc的-R或-rpath选项来在编译时就指定库的查找路径，并且该库的路径信息保存在可执行文件中，运行时它会直接到该路径查找库，避免了使用LD_LIBRARY_PATH环境变量查找。

3．库的链接时路径和运行时路径
现代连接器在处理动态库时将链接时路径（Link-time path）和运行时路径（Run-time path）分开,用户可以通过-L指定连接时库的路径，通过-R（或-rpath）指定程序运行时库的路径，大大提高了库应用的灵活性。比如我们做嵌入式移植时#arm-linux-gcc $(CFLAGS) –o target –L/work/lib/zlib/ -llibz-1.2.3 (work/lib/zlib下是交叉编译好的zlib库)，将target编译好后我们只要把zlib库拷贝到开发板的系统默认路径下即可。或者通过- rpath（或-R ）、LD_LIBRARY_PATH指定查找路径。

