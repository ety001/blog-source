---
author: ety001
date: 2011-12-19 03:38:43+00:00
layout: post
title: Ubuntu 目录结构
wordpress_id: 1824
tags:
- Server&OS
---

　　以下为Ubuntu目录的主要目录结构，您稍微了解它们都包含了哪些文件就可以了，不需要记忆。


/ 根目录
│
├boot/ 启动文件。所有与系统启动有关的文件都保存在这里
│ └grub/ Grub引导器相关的文件
│
├dev/ 设备文件
├proc/ 内核与进程镜像
│
├mnt/ 临时挂载
├media/ 挂载媒体设备
│
├root/ root用户的$HOME目录
├home/
│ ├user/ 普通用户的$HOME目录
│ └.../
│
├bin/ 系统程序
├sbin/ 管理员系统程序
├lib/ 系统程序库文件
├etc/ 系统程序和大部分应用程序的全局配置文件
│ ├init.d/ SystemV风格的启动脚本
│ ├rcX.d/ 启动脚本的链接，定义运行级别
│ ├network/ 网络配置文件
│ ├X11/ 图形界面配置文件
│
├usr/
│ ├bin/ 应用程序
│ ├sbin/ 管理员应用程序
│ ├lib/ 应用程序库文件
│ ├share/ 应用程序资源文件
│ ├src/ 应用程序源代码
│ ├local/
│ │ ├soft/ 用户程序
│ │ └.../ 通常使用单独文件夹
│ ├X11R6/ 图形界面系统
│
├var/ 动态数据
│
├temp/ 临时文件
├lost+found/ 磁盘修复文件


**启动流程**
Linux系统主要通过以下步骤启动：
1、读取MBR的信息，启动Boot Manager
Windows使用NTLDR作为Boot Manager，如果您的系统中安装多个版本的Windows，您就需要在NTLDR中选择您要进入的系统。
Linux通常使用功能强大，配置灵活的GRUB作为Boot Manager，我们将在启动管理章节中向您介绍它的使用方式。
2、加载系统内核，启动init进程
init进程是Linux的根进程，所有的系统进程都是它的子进程。
3、init进程读取“/etc/inittab”文件中的信息，并进入预设的运行级别，按顺序运行该运行级别对应文件夹下的脚本。脚本通常以“start”参数启动，并指向一个系统中的程序。
通常情况下，“/etc/rcS.d/”目录下的启动脚本首先被执行，然后是“/etc/rcN.d/”目录。例如您设定的运行级别为3,那么它对应的启动目录为“/etc/rc3.d/”。
4、根据“/etc/rcS.d/”文件夹中对应的脚本启动Xwindow服务器“xorg”，Xwindow为Linux下的图形用户界面系统。
5、启动登录管理器，等待用户登录

**用户配置文件**
“/etc/”目录下的所有文件，只有root用户才有修改权限。应用软件的全局配置文件，普通用户也不能够修改，如果您想配置软件，以适应您的需求，您可以修改它的用户配置文件。
用户配置文件通常为全局配置文件的同名隐藏文件，放在您的$HOME目录下，例如：
/etc/inputrc /home/user/.inputrc
/etc/vim/vimrc /home/user/.vim/vimrc
也有少数例外，通常是系统程序
/etc/bash.bashrc /home/user/.bashrc

**需要注意的目录**
/etc 启动与系统数据文件都在这个目录下，这个目录被破坏，系统也差不多该死了。
/etc/rd.d/init.d子目录，用于存放启动一些linux服务的脚本。
/etc/rc.d/rc.local这个文件是启动执行文件/
/bin,/sbin,/usr/bin,/usr/sbin 这些是系统默认执行文件的放置目录，ROOT常用的数据都放在这几个目录中。
/bin和/usr/bin是系统用户使用的目录，/sbin和/usr/sbin是系统管理员使用的目录。
/usr/local 这事系统预留升级套件的目录。
/home 系统默认用户账号的根目录。
/var 登录、各类服务发生问题时的记录，以及常规性的服务记录都在这目录
/usr/share/man,/usr/local/man 这两个目录为放置各类套件说明文档的地方。

**Linux目录树**
[![linux directory](http://www.ibloglife.com/wp-content/uploads/2009/09/linux-directory.gif)](http://www.ibloglife.com/wp-content/uploads/2009/09/linux-directory.gif)


[![linux-directory.jpg](http://www.ibloglife.com/wp-content/uploads/2009/09/linux-directory.jpg)](http://www.ibloglife.com/wp-content/uploads/2009/09/linux-directory.jpg)

转自：[http://www.ibloglife.com/archives/ubuntu-directory-tree.html](http://www.ibloglife.com/archives/ubuntu-directory-tree.html)
