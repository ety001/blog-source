---
author: ety001
layout: post
title: win10如何安装完整的Hyper-V
tags:
- Server&OS
---

今天老板新招了个前端来做 **App** 的 **UE** 方面的工作。结果小伙无法在他的 **Windows** 上运行开发环境，而我在我的 **KVM** 虚拟出的 **Win10** 里测试下，完全没有问题啊。。。。

貌似小伙一直在等我给他找解决方案，也真是日了个狗了，这个不应该是你自己的事情吗？

尝试了一些方法都失败了，一直报错 **webpack** 找不到，应该就是他本机的环境设置的问题，但是不知道具体是什么原因。理论上讲，**nodejs** 都应该优先在当前项目目录下面寻找依赖，而在他机器上则偏偏不这样，即使你在启动命令里指定了目录路径、使用绝对路径，都不好使。。。这两天也真是日了狗了。。。

最后，我决定封装个开发环境的 **Docker** 容器。

在我的 **Mac** 里封装个镜像还是很轻松的，但是为了在 **Win10** 下安装个 **Docker Desktop** 也真是废了个劲了。

我的 **win10** 安装的是老毛子精简过的版本，2.38G，去掉了好多东西，比如最重要的 **Hyper-V**（终于说到了主题）。于是换了另外一个 **Ghost** 版的，

最终找到了下面的脚本

```
pushd "%~dp0"

dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt

for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

del hyper-v.txt

Dism /online /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
```

保存为 `.cmd` 扩展名的批处理文件，然后用管理员权限执行下，之后重启机器就可以有 **Hyper-V** 了。
