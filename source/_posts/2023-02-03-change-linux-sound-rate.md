---
author: ety001
date: 2023-02-03 13:25:31
layout: post
title: 调整声卡程序的采样率
tags:
- 配置
- 经验
---

最近服务器加装了带供电的 PCIe 转 USB 的板卡，然后发现接在上面的 USB 声卡，挂载到 Linux 的虚拟机里有噪音，但是挂载到 Windows 的虚拟机里没有噪音。

搜索了很多内容，最终找到了解决方案，修改了一下采样率，让人难受了两个月的问题终于解决。

```
$ vim  ~/.config/pulse/daemon.conf
添加下面的配置
default-sample-rate = 48000
保存退出，重启 pulseaudio

$ pulseaudio -k
$ pulseaudio --start
```
