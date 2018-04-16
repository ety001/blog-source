---
author: ety001
comments: true
date: 2013-09-16 06:43:06+00:00
layout: post
slug: linux-c-change-normal-progress-to-daemon-progress
title: Linux下的c语言网络编程-将普通进程转换为守护进程
wordpress_id: 2459
tags:
- 编程语言
---

Linux下的网络编程分为两部分：服务器编程和客户机编程。一般服务器程序在接收客户机连接请求之前，都要创建一个守护进程。守护进程是linux/Unix编程中一个非常重要的概念，因为在创建一个守护进程的时候，我们要接触到子进程、进程组、会晤期、信号机制以及文件、目录、控制终端等多个概念，因此详细地讨论一下守护进程，对初学者学习进程间关系是非常有帮助的。

首先看一段将普通进程转换为守护进程的代码：

```
/****************************************************************
function: 　　daemonize
description:　detach the server process from the current context, creating a pristine, predictable 　　　　　　　environment in which it will execute.
arguments:　　servfd file descriptor in use by server.
return value: none.
calls:　　　　none.
globals:　　　none.
****************************************************************/
void daemonize (servfd)
int servfd;
{
int childpid, fd, fdtablesize;
/* ignore terminal I/O, stop signals */
signal(SIGTTOU,SIG_IGN);
signal(SIGTTIN,SIG_IGN);
signal(SIGTSTP,SIG_IGN);
/* fork to put us in the background (whether or not the user
specified '&' on the command line */
if ((childpid = fork()) < 0) {
fputs("failed to fork first childrn",stderr);
exit(1);
}
else if (childpid > 0)
exit(0); /* terminate parent, continue in child */
/* dissociate from process group */
if (setpgrp(0,getpid())<0) {
fputs("failed to become process group leaderrn",stderr);
exit(1);
}
/* lose controlling terminal */
if ((fd = open("/dev/tty",O_RDWR)) >= 0) {
ioctl(fd,TIOCNOTTY,NULL);
close(fd);
}
/* close any open file descriptors */
for (fd = 0, fdtablesize = getdtablesize(); fd < fdtablesize; fd++)
if (fd != servfd)
close(fd);
/* set working directory to allow filesystems to be unmounted */
chdir("/");
/* clear the inherited umask */
umask(0);
/* setup zombie prevention */
signal(SIGCLD,(Sigfunc *)reap_status);
}
```

在linux系统中，如果要将一个普通进程转换为守护进程，需要执行的步骤如下：

1、调用fork（）函数创建子进程，然后中止父进程，保留子进程继续运行。因为，当一个进程是以前台进程的方式由shell启动时，如果中止了父进程，子进程就会自动转为后台进程。另外，在下一步时，我们需要创建一个新的会晤期，这就要求创建会晤期的进程不是一个进程组的组长进程。当父进程中止，子进程继续运行时，就保证了进程组的组ID与子进程的进程ID不会相等。
fork（）函数的定义为：

```
#include <sys/types.h>
#include <unistd.h>
pid_t fork(void);
```

fork（）函数被调用一次，会返回两次值。这两次返回的值分别是子进程的返回值和父进程的返回值，子进程的返回值为“0”，父进程的返回值为子进程的进程ID。如果出错返回“－1”。

1、保证进程不会获得任何控制终端。这是为了避免在关闭某些终端时会显示有程序正在运行而无法关闭的情况。这一步通常的做法是：调用函数setsid（）创建一个新的会晤期。
setsid（）函数的定义为：

```
#include <sys/types.h>
#include <unistd.h>
pid_t setsid(void);
```

在第一步里我们已经保证了调用此函数的进程不是进程组的组长，那么调用此函数将创建一个新的会晤。其结果是：首先，此进程编程该会晤期的首进程（session leader，系统默认会晤期的首进程是创建该会晤期的进程）。而且，此进程是该会晤期中的唯一进程。然后，此进程将成为一个新的进程组的组长，新进程组的组ID就是该进程的进程ID。最后，保证此进程没有控制终端，即使在调用setsid（）之前此进程拥有控制终端，在创建会晤期后这种联系也将被解除。如果调用该函数的进程是一个进程组的组长，那么函数将返回出错信息“－1”。

还有一个方法可以让进程无法获得控制终端，如下：

```
if((fd = fopen("/dev/tty",0_RDWR)) >= 0){
ioctl(fd,TIOCNOTTY,NULL);
close(fd);
}
```

其中/dev/tty是一个流设备，也是我们的终端映射。调用close（）函数将终端关闭。

3、信号处理。一般要忽略掉某些信号。信号相当于软件中断，Linux/Unix下的信号机制提供了一种处理异步事件的方法，终端用户键入引发中断的键，或是系统发出信号，这都会通过信号处理机制终止一个或多个程序的运行。

不同情况下引发的信号不同，所有的信号都有自己的名字，这些名字都是以“SIG”开头的，只是后面有所不同。我们可以通过这些名字了解到系统中到底发生了什么事。当信号出现时，我们可以要求系统进行一下三种操作：

a、忽略信号。大多数信号都采用这种处理方法，但是对SIGKILL和SIGSTOP信号不能做忽略处理。

b、捕捉信号。这是一种最为灵活的操作方式。这种处理方式的意思就是：当某种信号发生时，我们可以调用一个函数对这种情况进行响应的处理。最常见的情况是：如果捕捉到SIGCHID信号，则表示子进程已经终止，然后可作此信号的捕捉函数中调用waitpid（）函数取得该子进程的进程ID已经他的终止状态。如果进程创建了临时文件，那么就要为进程终止信号SIGTERM编写一个信号捕捉函数来清除这些临时文件。

c、执行系统的默认动作。对绝大多数信号而言，系统的默认动作都是终止该进程。

在Linux下，信号有很多种，我在这里就不一一介绍了，如果想详细地对这些信号进行了解，可以查看头文件<sigal.h>，这些信号都被定义为正整数，也就是它们的信号编号。在对信号进行处理时，必须要用到函数signal()，此函数的详细描述为：

```
#include <signal.h>
void (*signal (int signo, void (*func)(int)))(int);
```

其中参数signo为信号名，参数func的值根据我们的需要可以是以下几种情况：（1）常数SIG_DFL,表示执行系统的默认动作。（2）常数SIG_IGN，表示忽略信号。（3）收到信号后需要调用的处理函数的地址，此信号捕捉程序应该有一个整型参数但是没有返回值。signal()函数返回一个函数指针，而该指针指向的函数应该无返回值（void），这个指针其实指向以前的信号捕捉程序。

下面 回到我们的daemonize()函数上来。这个函数在创建守护进程时忽略了三个信号：

```
signal(SIGTTOU,SIG_IGN);
signal(SIGTTIN,SIG_IGN);
signal(SIGTSTP,SIG_IGN);
```

这三个信号的含义分别是：SIGTTOU表示后台进程写控制终端，SIGTTIN表示后台进程读控制终端，SIGTSTP表示终端挂起。

4．关闭不再需要的文件描述符，并为标准输入、标准输出和标准错误输出打开新的文件描述符（也可以继承父进程的标准输入、标准输出和标准错误输出文件描述符，这个操作是可选的）。在我们这段例程中，因为是代理服务器程序，而且是在执行了listen()函数之后执行这个daemonize()的，所以要保留已经转换成功的倾听套接字，所以我们可以见到这样的语句：
if (fd != servfd)
close(fd);

5．调用函数chdir("/")将当前工作目录更改为根目录。这是为了保证我们的进程不使用任何目录。否则我们的守护进程将一直占用某个目录，这可能会造成超级用户不能卸载一个文件系统。

6．调用函数umask(0)将文件方式创建屏蔽字设置为"0"。这是因为由继承得来的文件创建方式屏蔽字可能会禁止某些许可权。例如我们的守护进程需要创建一组可读可写的文件，而此守护进程从父进程那里继承来的文件创建方式屏蔽字却有可能屏蔽掉了这两种许可权，则新创建的一组文件其读或写操作就不能生效。因此要将文件方式创建屏蔽字设置为"0"。
在daemonize()函数的最后，我们可以看到这样的信号捕捉处理语句：

```
signal(SIGCLD,(Sigfunc *)reap_status);
```

这不是创建守护进程过程中必须的一步，它的作用是调用我们自定义的reap_status()函数来处理僵死进程。reap_status()在例程中的定义为：

```
/****************************************************************
function: 　　　reap_status
description: 　 handle a SIGCLD signal by reaping the exit status of the perished child, and 　　　　　　　　　　　discarding it.
arguments: 　　 none.
return value: 　none.
calls: 　　　　 none.
globals: 　　　 none.
****************************************************************/
void reap_status()
{
int pid;
union wait status;
while ((pid = wait3(&status,WNOHANG,NULL)) > 0)
; /* loop while there are more dead children */
}
```

上面信号捕捉语句的原文为：
signal(SIGCLD, reap_status);
我们刚才说过，signal()函数的第二个参数一定要有有一个整型参数但是没有返回值。而reap_status()是没有参数的，所以原来的语句在编译时无法通过。所以我在预编译部分加入了对Sigfunc()的类型定义，在这里用做对reap_status进行强制类型转换。而且在BSD系统中通常都使用SIGCHLD信号来处理子进程终止的有关信息，SIGCLD是System V中定义的一个信号名，如果将SIGCLD信号的处理方式设定为捕捉，那么内核将马上检查系统中是否存在已经终止等待处理的子进程，如果有，则立即调用信号捕捉处理程序。
一般在信号捕捉处理程序中都要调用wait()、waitpid()、wait3()或是wait4()来返回子进程的终止状态。这些"等待"函数的区别是，当要求函数"等待"的子进程还没有终止时，wait()将使其调用者阻塞；而在waitpid()的参数中可以设定使调用者不发生阻塞，wait()函数不被设置为等待哪个具体的子进程，它等待调用者所有子进程中首先终止的那个，而在调用waitpid()时却必须在参数中设定被等待的子进程ID。而wait3()和wait4()的参数分别比wait()和waitpid()还要多一个"rusage"。例程中的reap_status()就调用了函数wait3()，这个函数是BSD系统支持的，我们把它和wait4()的定义一起列出来：

```
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
pid_t wait3(int *statloc, int options, struct rusage *rusage);
pid_t wait4(pid_t pid, int *statloc, int options, struct rusage *rusage);
```

其中指针statloc如果不为"NULL"，那么它将指向返回的子进程终止状态。参数pid是我们指定的被等待的子进程的进程ID。参数options是我们的控制选择项，一般为WNOHANG或是WUNTRACED。例程中使用了选项WNOHANG，意即如果不能立即返回子进程的终止状态（譬如由于子进程还未结束），那么等待函数不阻塞，此时返回"0"。 　　　　　WUNTRACED选项的意思是如果系统支持作业控制，如果要等待的子进程的状态已经暂停，而且其状态自从暂停以来还从未报告过，则返回其状态。参数rusage如果不为"NULL"，则它将指向内核返回的由终止进程及其所有子进程使用的资源摘要，该摘要包括用户CPU时间总量、缺页次数、接收到信号的次数等。

