---
title: 在树莓派3B上安装archlinux arm
author: ety001
tags:
- Server&OS
layout: post
---
新买了树莓派3B，由于树莓派3B是arm v8的64位cpu，所以之前树莓派2B的archlinux包显然是不能用了。

从 <https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3#installation>
这个页面可以看到，

```
The current installation uses the 32-bit Raspberry Pi 2 armv7h root filesystem. This will be changing eventually to use our AArch64 repository to take full advantage of the ARMv8 Cortex-A53 cores.
```

当前只能安装arm v7，v8的还没有。

所以按照该页面的教程操作即可。

注意在下载filesystem的时候，下载下面的这个包

```
http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
```
