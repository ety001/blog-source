---
author: ety001
comments: true
date: 2013-10-12 06:14:53
layout: post
slug: linux-unix-setuid-seteuid-setreuid-setresuid
title: linux/unix下setuid/seteuid/setreuid/setresuid
wordpress_id: 2508
tags:
- Server&OS
---

转自：[http://blog.csdn.net/scutth/article/details/6980758](http://blog.csdn.net/scutth/article/details/6980758)

其中setresuid()具有最清晰的语法：
setresuid()被执行的条件有：
①当前进程的euid是root
②三个参数，每一个等于原来某个id中的一个
如果满足以上条件的任意一个，setresuid()都可以正常调用，并执行，将
进程的ID设置成对应的ID。
例子：
如果ruid=100,euid=0,suid=300
则setresuid(200,300,100)可以执行，因为原来的euid=0.
如果ruid=100,euid=300,suid=200
则setresuid(200,300,100)也可以执行，因为这三个新的id都是原来id中的某一个。
但是setresuid(100,200,400)就不能执行，因为400不等于原来三个id中的任意一个。

setresuid()有个性质，英文名称是all-or-nothing effect，意思是，如果setresuid()
对某一个ID设置成功了，其他的失败了，比如只改变了ruid，suid和euid都改失败了
那么程序会将ruid改回原来的值，即保证要么三个ID都能成功修改，要么三个都没能修改成功。
PS：FreeBSD和Linux支持setresuid，Solaris不支持setresuid，但有自己的实现方式。<!-- more -->

seteuid()也有较清晰的语法：
无论什么情况，它只改变进程euid，而不改变ruid和suid。
如果原来的euid==0，则新的euid随意设，都可以成功改变。
如果原来的euid!=0，不同的系统的处理方式是不一样的：
-Solaris和Linux只允许新的euid等于原来三个id中的任意一个；
-但是FreeBSD只允许新的euid等于ruid和suid中的一个；
貌似FreeBSD这个限制是多余的，因为新的euid==原来的euid的时候应该是可以的，但是它会报错，不允许。

setreuid()有点小复杂：
它会修改ruid和euid，也某些情况下，也会修改suid。
而且不同的系统对setreuid也有不同的处理方式：
-在Solaris和Linux中，setreuid(geteuid(),getuid())可以实现ruid和euid的交换
-FreeBSD则会失败；

setuid()：
如果原来的euid==0，则该函数将会设置所有的id都等于新的id。
如果原来的三个id为：ruid=300,euid=0,suid=100
则setuid(200)执行以后，ruid=200,euid=200,suid=200

如果原来的euid!=0，但是新的id等于原来ruid和suid中的一个，那么也是可以执行的。否则就不能执行。
比如原来的三个id为：ruid=100，euid=200，suid=300
则setuid(300)可以执行，执行结束以后ruid=100,euid=300,suid=300（也就是说只改变了euid）。
setuid(400)就不能执行。

不同的系统有不同的处理方式：
-Linux和Solaris：如果euid不等于0，那么新的id必须等于ruid或者suid中的一个（就是我们上面说的）；
-FreeBSD待定，还没搞清楚；
setuid()的行为不仅取决于系统，还取决于进程的优先级：
-Linux和Solaris：如果euid==0，那么将三个id都设置为新的id；否则，只设置euid；
-FreeBSD：不管euid值，如果执行成功，直接设置所有的id都为新的id；

