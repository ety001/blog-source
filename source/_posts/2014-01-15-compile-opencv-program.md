---
author: ety001
comments: true
date: 2014-01-15 07:26:31
layout: post
slug: compile-opencv-program
title: 使用g++编译OpenCV程序
wordpress_id: 2554
tags:
- 编程语言
---

转自：[http://blog.csdn.net/denghp83/article/details/16951437](http://blog.csdn.net/denghp83/article/details/16951437)

源码：
```
#include
#include
#include "opencv2/core/core.hpp"
#include "opencv2/features2d/features2d.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <opencv2/opencv.hpp>
#include using namespace cv;
using namespace std;
int main()
{
Mat a;
return 1;
}
```

Makefile：
```
main: reg.cpp
g++ -o ${@} $< `pkg-config opencv --cflags --libs `
```

注意，g++语句一定要按照如上顺序来，pkg-config opencv --flags --libs(依赖文件) 一定要放在后面。（放在前面的话会出现莫名奇妙的错误）
pkg-config的解释见博文：PKG_CONFIG_PATH变量 与 ld.so.conf 文件

PKG_CONFIG_PATH变量 与 ld.so.conf 文件

文章来源：http://hi.baidu.com/dexinmeng/item/73768319cb45edf864eabf2c
一、编译和连接
一般来说，如果库的头文件不在 /usr/include 目录中，那么在编译的时候需要用 -I 参数指定其路径。由于同一个库在不同系统上可能位于不同的目录下，用户安装库的时候也可以将库安装在不同的目录下，所以即使使用同一个库，由于库的路径的不同，造成了用 -I 参数指定的头文件的路径也可能不同，其结果就是造成了编译命令界面的不统一。如果使用 -L 参数，也会造成连接界面的不统一。编译和连接界面不统一会为库的使用带来麻烦。
为了解决编译和连接界面不统一的问题，人们找到了一些解决办法。其基本思想就是：事先把库的位置信息等保存起来，需要的时候再通过特定的工具将其中有用的信息提取出来供编译和连接使用。这样，就可以做到编译和连接界面的一致性。其中，目前最为常用的库信息提取工具就是下面介绍的 pkg-config。
pkg-config 是通过库提供的一个 .pc 文件获得库的各种必要信息的，包括版本信息、编译和连接需要的参数等。这些信息可以通过 pkg-config 提供的参数单独提取出来直接供编译器和连接器使用。
The pkgconfig package contains tools for passing the include path and/or library paths to build tools during the make file execution.
pkg-config is a function that returns meta information for the specified library.
The default setting for PKG_CONFIG_PATH is /usr/lib/pkgconfig because of the prefix we use to install pkgconfig. You may add to PKG_CONFIG_PATH by exporting additional paths on your system where pkgconfig files are installed. Note that PKG_CONFIG_PATH is only needed when compiling packages, not during run-time.
在默认情况下，每个支持 pkg-config 的库对应的 .pc 文件在安装后都位于安装目录中的 lib/pkgconfig 目录下。例如，我们在上面已经将 Glib 安装在 /opt/gtk 目录下了，那么这个 Glib 库对应的 .pc 文件是 /opt/gtk/lib/pkgconfig 目录下一个叫 glib-2.0.pc 的文件：

prefix=/opt/gtk/
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

glib_genmarshal=glib-genmarshal
gobject_query=gobject-query
glib_mkenums=glib-mkenums

Name: GLib
Description: C Utility Library
Version: 2.12.13
Libs: -L${libdir} -lglib-2.0
Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include

使用 pkg-config 的 --cflags 参数可以给出在编译时所需要的选项，而 --libs 参数可以给出连接时的选项。例如，假设一个 sample.c 的程序用到了 Glib 库，就可以这样编译：
$ gcc -c `pkg-config --cflags glib-2.0` sample.c
然后这样连接：
$ gcc sample.o -o sample `pkg-config --libs glib-2.0`
或者上面两步也可以合并为以下一步：
$ gcc sample.c -o sample `pkg-config --cflags --libs glib-2.0`
可以看到：由于使用了 pkg-config 工具来获得库的选项，所以不论库安装在什么目录下，都可以使用相同的编译和连接命令，带来了编译和连接界面的统一。
使用 pkg-config 工具提取库的编译和连接参数有两个基本的前提：

库本身在安装的时候必须提供一个相应的 .pc 文件。不这样做的库说明不支持 pkg-config 工具的使用。
pkg-config 必须知道要到哪里去寻找此 .pc 文件。
GTK+ 及其依赖库支持使用 pkg-config 工具，所以剩下的问题就是如何告诉 pkg-config 到哪里去寻找库对应的 .pc 文件，这也是通过设置搜索路径来解决的。
对于支持 pkg-config 工具的 GTK+ 及其依赖库来说，库的头文件的搜索路径的设置变成了对 .pc 文件搜索路径的设置。.pc 文件的搜索路径是通过环境变量 PKG_CONFIG_PATH 来设置的，pkg-config 将按照设置路径的先后顺序进行搜索，直到找到指定的 .pc 文件为止。

安装完 Glib 后，在 bash 中应该进行如下设置：
$ export PKG_CONFIG_PATH=/opt/gtk/lib/pkgconfig:$PKG_CONFIG_PATH
可以执行下面的命令检查是否 /opt/gtk/lib/pkgconfig 路径已经设置在 PKG_CONFIG_PATH 环境变量中：
$ echo $PKG_CONFIG_PATH
这样设置之后，使用 Glib 库的其它程序或库在编译的时候 pkg-config 就知道首先要到 /opt/gtk/lib/pkgconfig 这个目录中去寻找 glib-2.0.pc 了（GTK+ 和其它的依赖库的 .pc 文件也将拷贝到这里，也会首先到这里搜索它们对应的 .pc 文件）。之后，通过 pkg-config 就可以把其中库的编译和连接参数提取出来供程序在编译和连接时使用。
另外还需要注意的是：环境变量的设置只对当前的终端窗口有效。如果到了没有进行上述设置的终端窗口中，pkg-config 将找不到新安装的 glib-2.0.pc 文件、从而可能使后面进行的安装（如 Glib 之后的 Atk 的安装）无法进行。

在我们采用的安装方案中，由于是使用环境变量对 GTK+ 及其依赖库进行的设置，所以当系统重新启动、或者新开一个终端窗口之后，如果想使用新安装的 GTK+ 库，需要如上面那样重新设置 PKG_CONFIG_PATH 和 LD_LIBRARY_PATH 环境变量。
这种使用 GTK+ 的方法，在使用之前多了一个对库进行设置的过程。虽然显得稍微繁琐了一些，但却是一种最安全的使用 GTK+ 库的方式，不会对系统上已经存在的使用了 GTK+ 库的程序（比如 GNOME 桌面）带来任何冲击。
为了使库的设置变得简单一些，可以把下面的这两句设置保存到一个文件中（比如 set_gtk-2.10 文件）:

export PKG_CONFIG_PATH=/opt/gtk/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/opt/gtk/lib:$LD_LIBRARY_PATH
之后，就可以用下面的方法进行库的设置了（其中的 source 命令也可以用 . 代替）：
$ source set_gtk-2.10
只有在用新版的 GTK+ 库开发应用程序、或者运行使用了新版 GTK+ 库的程序的时候，才有必要进行上述设置。

如果想避免使用 GTK+ 库之前上述设置的麻烦，可以把上面两个环境变量的设置在系统的配置文件中（如 /etc/profile）或者自己的用户配置文件中（如 ~/.bash_profile） ；库的搜索路径也可以设置在 /etc/ld.so.conf 文件中，等等。这种设置在系统启动时会生效，从而会导致使用 GTK+ 的程序使用新版的 GTK+ 运行库，这有可能会带来一些问题。当然，如果你发现用新版的 GTK+ 代替旧版没有什么问题的话，使用这种设置方式是比较方便的。加入到~/.bashrc中，例如：
PKG_CONFIG_PATH=/opt/gtk/lib/pkgconfig
重启之后：
[root@localhost ~]# echo $PKG_CONFIG_PATH
/opt/gtk/lib/pkgconfig

二、运行时

库文件在连接（静态库和共享库）和运行（仅限于使用共享库的程序）时被使用，其搜索路径是在系统中进行设置的。一般 Linux 系统把 /lib 和 /usr/lib 两个目录作为默认的库搜索路径，所以使用这两个目录中的库时不需要进行设置搜索路径即可直接使用。对于处于默认库搜索路径之外的库，需要将库的位置添加到库的搜索路径之中。设置库文件的搜索路径有下列两种方式，可任选其一使用：
在环境变量 LD_LIBRARY_PATH 中指明库的搜索路径。
在 /etc/ld.so.conf 文件中添加库的搜索路径。
将自己可能存放库文件的路径都加入到/etc/ld.so.conf中是明智的选择 ^_^
添加方法也极其简单，将库文件的绝对路径直接写进去就OK了，一行一个。例如：
/usr/X11R6/lib
/usr/local/lib
/opt/lib
需要注意的是：第二种搜索路径的设置方式对于程序连接时的库（包括共享库和静态库）的定位已经足够了，但是对于使用了共享库的程序的执行还是不够的。这是因为为了加快程序执行时对共享库的定位速度，避免使用搜索路径查找共享库的低效率，所以是直接读取库列表文件 /etc/ld.so.cache 从中进行搜索的。/etc/ld.so.cache 是一个非文本的数据文件，不能直接编辑，它是根据 /etc/ld.so.conf 中设置的搜索路径由 /sbin/ldconfig 命令将这些搜索路径下的共享库文件集中在一起而生成的（ldconfig 命令要以 root 权限执行）。因此，为了保证程序执行时对库的定位，在 /etc/ld.so.conf 中进行了库搜索路径的设置之后，还必须要运行 /sbin/ldconfig 命令更新 /etc/ld.so.cache 文件之后才可以。ldconfig ,简单的说，它的作用就是将/etc/ld.so.conf列出的路径下的库文件 缓存到/etc/ld.so.cache 以供使用。因此当安装完一些库文件，(例如刚安装好glib)，或者修改ld.so.conf增加新的库路径后，需要运行一下 /sbin/ldconfig使所有的库文件都被缓存到ld.so.cache中，如果没做，即使库文件明明就在/usr/lib下的，也是不会被使用的，结果编译过程中抱错，缺少xxx库，去查看发现明明就在那放着，搞的想大骂computer蠢猪一个。 ^_^
在程序连接时，对于库文件（静态库和共享库）的搜索路径，除了上面的设置方式之外，还可以通过 -L 参数显式指定。因为用 -L 设置的路径将被优先搜索，所以在连接的时候通常都会以这种方式直接指定要连接的库的路径。

前面已经说明过了，库搜索路径的设置有两种方式：在环境变量 LD_LIBRARY_PATH 中设置以及在 /etc/ld.so.conf 文件中设置。其中，第二种设置方式需要 root 权限，以改变 /etc/ld.so.conf 文件并执行 /sbin/ldconfig 命令。而且，当系统重新启动后，所有的基于 GTK2 的程序在运行时都将使用新安装的 GTK+ 库。不幸的是，由于 GTK+ 版本的改变，这有时会给应用程序带来兼容性的问题，造成某些程序运行不正常。为了避免出现上面的这些情况，在 GTK+ 及其依赖库的安装过程中对于库的搜索路径的设置将采用第一种方式进行。这种设置方式不需要 root 权限，设置也简单：
$ export LD_LIBRARY_PATH=/opt/gtk/lib:$LD_LIBRARY_PATH
可以用下面的命令查看 LD_LIBRAY_PATH 的设置内容：
$ echo $LD_LIBRARY_PATH
至此，库的两种设置就完成了。

