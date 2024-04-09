---
author: ety001
comments: true
date: 2013-06-21 01:48:46
layout: post
slug: the-proc-file-system
title: '[转]理解proc文件系统'
wordpress_id: 2410
tags:
- Server&OS
- 理论
---

转自：[http://linux.chinaunix.net/doc/2004-10-05/16.shtml](http://linux.chinaunix.net/doc/2004-10-05/16.shtml)


## /proc --- 一个虚拟文件系统


/proc 文件系统是一种内核和内核模块用来向进程 (process) 发送信息的机制 (所以叫做 /proc)。这个伪文件系统让你可以和内核内部数据结构进行交互，获取 有关进程的有用信息，在运行中 (on the fly) 改变设置 (通过改变内核参数)。 与其他文件系统不同，/proc 存在于内存之中而不是硬盘上。如果你察看文件 /proc/mounts (和 mount 命令一样列出所有已经加载的文件系统)，你会看到其中 一行是这样的：


    grep proc /proc/mounts
    /proc /proc proc rw 0 0


/proc 由内核控制，没有承载 /proc 的设备。因为 /proc 主要存放由内核控制 的状态信息，所以大部分这些信息的逻辑位置位于内核控制的内存。对 /proc 进行 一次 'ls -l' 可以看到大部分文件都是 0 字节大的；不过察看这些文件的时候，确 实可以看到一些信息。这怎么可能？这是因为 /proc 文件系统和其他常规的文件系 统一样把自己注册到虚拟文件系统层 (VFS) 了。然而，直到当 VFS 调用它，请求 文件、目录的 i-node 的时候，/proc 文件系统才根据内核中的信息建立相应的文件 和目录。

<!-- more -->




## 加载 proc 文件系统


如果系统中还没有加载 proc 文件系统，可以通过如下命令加载 proc 文件系统：

mount -t proc proc /proc

上述命令将成功加载你的 proc 文件系统。更多细节请阅读 mount 命令的 man page。




## 察看 /proc 的文件


/proc 的文件可以用于访问有关内核的状态、计算机的属性、正在运行的进程的 状态等信息。大部分 /proc 中的文件和目录提供系统物理环境最新的信息。尽管 /proc 中的文件是虚拟的，但它们仍可以使用任何文件编辑器或像'more', 'less'或 'cat'这样的程序来查看。当编辑程序试图打开一个虚拟文件时，这个文件就通过内核 中的信息被凭空地 (on the fly) 创建了。这是一些我从我的系统中得到的一些有趣 结果：


    $ ls -l /proc/cpuinfo
    -r--r--r-- 1 root root 0 Dec 25 11:01 /proc/cpuinfo

    $ file /proc/cpuinfo
    /proc/cpuinfo: empty

    $ cat /proc/cpuinfo

    processor       : 0
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 8
    model name      : Pentium III (Coppermine)
    stepping        : 6
    cpu MHz         : 1000.119
    cache size      : 256 KB
    fdiv_bug        : no
    hlt_bug         : no
    sep_bug         : no
    f00f_bug        : no
    coma_bug        : no
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 2
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
    cmov pat pse36 mmx fxsr xmm
    bogomips        : 1998.85

    processor       : 3
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 8
    model name      : Pentium III (Coppermine)
    stepping        : 6
    cpu MHz         : 1000.119
    cache size      : 256 KB
    fdiv_bug        : no
    hlt_bug         : no
    sep_bug         : no
    f00f_bug        : no
    coma_bug        : no
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 2
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
    cmov pat pse36 mmx fxsr xmm
    bogomips        : 1992.29


这是一个从双 CPU 的系统中得到的结果，上述大部分的信息十分清楚地给出了这个系 统的有用的硬件信息。有些 /proc 的文件是经过编码的，不同的工具可以被用来解释 这些编码过的信息并输出成可读的形式。这样的工具包括：'top', 'ps', 'apm' 等。




## 得到有用的系统/内核信息


proc 文件系统可以被用于收集有用的关于系统和运行中的内核的信息。下面是一些重要 的文件：




  * /proc/cpuinfo - CPU 的信息 (型号, 家族, 缓存大小等)


  * /proc/meminfo - 物理内存、交换空间等的信息


  * /proc/mounts - 已加载的文件系统的列表


  * /proc/devices - 可用设备的列表


  * /proc/filesystems - 被支持的文件系统


  * /proc/modules - 已加载的模块


  * /proc/version - 内核版本


  * /proc/cmdline - 系统启动时输入的内核命令行参数


proc 中的文件远不止上面列出的这么多。想要进一步了解的读者可以对 /proc 的每一个 文件都'more'一下或读参考文献[1]获取更多的有关 /proc 目录中的文件的信息。我建议 使用'more'而不是'cat'，除非你知道这个文件很小，因为有些文件 (比如 kcore) 可能 会非常长。




## 有关运行中的进程的信息


/proc 文件系统可以用于获取运行中的进程的信息。在 /proc 中有一些编号的子目录。每个编号的目录对应一个进程 id (PID)。这样，每一个运行中的进程 /proc 中都有一个用它的 PID 命名的目录。这些子目录中包含可以提供有关进程的状态和环境的重要细节信息的文件。让我们试着查找一个运行中的进程。


    $ ps -aef | grep mozilla
    root 32558 32425 8  22:53 pts/1  00:01:23  /usr/bin/mozilla


上述命令显示有一个正在运行的 mozilla 进程的 PID 是 32558。相对应的，/proc 中应该有一个名叫 32558 的目录


    $ ls -l /proc/32558
    total 0
    -r--r--r--    1 root  root            0 Dec 25 22:59 cmdline
    -r--r--r--    1 root  root            0 Dec 25 22:59 cpu
    lrwxrwxrwx    1 root  root            0 Dec 25 22:59 cwd -> /proc/
    -r--------    1 root  root            0 Dec 25 22:59 environ
    lrwxrwxrwx    1 root  root            0 Dec 25 22:59 exe -> /usr/bin/mozilla*
    dr-x------    2 root  root            0 Dec 25 22:59 fd/
    -r--r--r--    1 root  root            0 Dec 25 22:59 maps
    -rw-------    1 root  root            0 Dec 25 22:59 mem
    -r--r--r--    1 root  root            0 Dec 25 22:59 mounts
    lrwxrwxrwx    1 root  root            0 Dec 25 22:59 root -> //
    -r--r--r--    1 root  root            0 Dec 25 22:59 stat
    -r--r--r--    1 root  root            0 Dec 25 22:59 statm
    -r--r--r--    1 root  root            0 Dec 25 22:59 status


文件 "cmdline" 包含启动进程时调用的命令行。"envir" 进程的环境变两。 "status" 是进程的状态信息，包括启动进程的用户的用户ID (UID) 和组ID(GID) ， 父进程ID (PPID)，还有进程当前的状态，比如"Sleelping"和"Running"。 每个进程的目录都有几个符号链接，"cwd"是指向进程当前工作目录的符号 链接，"exe"指向运行的进程的可执行程序，"root"指向被这个进程看作是 根目录的目录 (通常是"/")。目录"fd"包含指向进程使用的文件描述符的链接。 "cpu"仅在运行 SMP 内核时出现，里面是按 CPU 划分的进程时间。

/proc/self 是一个有趣的子目录，它使得程序可以方便地使用 /proc 查找本进程地信息。/proc/self 是一个链接到 /proc 中访问 /proc 的进程所对应的 PID 的目录的符号链接。




## 通过 /proc 与内核交互


上面讨论的大部分 /proc 的文件是只读的。而实际上 /proc 文件系统通过 /proc 中可读写的文件提供了对内核的交互机制。写这些文件可以改变内核 的状态，因而要慎重改动这些文件。/proc/sys 目录存放所有可读写的文件 的目录，可以被用于改变内核行为。

/proc/sys/kernel - 这个目录包含反通用内核行为的信息。 /proc/sys/kernel/{domainname, hostname} 存放着机器/网络的域名和主机名。 这些文件可以用于修改这些名字。


    $ hostname
    machinename.domainname.com

    $ cat /proc/sys/kernel/domainname
    domainname.com

    $ cat /proc/sys/kernel/hostname
    machinename

    $ echo "new-machinename"  > /proc/sys/kernel/hostname

    $ hostname
    new-machinename.domainname.com


这样，通过修改 /proc 文件系统中的文件，我们可以修改主机名。很多其 他可配置的文件存在于 /proc/sys/kernel/。这里不可能列出所有这些文件， 读者可以自己去这个目录查看以得到更多细节信息。
另一个可配置的目录是 /proc/sys/net。这个目录中的文件可以 用于修改机器/网络的网络属性。比如，简单修改一个文件，你可以在网络 上瘾藏匿的计算机。


    $ echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all


这将在网络上瘾藏你的机器，因为它不响应 icmp_echo。主机将不会响应其 他主机发出的 ping 查询。


    $ ping machinename.domainname.com
    no answer from machinename.domainname.com


要改回缺省设置，只要


    $ echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all


/proc/sys 下还有许多其它可以用于改变内核属性。读者可以通过参考文献 [1], [2] 获取更多信息。




## 结论


/proc 文件系统提供了一个基于文件的 Linux 内部接口。它可以用于确定系统 的各种不同设备和进程的状态。对他们进行配置。因而，理解和应用有关这个 文件系统的知识是理解你的 Linux 系统的关键。




## 参考文献






  * [1] 有关Linux proc 文件系统的文档位于: /usr/src/linux/Documentation/filesystems/proc.txt


  * [2] RedHat Guide: The /proc File System: [http://www.redhat.com/docs/manuals/linux/RHL-7.3-Manual/ref-guide/ch-proc.html](http://www.redhat.com/docs/manuals/linux/RHL-7.3-Manual/ref-guide/ch-proc.html)


  *

