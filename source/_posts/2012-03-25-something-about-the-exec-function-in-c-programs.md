---
author: ety001
comments: true
date: 2012-03-25 08:51:03+00:00
layout: post
slug: something-about-the-exec-function-in-c-programs
title: 关于linux下c语言中的exec简单笔记
wordpress_id: 2053
tags:
- 编程语言
---

exec函数族的函数说明如下：

```
#include <unistd.h>
int execl(const char *pathname,const char *arg, ...);
int execlp(const char *filename,const char *arg, ...);
int execle(const char *pathname,const char *arg, ... , char *const envp[]);
int execv(const char *pathname,char *const argv[]);
int execvp(const char *filename,char *const argv[]);
int execve(const char *pathname,char *const argv[],char *const envp[]);
```

函数名中含有字母“ l ”的函数，其参数个数不定。其参数由所谓调用程序的命令行参数列表组成，最后一个NULL表示结束。函数名中含有字母“ v ”的函数，则是使用一个字符串数组指针argv指向参数列表，这一字符串数组和含有“ l ”的函数中的参数列表完全相同，也同样以NULL结束。

函数名中含有字母“ p ”的函数可以自动在环境变量PATH指定的路径中搜索要执行的程序。因此它的第一个参数为filename表示可执行函数的文件名。而其他函数则需要用户在参数列表中指定该程序路径，其第一个参数pathname是路径名。路径的指定可以是绝对路径，也可以是相对路径。但出于对系统安全的考虑，建议使用绝对路径而尽量避免使用相对路径。

函数名中含有字母“ e ”的函数，比其他函数多含有一个参数envp。该参数是字符串数组指针，用于制定环境变量。调用这两个函数时，可以由用户自行设定子进程的环境变量，存放在参数envp所指向的字符串数组中。这个字符串数组也必须由NULL结束。其他函数则是接收当前环境变量。

