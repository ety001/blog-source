---
author: ety001
comments: true
date: 2012-07-07 10:44:42+00:00
layout: post
slug: the-ldd-command-using-the-principle-and-method
title: LDD命令的原理与使用方法
wordpress_id: 2141
tags:
- Server&OS
- 理论
---

转自：[http://blog.csdn.net/benben85/article/details/4161134](http://blog.csdn.net/benben85/article/details/4161134)

*作用：用来查看程式运行所需的共享库, 常用来解决程式因缺少某个库文件而不能运行的一些问题。*

ldd命令原理

1、首先ldd不是个可执行程式，而只是个shell脚本
2、ldd能够显示可执行模块的dependency，**其原理是通过设置一系列的环境变量**，如下：LD_TRACE_LOADED_OBJECTS、LD_WARN、LD_BIND_NOW、LD_LIBRARY_VERSION、LD_VERBOSE等。当LD_TRACE_LOADED_OBJECTS环境变量不为空时，所有可执行程式在运行时，他**都会只显示模块的****dependency****，而程式并不真正执行。要不你能在shell终端测试一下，如下：
(1) export LD_TRACE_LOADED_OBJECTS=1
(2) 再执行所有的程式，如ls等，看看程式的运行结果
3、ldd 显示可执行模块的dependency的工作原理，其实质是通过`ld-linux.so`（`elf`动态库的装载器）来实现的。我们知道，ld-linux.so模块会先于executable模块程式工作，并获得控制权，因此当上述的那些环境变量被设置时，ld-linux.so选择了显示可执行模块的dependency。

4、实际上能直接执行`ld-linux.so`模块，如：`/lib/ld-linux.so.2 --list program`（这相当于`ldd program`）

ldd命令使用方法(摘自ldd --help)
名称    ldd - 打印共享库的依赖关系
大纲    ldd [选项]...　文件...
描述    **ldd输出在命令行上指定的每个程式或共享库需要的共享库。**

选项

    --version
    打印ldd的版本号
    -v --verbose
    打印所有信息，例如包括符号的版本信息
    -d --data-relocs
    执行符号重部署，并报告缺少的目标对象（只对ELF格式适用）
    -r --function-relocs
    对目标对象和函数执行重新部署，并报告缺少的目标对象和函数（只对ELF格式适用）
    --help 用法信息
注意:

    ldd的标准版本和glibc2一起提供。Libc5和老版本以前提供，在一些系统中还存在。在libc5版本中长选项不支持。另一方面，glibc2版本不支持-V选项，只提供等价的--version选项。
    如果命令行中给定的库名字包含’/’，这个程式的libc5版本将使用他作为库名字；否则他将在标准位置搜索库。运行一个当前目录下的共享库，加前缀"./"。
    错误:
    ldd不能工作在a.out格式的共享库上。
    ldd不能工作在一些非常老的a.out程式上，这些程式在支持ldd的编译器发行前已创建。如果你在这种类型的程式上使用ldd，程式将尝试argc = 0的运行方式，其结果不可预知。
