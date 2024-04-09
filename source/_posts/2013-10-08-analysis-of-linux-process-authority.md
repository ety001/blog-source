---
author: ety001
comments: true
date: 2013-10-08 07:42:13
layout: post
slug: analysis-of-linux-process-authority
title: linux下进程权限分析
wordpress_id: 2496
tags:
- 编程语言
- Server&OS
---

转自：[http://blog.chinaunix.net/uid-27105712-id-3349522.html](http://blog.chinaunix.net/uid-27105712-id-3349522.html)

在linux下，关于文件权限，大部分人接触比较多，也比较熟悉了解.但是对进程权限一般知之甚少。本文总结一下linux系统下进程权限问题和现象。

需要强调的是，本文是linux系统下讨论，因为linux和unix有很多不同的地方，并且各个不同的unix系统也有很多不同。

先开门见山的列出本文讨论对象：ruid(实际用户id： real userid)、euid(有效用户用户:effective userid), suid(保存用户id:saved userid)、fuid(文件系统用户id)。

除了上面4个，还涉及到一个位 设置用户id位(set user id bit),，即我们通常所说的处rwx之外那个s标志位。

另外，本文主要讨论userid，groupid规则基本一样，例如rgid, egid, sgid, fgid等，本文就不做组id方面的重复讨论了。

首先，查看这几个uid的方法有两种方式：一是ps 命令 (ps -ax -o ruid -o euid -o suid -o fuid -o pid -o fname)列出这几个uid；二是查看status文件，（cat /proc/2495/status | grep Uid）。

本文创建5个test用户 test1~test5用来做本文中sample讨论使用，代表常见普通权限用户。<!-- more -->

一：文件所有者用户和程序执行者用户是同一用户的情况
int main(int argc, char *argv[])
{
while(1)sleep(1);
}
$>g++ main.cpp -o a.out

$>ll
-rwxr-xr-x. 1 test1 test 6780 Sep 16 15:32 a.out
文件所有者是test1，我们用test1用户执行a.out程序
$>su test1
$>./a.out &
$>ps -ax -o ruid -o euid -o suid -o fuid -o pid -o fname | grep a.out
502 502 502 502 3192 a.out
(看到结果是4个uid全是test1；)
现在我们用test2用户执行test1的程序看看结果
$su test2
503 503 503 503 3234 a.out
再用root用户执行
0 0 0 0 3257 a.out

看到这个结果，我们基本可以总结：在常见情况下。这四个id只受执行用户影响，不受文件owner用户影响。并且四个uid全部等于执行用户的id；

上面是我们碰到最常见最多的情况，所以导致大部分技术人员很少关心这个四个uid的区别和含义。让我们继续看看更多场景

二、出让权限给其它用户。非root用户是无法出让权限给其它用户，只有root用户才能出让。

int main(int argc, char *argv[])
{
if( setuid(503) < 0) perror ("setuid error"); while(1)sleep(1); } $>ll
-rwxr-xr-x. 1 test1 test 6780 Sep 16 15:32 a.out
使用root用户执行
$>./a.out
查看状态，所有uid都变成test2用户。
503 503 503 503 3592 a.out

把代码中setuid改成seteuid函数，会把euid和fuid改成test2用户
0 503 0 503 3614 a.out

把代码中setuid改成setfsuid函数，会把fuid改成test2用户
0 0 0 503 3636 a.out

当把代码改成下面样子
if( seteuid(503) < 0) perror ("seteuid error");
if( setfsuid(504) < 0) perror ("setfsuid error");
while(1)sleep(1);
或者
if( setfsuid(504) < 0) perror ("setfsuid error");
if( setfeuid(503) < 0) perror ("seteuid error"); while(1)sleep(1); 用root用户执行，得到都是一样的结果 0 503 0 503 3614 a.out 到了这里我来总结一下：1、setuid和seteuid是有区别的，setuid是永久的放弃root用户权限，转让给非root用户后，无法再restore到root用户，seteuid是临时放弃root用户权限，可以通过seteuid(0),restore到root权限。这点应该是总所周知的特点，本文就不举例子演示。2、seteuid 会同时改变euid和fuid都为设置的euid值。3、root用户可以通过调用setxxuid 来改变权限用户。非root用户是无法改变和转让权限用户。 权限出让使用最多的场景是类似apache或mysql程序，启动的时候使用root用户启动，设置一些root用户才能操作的系统配置。创建子进程时候通过setuid降级为nobody用户。 继续看一下s权限位对进程权限的影响 三、s标志位影响的是euid，suid，和fuid int main(int argc, char *argv[]) { while(1)sleep(1); } $>g++ main.cpp
$>ll
-rwxr-xr-x. 1 test1 test 6780 Sep 16 18:18 a.out
$>chmod u+s a.out
$>ll
-rwsr-xr-x. 1 test1 test 6780 Sep 16 18:18 a.out

使用root用户执行，查看用户ID为
0 502 502 502 4133 a.out
s权限位使用最经典的案例是passwd命令

下面我们看看他们对文件权限的影响，构建一个ruid，euid，和fuid都不同，看看创建出来的文件所有者是哪个uid

四、影响用户文件权限的是fuid，不是euid，该uid是linux特有的属性，unix系统是靠euid来判定用户权限。

int main(int argc, char *argv[])
{
if( setfsuid(503) < 0) perror ("setfsuid error"); FILE * fp = fopen("test.log", "a+"); if(fp == NULL) { perror ("fopen error"); } else { fclose(fp); } while(1)sleep(1); } 使用s权限位，文件所有者为root，执行者为test1，改变fuid为test2，这样就构造出3个uid各部相同，方便观察效果 $>ll
-rws---r-x. 1 root root 7397 Sep 16 18:53 a.out
运行查看状态，ruid为test1，euid为root，fuid为test2
502 0 0 503 4240 a.out
$>ll
-rws---r-x. 1 root root 7397 Sep 16 18:53 a.out
-rw-rw-r--. 1 test2 test 0 Sep 16 18:54 test.log

五、权限的继承，当使用fork子进程的时候，子进程全部继承父进程四个uid，和父进程uid相同；
当使用exec系列函数时候，会把suid置为euid。

