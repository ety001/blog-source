---
author: ety001
comments: true
date: 2013-09-24 02:25:17+00:00
layout: post
slug: whats-the-suid
title: What's the SUID
wordpress_id: 2468
tags:
- Server&OS
- 理论
---



SUID的作用就是：让本来没有相应权限的用户运行这个程序时，可以访问没有权限访问的资源。

编辑摘要

### 目录

    1 UNIX下关于文件权限的表示方法和解析
    2 详细解析
    3 关于SUID和SGID的编程
    4 相关链接
    5 参考资料
    __

SUID --> Set User ID

SGID --> Set Group ID

SUID的作用就是：让本来没有相应权限的用户运行这个程序时，可以访问没有权限访问的资源。<!-- more -->

## [](http://www.baike.com/wiki/SUID#)SUID - UNIX下关于文件权限的表示方法和解析


[![SUID](http://a1.att.hudong.com/12/60/01300000082825121026604307762_s.jpg)](http://tupian.baike.com/a1_12_60_01300000082825121026604307762_jpg.html)**SUID**

[UNIX](http://www.baike.com/wiki/UNIX)下可以用ls -l 命令来看到文件权限。用ls命令所得到的表示法的格式是类似这样的：-rwxr-xr-x 。

下面解析一下格式所表示的意思，这种表示方法一共有十位：
9 8 7 6 5 4 3 2 1 0
- r w x r - x r - x

第9位表示[文件类型](http://www.baike.com/wiki/%E6%96%87%E4%BB%B6%E7%B1%BB%E5%9E%8B),可以为p、d、l、s、c、b和-：
**p表示****命名管道文件****
d表示****目录文件****
l表示****符号连接文件****
-表示****普通文件****
s表示****socket文件****
c表示****字符设备文件****
b表示****块设备文件**

第8-6位、5-3位、2-0位分别表示文件所有者的权限，同组用户的权限，其他用户的权限，其形式为rwx：
**r表示可读，可以读出文件的内容
w表示可写，可以修改文件的内容
x表示可执行，可运行这个程序
**没有权限的位置用-表示

例子：
rwxr-x---   1 foo   staff  7734 Apr 05 17:07 myfile

表示文件myfile是普通文件，文件的所有者是foo用户，而foo用户属于staff组，文件只有1个[硬连接](http://www.baike.com/wiki/%E7%A1%AC%E8%BF%9E%E6%8E%A5)，长度是7734个字节，最后修改时间4月5日17:07。

所有者foo对文件有读写执行权限，staff组的成员对文件有读和执行权限，其他的用户对这个文件没有权限。

如果一个文件被设置了SUID或SGID位，会分别表现在所有者或同组用户权限的**可执行位**上。例如
1、-rwsr-xr-x 表示SUID和所有者权限中可执行位被设置
2、-rwSr--r-- 表示SUID被设置，但所有者权限中可执行位没有被设置
3、-rwxr-sr-x 表示SGID和同组用户权限中可执行位被设置
4、-rw-r-Sr-- 表示SGID被设置，但同组用户权限中可执行位没有被设置

其实在UNIX的实现中，文件权限用12个二进[制位表](http://www.baike.com/wiki/%E5%88%B6%E4%BD%8D%E8%A1%A8)示，如果该位置上的值是1，表示有相应的权限：
11 10 9 8 7 6 5 4 3 2 1 0
S  G T r w x r w x r w x

第11位为SUID位，第10位为SGID位，第9位为[sticky](http://www.baike.com/wiki/sticky)位，第8-0位对应于上面的三组rwx位。
-rwsr-xr-x的值为： 1  0 0 1 1 1 1 0 1 1 0 1
-rw-r-Sr--的值为： 0  1 0 1 1 0 1 0 0 1 0 0

给文件加SUID和SUID的命令如下：
chmod u+s filename   设置SUID位
chmod u-s filename   去掉SUID设置
chmod g+s filename   设置SGID位
chmod g-s filename   去掉SGID设置

另外一种方法是chmod命令用八进制表示方法的设置。如果明白了前面的12位权限表示法也很简单。





## [](http://www.baike.com/wiki/SUID#)SUID - 详细解析








[![SUID](http://a1.att.hudong.com/10/63/01300000082825121026635393224_s.gif)](http://tupian.baike.com/a1_10_63_01300000082825121026635393224_gif.html)**SUID**




由于SUID和SGID是在执行程序（程序的可执行位被设置）时起作用，而可执行位只对普通文件和目录文件有意义，所以设置其他种类文件的SUID和SGID位是没有多大意义的。

**普通文件的SUID和SGID的作用**

例子：如果普通文件myfile是属于foo用户的，是可执行的，现在没设SUID位，ls命令显示如下：
-rwxr-xr-x   1 foo   staff  7734 Apr 05 17:07 myfile

任何用户都可以执行这个程序。UNIX的内核是根据什么来确定一个进程对资源的访问权限的呢？是这个进程的运行用户的（有效）[ID](http://www.baike.com/wiki/ID)，包括user id和group id。用户可以用id命令来查到自己的或其他用户的user id和group id。除了一般的user id 和group id外，还有两个称之为effective id，就是有效id，上面的四个id表示为：uid，gid，euid，egid。[内核](http://www.baike.com/wiki/%E5%86%85%E6%A0%B8)主要是根据euid和egid来确定进程对资源的访问权限。

一个进程如果没有SUID或SGID位，则euid=uid egid=gid，分别是运行这个程序的用户的uid和gid。例如kevin用户的uid和gid分别为204和202，foo用户的uid和gid为200，201，kevin运行myfile程序形成的进程的euid=uid=204，egid=gid=202，内核根据这些值来判断进程对资源访问的限制，其实就是kevin用户对资源访问的权限，和foo没关系。

如果一个程序设置了SUID，则euid和egid变成被运行的程序的所有者的uid和gid，例如kevin用户运行myfile，euid=200，egid=201，uid=204，gid=202，则这个进程具有它的属主foo的资源访问权限。

SUID的作用就是这样：让本来没有相应权限的用户运行这个程序时，可以访问没有权限访问的资源。passwd就是一个很鲜明的例子。SUID的优先级比SGID高，当一个可执行程序设置了SUID，则SGID会自动变成相应的egid。

讨论一个例子：

UNIX系统有一个/dev/kmem的设备文件，是一个字符设备文件，里面存储了核心程序要访问的数据，包括用户的口令。所以这个文件不能给一般的用户读写，权限设为：cr--r-----   1 root     system     2,  1 May 25 1998  kmem
但ps等程序要读这个文件，而ps的权限设置如下：
-r-xr-sr-x   1 bin      system     59346 Apr 05 1998  ps

这是一个设置了SGID的程序，而ps的用户是bin，不是root，所以不能设置SUID来访问kmem，bin和root都属于system组，而且ps设置了SGID，一般用户执行ps，就会获得system组用户的权限，而文件kmem的同组用户的权限是可读，所以一般用户执行ps就没问题了。但有些人说，为什么不把ps程序设置为root用户的程序，然后设置SUID位，不也行吗？这的确可以解决问题，但实际中为什么不这样做呢？因为SGID的风险比SUID小得多，所以出于系统安全的考虑，应该尽量用SGID代替SUID的程序，如果可能的话。

SUID对目录没有影响。如果一个目录设置了SGID位，那么如果任何一个用户对这个目录有写权限的话，在这个目录所建立的文件的组都会自动转为这个目录的属主所在的组，而文件所有者不变，还是属于建立这个文件的用户。





## [](http://www.baike.com/wiki/SUID#)SUID - 关于SUID和SGID的编程





和SUID和SGID[编程](http://www.baike.com/wiki/%E7%BC%96%E7%A8%8B)比较密切相关的有以下的[头文件](http://www.baike.com/wiki/%E5%A4%B4%E6%96%87%E4%BB%B6)和[函数](http://www.baike.com/wiki/%E5%87%BD%E6%95%B0)：

#include
#include

uid_t getuid(void);

uid_t [geteuid](http://www.baike.com/wiki/geteuid)(void);

gid_t getgid (void);

gid_t [getegid](http://www.baike.com/wiki/getegid) (void);

int [setuid](http://www.baike.com/wiki/setuid) (uid_t UID);

int setruid (uid_t RUID);

int seteuid (uid_t EUID);

int setreuid (uid_t RUID,uid_t EUID);

int setgid (gid_t GID);

int setrgid (gid_t RGID);

int setegid (git_t EGID);

int setregid (gid_t RGID, gid_t EGID);

## [](http://www.baike.com/wiki/SUID#)SUID - 相关链接

SGID

[UNIX](http://www.baike.com/wiki/UNIX)

## [](http://www.baike.com/wiki/SUID#)SUID - 参考资料

[http://www.moon-soft.com/doc/readelite3257.htm](http://www.moon-soft.com/doc/readelite3257.htm)

[http://lrh.yikuaiqian.com/Article/ShowArticle.asp?ArticleID=63](http://lrh.yikuaiqian.com/Article/ShowArticle.asp?ArticleID=63)
