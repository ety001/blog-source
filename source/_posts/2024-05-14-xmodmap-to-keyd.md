---
author: ety001
title: xmodmap 的替代方案 keyd
date: 2024-05-14 17:21:15
layout: post
tags:
- 经验
---

之前尝试过好几次，使用 `xmodmap` 来修改键位，但是都是以失败告终。

每次都是以为懂了，结果都是失败。

最近在一台 Chromebook 上装了 Archlinux，再次尝试调换键位。

想把 Search 键和 左Control 键对换位置。

下面是按键对应的信息

```
--- xev 获取到两个按键的信息 ---
keycode 133 (keysym 0xffeb Super_L)
keycode  37 (keysym 0xffe3 Control_L)

--- xmodmap -pke | grep Control_L 和 grep Super_L 的信息---
keycode  37 = Control_L NoSymbol Control_L
keycode 133 = Super_L Super_L Super_L Super_L Caps_Lock Super_L Caps_Lock
keycode 206 = NoSymbol Super_L NoSymbol Super_L

--- xmodmap -pm 的信息 ---
shift       Shift_L (0x32),  Shift_R (0x3e)
lock        Caps_Lock (0x42)
control     Control_L (0x25),  Control_R (0x69)
mod1        Alt_L (0x40),  Alt_L (0xcc),  Meta_L (0xcd)
mod2        Num_Lock (0x4d)
mod3        ISO_Level5_Shift (0xcb)
mod4        Super_L (0x85),  Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
mod5        ISO_Level3_Shift (0x5c)
```

尝试创建了一份 `.Xmodmap` 配置如下：

```
remove control = Control_L
remove mod4 = Super_L
add mod4 = Control_L
add control = Super_L
keycode 37 = Super_L
keycode 133 = Control_L
```

结果失败了。

不过经过不懈搜索，发现了一个替代方案 -- [keyd](https://github.com/rvaiya/keyd).

这个项目就是为了解决各种键盘问题的，非常感谢这个项目。

同时还找到了一份 [针对 Chromebook 的 keyd 配置](https://github.com/WeirdTreeThing/cros-keyboard-map)，

通过下面的命令来获取一下按键的名字

```
sudo keyd monitor
```

根据得到的键位信息，在上面的那份配置的基础上，增加下面的内容

```
[main]
....

leftmeta = leftcontrol
leftcontrol = leftmeta
```

重新载入一下

```
sudo keyd reload
```

搞定！

咱就说，Linux 下很多东西（iptables啊，X11啊）的配置也不知道为啥搞的很反人类，明明是可以搞的这么简单的啊！