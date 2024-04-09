---
author: ety001
comments: true
date: 2012-06-02 09:00:18
layout: post
slug: archlinux-xfce-volume
title: ArchLinux XFCE用快捷键调节音量
wordpress_id: 2125
tags:
- Server&OS
---

安装完archlinux + xfce后发现笔记本键盘的音量调节不管用了，从archlinux的wiki上找了下，发现可以自己设置快捷键，在“设置”--》“键盘”--》“应用程序快捷键”中，选择“添加”，就可以添加新的快捷键了。

由于我用的ALSA，所以我按照下面的来设置即可，

升高音量：

```
amixer set Master 5%+
```


降低音量：

```
amixer set Master 5%-
```


静音：

```
amixer set Master toggle
```


你如果使用的是标准的XF86Audio 快捷键，在在终端输入以下内容：

```
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioRaiseVolume -n -t string -s "amixer set Master 5%+"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioLowerVolume -n -t string -s "amixer set Master 5%-"
xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/XF86AudioMute -n -t string -s "amixer set Master toggle"
```


若 `amixer set Master toggle` 不工作，尝试使用调节PCM直接调节音量(`amixer set PCM toggle`) 。

或者使用另外一条命令

```
pactl set-sink-mute 0 toggle
```

其他的内容请参考wiki，[https://wiki.archlinux.org/index.php/Xfce_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#ALSA](https://wiki.archlinux.org/index.php/Xfce_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#ALSA)

