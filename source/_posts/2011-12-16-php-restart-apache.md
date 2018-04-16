---
author: ety001
date: 2011-12-16 03:52:59+00:00
layout: post
title: 利用php重启apache进程
wordpress_id: 1820
tags:
- 编程语言
---

## 问题

通过php重启apache可以把apache的控制放到web页面上。
但是由于php本身的运行模式，一般而言，除非apache具备root权限，否则php连/etc都访问不了，更不用说反过来控制apache了。
因此，我们需要找到别的方法。

### 思路

通过system,exec等方法,PHP可以呼出一些权限之内的命令，或者执行一些可执行的程序。
因此我们可以事先编译一个重启apache的可执行程序，并赋予其root权限，然后让php调用该程序来实现apache的重启动。


### 具体方法


首先我们建立sample.c文件，并进行编译：

```
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  pid_t pid;
  uid_t uid,euid;
  uid=getuid();
  euid=geteuid();
  setreuid(euid,uid); //交换uid和euid，临时转让文件本身的root权限给PHP(apache)。

  if ((pid = fork()) == 0)      //生成子进程
    {
      if ((pid = fork()) > 0)    //子进程下继续生成孙进程
        {
          exit(0); //杀掉子进程
        }
      else if (pid == 0)
        {
          sleep(2);
         //由于子进程已死，因此孙进程成为孤儿进程，并自动由init进程领养。
          //此时孙进程发送消息给apache，请求其重启。
          system("apachectl -k restart");
          exit(0);
        }
    }
  else if (pid > 0)
　//程序最初的父进程在这里回收子进程。
    waitpid(pid, NULL, 0);
  return 0;
}
```

编译完该文件之后，我们需要对执行文件的权限进行一下处理


    chmod u+s sample


sample是由root建立，root编译，因此原本也只能由root执行调用。
但通过上面这个命令，其他用户也可以调用这个文件了。
然后我们在PHP中调用这个文件就可以重启apache了。


#### 一些关键点的解说

1:
重启Apache的系统命令很多，比起代码中的调用，更有名的应该是/etc/init.d/httpd restart，但是很遗憾，在本应用中这个系统命令是不能调用的，如果使用这个命令，那么Apache会在中止掉自己进程的瞬间，终止这个程序的继续运行，也就无法对自身进行重启动，因此我们需要通过发送信号给Apache，在不中止进程的情况下重启Apache，这一点非常重要。
关于apachectl -k restart的详细信息，可以参照下面的网址
[http://man.chinaunix.net/newsoft/Apache2.2_chinese_manual/stopping.html](http://man.chinaunix.net/newsoft/Apache2.2_chinese_manual/stopping.html)

2: 双重fork。 如果只是重启apache，而不在乎程序本身的动作，那么我们可以直接在代码中执行system("apachectl -k restart")而不必产生新的进程。
但是，考虑一下整个流程，如果我们这样做了，那么当我们访问PHP页面的时候，PHP(Apache)调用文件，瞬间重启自身，那么很自然，结果就是页面崩溃。
当然，Apache依然可以重启成功，但是，这一点也不优雅。
因此，使用双重fork可以让我们避免当前页面崩溃而对Apache进行重启动。

3: 更进一步的安全措施:
编译完sample后，计算其MD5值，并把该值固化到PHP中，然后在PHP中加入校验代码，以防止sample被恶意替换。

