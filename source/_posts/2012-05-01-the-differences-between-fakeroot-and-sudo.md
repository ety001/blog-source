---
author: ety001
comments: true
date: 2012-05-01 09:01:42+00:00
layout: post
slug: the-differences-between-fakeroot-and-sudo
title: fakeroot与sudo的区别
wordpress_id: 2103
tags:
- Server&OS
---

fakeroot不能获得root的权限，sudo可以。

fakeroot只是伪装成root，它不能改变需要root权限才能改变的文件，它只是让程序执行时按照有root权限的情况来运行，而对文件的操作实际上是在普通用户下进行的。
<table >
<tbody >
<tr >

<td >1
2
</td>

<td >fakeroot tar cvf /tmp/local.tar /usr/local
sudo tar cvf /tmp/local.tar /usr/local
</td>
</tr>
</tbody>
</table>
上面两条命令都会在/tmp下建立local.tar，tar内的文件名都会以/开头，但前一条命令生成的文件属于当前用户，后一条命令生成的文件是root的。

