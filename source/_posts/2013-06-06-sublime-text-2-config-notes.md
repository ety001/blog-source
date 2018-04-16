---
author: ety001
comments: true
date: 2013-06-06 08:52:59+00:00
layout: post
slug: sublime-text-2-config-notes
title: sublime text 2 配置笔记
wordpress_id: 2394
tags:
- 配置
---

1、首先就是关于破解的问题，这个在网上一搜一大把，多数是windows下的，这里贴一个linux下的（build 2217），用vim打开主程序，然后转化为16进制查看

`:%!xdd`

搜索3342，找到一处3342的地方大致是这个样子 ……4333 3342 3032……，右边显示的内容也有licence之类的字样，把3342改成3242，再执行

`:%!xdd -r`

:wq

打开程序，贴入下面的序列号

`
—–BEGIN LICENSE—–
hiwanz
Unlimited User License
EA7E-26838
5B320641E6E11F5C6E16553C438A6839
72BA70FE439203367920D70E7DEB0E92
436D756177BBE49EFC9FBBB3420DB9D3
6AA8307E845B6AB8AF99D81734EEA961
02402C853F1FFF9854D94799D1317F37
1DAB52730F6CADDE701BF3BE03C34EF2
85E053D2B5E16502F4B009DE413591DE
0840D6E2CBF0A3049E2FAD940A53FF67
—–END LICENSE—–
`

就ok了。

其实我想说，如果400多块钱我能很轻松的掏出来的话，我就买个license了。<!-- more -->

2、安装package control，按Ctrl+`调出console，粘贴以下代码到底部命令行并回车：

`import urllib2,os;pf='Package Control.sublime-package';ipp=sublime.installed_packages_path();os.makedirs(ipp) if not os.path.exists(ipp) else None;open(os.path.join(ipp,pf),'wb').write(urllib2.urlopen('http://sublime.wbond.net/'+pf.replace(' ','%20')).read())`

重启Sublime Text 2。

如果在Perferences->package settings中看到package control这一项，则安装成功。

（随时补充）

