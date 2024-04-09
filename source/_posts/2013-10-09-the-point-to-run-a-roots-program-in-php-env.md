---
author: ety001
comments: true
date: 2013-10-09 00:35:13
layout: post
slug: the-point-to-run-a-roots-program-in-php-env
title: 关于php执行root权限的命令的实现要点
wordpress_id: 2498
tags:
- 编程语言
- Server&OS
---

网上说的方法都是写一个C程来实现一个中间件，但是貌似好像我看到的文章漏掉了一个比较关键的点，那就是关于S标记位的设置。如果对于s标记位很熟悉的话，那么我觉得文章漏掉了这个点应该不会对自己调试有影响，但是像我这样还不了的人来说，这就是致命的了。s标记位的目的就是在于让一个非程序的拥有者用户临时具有程序拥有者的权限，这一点由于网上的文章没有指明，所以如果只是在普通用户下进行chmod u+s 的话，程序肯定不会执行成功，因为还缺少chown这一步，得先把编译出来的程序的属主修改成root用户，然后这个s标记位才会起到应用的作用，这样程序中的geteuid获取到的值才是root的uid。

最后附上代码：

```
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char** argv)
{
    uid_t uid ,euid;

    uid = getuid() ;
    euid = geteuid();

    if(setreuid(euid, uid))  //交换这两个id
        perror("setreuid");

    system('iptables -L');
    return 0;
}
```

