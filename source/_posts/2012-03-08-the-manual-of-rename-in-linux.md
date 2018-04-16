---
author: ety001
comments: true
date: 2012-03-08 07:38:30+00:00
layout: post
slug: the-manual-of-rename-in-linux
title: Linux中rename命令的用法
wordpress_id: 2000
tags:
- Server&OS
---

转自：[http://hi.baidu.com/afantihome/blog/item/2a8abe1b319112fdaf513391.html](http://hi.baidu.com/afantihome/blog/item/2a8abe1b319112fdaf513391.html)

刚学习linux的时候，对文件重命名首先想到的就是rename命令，但是按照在windows下对文件重命名的方式试了N多次都没有反应，在网上一搜索，发现很多人都对rename命令知之甚少，甚至有一部分人说linux下没有rename命令，建议大家用mv命令。鉴于此，于是man rename一下，好好的研究了一下它的用法 ，在此对rename命令和mv命令在重命名文件方面做一个比较，有不足之处，希望各位博友指正！

首先来说一下mv命令，在man mv中我们可以看到对于mv命令的介绍是这样的：

mv -move(rename) files

可以看到mv命令确实有重命名的功能，但是实际应用中，它只能对单个文件重命名，命令如下：

mv [path/]oldfilename [path/]newfilename

“mv命令只能对单个文件重命名”，这实就是mv命令和rename命令的在重命名方面的根本区别。

再来说rename命令，在man rename的说明如下：

NAME

rename -Rename files

SYNOPSIS

rename from to file....

DESCRIPTION

rename will rename the specified files by replacing the first occurrence of from in their name by to.

For example, given the files foo1, ..., foo9, foo10, ..., foo278, the commands

rename foo foo0 foo?

rename foo foo0 foo??

will turn them into foo001, ..., foo009, foo010, ..., foo278.

And

rename .htm .html *.htm

will fix the extension of your html files.

可以看出rename命令是专用于文件重命名的，而且根据其后的例子可以看出，rename除了给单个文件重命名，还可以批量文件重命名。同时，值得注意一点的是，rename命令是带3个参数而不是很多人认为的2个参数。

上面的例子中给出了两种文件批量重命名的用法，而实际上，rename结合通配符使用，它的功能比上面的例子所显示的更强大。基本的通配符有以下几个：

? 可替代单个字符

* 可替代多个字符

[charset] 可替代charset集中的任意单个字符

下面以例子加以说明：

如文件夹中有这些文件foo1, ..., foo9, foo10, ..., foo278，如果使用

rename foo foo0 foo?

则它只会把foo1到foo9的文件重命名为foo01到foo09，因为?通配符只能替代单个字符，所以被重命名的文件只是有4个字符长度名称的文件，文件名中的foo被替换为foo0。

再继续使用

rename foo foo0 foo??

则文件夹中的foo01到foo99的所有文件都被重命名为foo001到foo099，而foo100及其以后的文件名都不变，因为通配符?的使用，所以只重命名5个字符长度名称的文件，文件名中的foo被替换为foo0。

如果再继续使用

rename foo foo0 foo*

则foo001到foo278的所有文件都被重命名为foo0001到foo0278，因为通配符*可替代多个字符，所以，所有以foo开头的文件都被重命名了，文件名中的foo被替换为foo0。

我们再来看通配符[charset]的用法，还是继续在上面所说的文件夹中，执行如下命令

rename foo0 foo foo0[2]*

则从foo0200到foo0278的所有文件都被重命名为foo200到foo278，文件名中的foo0被替换为foo。

在使用中，三种通配符可以一起结合使用，关于具体的其它用法就只有自己不断的摸索了。

