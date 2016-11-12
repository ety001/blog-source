---
author: ety001
comments: true
date: 2012-01-19 13:26:47+00:00
layout: post
slug: use-gtkbuilder-to-design-gtk-ui
title: 使用GtkBuilder设计Gtk+界面
wordpress_id: 1874
tags:
- 编程语言
---

作者：linuxeden管理团队c-aries
转自：[http://www.linuxeden.com/plus/view.php?aid=69290](http://www.linuxeden.com/plus/view.php?aid=69290)

Gtk+使用glade进行界面设计能有效地加快项目进度和提高程序的可维护性。
自从gtk2.12，Gtk+已经内建了GtkBuilder，用以代替使用glade编写的程序所依赖的libglade库文件。
下面介绍如何使用GtkBuilder写一个最基本的界面。

1. 使用glade设计Gtk+界面,保存为glade文件
<table cellpadding="6" width="95%" align="center" cellspacing="0" border="0" >
<tbody >
<tr >

<td bgcolor="#fdfddf" >$ ls
fsf.glade  stallman.jpg
$
</td>
</tr>
</tbody>
</table>
![](http://www.domyself.me/wp-includes/js/tinymce/plugins/wordpress/img/trans.gif)

<!-- more -->![](http://www.domyself.me/wp-includes/js/tinymce/plugins/wordpress/img/trans.gif)
2. 用gtk-builder-convert脚本(gtk+2.0默认安装该脚本)将glade代码转换成支持GtkBuilder的代码
<table cellpadding="6" width="95%" align="center" cellspacing="0" border="0" >
<tbody >
<tr >

<td bgcolor="#fdfddf" >$ gtk-builder-convert fsf.glade fsf.ui
Wrote fsf.ui
$ ls
fsf.glade  fsf.ui  stallman.jpg
$ cat fsf.ui
<?xml version="1.0"?>
<!--Generated with glade3 3.4.5 on Sun Nov 29 12:39:11 2009 -->
<interface>
<object id="window1">
<child>
<object id="vbox1">
<property name="visible">True</property>
<child>
<object id="image1">
<property name="visible">True</property>
<property name="pixbuf">stallman.jpg</property>
</object>
</child>
<child>
<object id="label1">
<property name="visible">True</property>
<property name="label" translatable="yes">Richard Stallman</property>
</object>
<packing>
<property name="position">1</property>
</packing>
</child>
</object>
</child>
</object>
</interface>
$
</td>
</tr>
</tbody>
</table>
3. 编写程序，调用GtkBuilder
<table cellpadding="6" width="95%" align="center" cellspacing="0" border="0" >
<tbody >
<tr >

<td bgcolor="#fdfddf" >$ ls
fsf.c  fsf.glade  fsf.ui  Makefile  stallman.jpg
$ cat Makefile
all:
gcc `pkg-config --cflags --libs gtk+-2.0` fsf.cclean:
rm -f *~ a.out
$ cat fsf.c
#include <gtk/gtk.h>static void window_close(GtkWidget *widget,gpointer data)
{
gtk_main_quit();
}

int main(int argc,char *argv[])
{
GtkBuilder *builder;
GError *error;
GtkWidget *window;
gtk_init(&argc,&argv);
builder=gtk_builder_new();
gtk_builder_add_from_file(builder,"fsf.ui",&error);
window=GTK_WIDGET(gtk_builder_get_object(builder,"window1"));
g_object_unref(G_OBJECT(builder));
g_signal_connect(window,"destroy",G_CALLBACK(window_close),NULL);
gtk_widget_show_all(window);
gtk_main();
return 0;
}
$
</td>
</tr>
</tbody>
</table>
4. 编译出可执行程序，运行
<table cellpadding="6" width="95%" align="center" cellspacing="0" border="0" >
<tbody >
<tr >

<td bgcolor="#fdfddf" >$ make
gcc `pkg-config --cflags --libs gtk+-2.0` fsf.c
$ ./a.out
</td>
</tr>
</tbody>
</table>
效果如下图:

[![](http://www.linuxeden.com/upimg/userup/14/12594I3U-5496.jpg)](http://www.linuxeden.com/upimg/userup/14/12594I3U-5496.jpg)

题外话:
我是在阅读cheese的源代码中发现gtkbuilder的，然后又发现了个东西
"pkg-config --cflags --libs gtk+-2.0"这一句是怎么得到的？
<table cellpadding="6" width="95%" align="center" cellspacing="0" border="0" >
<tbody >
<tr >

<td bgcolor="#fdfddf" >$ ls /usr/lib/pkgconfig/gtk+-2.0.pc
/usr/lib/pkgconfig/gtk+-2.0.pc
$ cat /usr/lib/pkgconfig/gtk+-2.0.pc
prefix=/usr
exec_prefix=${prefix}
libdir=/usr/lib
includedir=${prefix}/include
target=x11gtk_binary_version=2.10.0
gtk_host=i486-pc-linux-gnuName: GTK+
Deｓｃｒｉｐｔion: GIMP Tool Kit (${target} target)
Version: 2.12.12
Requires: gdk-${target}-2.0 atk cairo
Libs: -L${libdir} -lgtk-${target}-2.0
Cflags: -I${includedir}/gtk-2.0
$
</td>
</tr>
</tbody>
</table>
呵呵，这下明白了吧
比如说编译调用了gstreamer库的程序，就可以使用
pkg-config --cflags --libs gstreamer-0.10
pkgconfig的默认目录/usr/lib/pkgconfig下有gstreamer-0.10.pc这一数据文件
<table cellpadding="6" width="95%" align="center" cellspacing="0" border="0" >
<tbody >
<tr >

<td bgcolor="#fdfddf" >$ ls /usr/lib/pkgconfig/gstreamer-0.10.pc
/usr/lib/pkgconfig/gstreamer-0.10.pc
$
</td>
</tr>
</tbody>
</table>
Happy Hacking : )

相关资源:
1. GTK+ programs with GtkBuilder and dynamic signal handlers. | All My Brain
[http://allmybrain.com/2008/05/22/gtk-programs-with-gtkbuilder-and-dynamic-signal-handlers/](http://allmybrain.com/2008/05/22/gtk-programs-with-gtkbuilder-and-dynamic-signal-handlers/)

2. GTK+ Reference Manual -- GtkBuilder
file:///usr/share/doc/libgtk2.0-doc/gtk/GtkBuilder.html

3. GTK+ Reference Manual -- Index
file:///usr/share/doc/libgtk2.0-doc/gtk/ix01.html

注: 2和3的资源，在Debian下运行"sudo apt-get install libgtk2.0-doc"即可获取
