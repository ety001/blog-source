---
author: ety001
title: 解决 Linux 键盘长按不连发：USB 音频设备的 HID 干扰
date: 2026-07-05 23:01:48
layout: post
tags:
- 经验
- Linux
- X11
- 硬件
---

## 问题现象

最近本地键盘出现一个诡异的小 bug：**常按方向键时光标只移动一次，不会连续移动**。而且不是 100% 复现：

- 重启后通常能恢复；
- 有时候莫名其妙就好了；
- 刚刚插拔一次 USB 耳机（AB13x）之后也好了。

系统环境：Archlinux + XFCE + X11，键盘是 HHKB Classic，同时挂着 `keyd` 做键位映射。

## 排查过程

### 1. 先看 X11 的 key repeat 设置

```bash
xset q | grep -A 2 "auto repeat"
```

输出正常：

```
auto repeat:  on    key click percent:  0    LED mask:  00002
auto repeat delay:  500    repeat rate:  20
```

连发开关是开着的，参数也正常，问题不在 X11 的 repeat 配置。

### 2. 查看 X11 识别到的键盘设备

```bash
xinput list
```

输出里出现了很多“键盘”：

```
⎣ Virtual core keyboard                    id=3
    ↳ Virtual core XTEST keyboard              id=5
    ↳ C-Media Electronics Inc. USB Audio Device  id=11
    ↳ Video Bus                                id=12
    ↳ Power Button                             id=13
    ↳ AT Translated Set 2 keyboard             id=14
    ↳ keyd virtual keyboard                    id=15
    ↳ Logitech MX Vertical                     id=17
    ↳ PFU Limited HHKB-Classic                 id=8
    ↳ PFU Limited HHKB-Classic Keyboard        id=9
    ↳ PFU Limited HHKB-Classic Consumer Control id=10
    ↳ Generic AB13X USB Audio                  id=6
```

注意其中两个设备：

- `Generic AB13X USB Audio`（就是插拔后能让问题暂时消失的 USB 耳机）；
- `C-Media Electronics Inc. USB Audio Device`（另一个 USB 音频设备）。

它们明明是音频设备，却被 X11 识别成了键盘。

### 3. 查看内核 input 设备

```bash
cat /proc/bus/input/devices
```

相关片段：

```
N: Name="C-Media Electronics Inc. USB Audio Device"
H: Handlers=kbd event8
B: EV=13
B: KEY=e000000000000 0

N: Name="Generic AB13X USB Audio"
H: Handlers=kbd event3
B: EV=13
B: KEY=3800000000 c000000000000 0
```

两个设备都被内核挂到了 `kbd` handler 上，意味着它们会通过 evdev 向用户空间发送 key 事件。AB13X 的 KEY bitmap 里包含音量加减键（114/115），这就是 USB 耳机上的媒体控制被暴露成了 HID 键盘。

### 4. 为什么音频设备会干扰真实键盘的连发？

X11 的 key repeat 是全局计时器管理的。当系统里存在多个“键盘”时，某些 USB 音频设备的 HID 接口会时不时发送事件（或者仅仅因为被枚举为键盘），这会干扰 X11 对真实键盘长按状态的计时，表现为“按一次只触发一次”。

这也能解释为什么：**插拔 AB13X 耳机后问题会暂时消失**——因为插拔让 X11 重新枚举了键盘设备，清除了干扰状态。

## 解决方案

目标很明确：让 X11 不再把这两个 USB 音频设备当作键盘。音频功能完全不受影响，只是禁用它们的 HID 媒体按键（如果原本能用的话）。

### 1. 立即生效（当前会话）

```bash
xinput disable 'Generic AB13X USB Audio'
xinput disable 'C-Media Electronics Inc. USB Audio Device'
```

执行后 `xinput list` 会显示它们变成了 `[floating slave]`，不再挂载到主键盘下。

### 2. 持久生效（重启后仍然有效）

创建 X11 InputClass 配置：

```bash
sudo tee /etc/X11/xorg.conf.d/50-ignore-usb-audio-keyboards.conf <<'XORG'
# USB audio devices sometimes expose HID media/volume controls as keyboards.
# When X11 treats them as keyboards, they can interfere with key repeat
# on real keyboards (e.g. long-press arrow keys only fire once).
# These devices still work for audio; we just prevent X from using them
# as input devices.

Section "InputClass"
    Identifier "Ignore AB13X USB Audio as keyboard"
    MatchProduct "AB13X"
    Option "Ignore" "on"
EndSection

Section "InputClass"
    Identifier "Ignore C-Media USB Audio as keyboard"
    MatchProduct "C-Media Electronics Inc. USB Audio Device"
    Option "Ignore" "on"
EndSection
XORG
```

下次登录/重启 X11 后配置自动生效。

## 验证

执行完 `xinput disable` 后，立即长按方向键测试，连发应该已经恢复。如果想确认持久配置是否生效，可以重启后在终端里再看：

```bash
xinput list | grep -i "AB13X\|C-Media"
```

应该看到类似下面这样（floating slave 表示被忽略）：

```
∼ C-Media Electronics Inc. USB Audio Device  id=11  [floating slave]
∼ Generic AB13X USB Audio                   id=6   [floating slave]
```

## 副作用

- 这两个 USB 音频设备的**音量/静音等物理按键**会失效（如果它们之前有效的话）。
- **音频播放、通话、麦克风功能完全不受影响**。

如果之后发现还需要用耳机上的音量键，可以只保留 AB13X 的配置，或者改用 `xinput float` 而不是 `Ignore`，灵活处理。

## 附：keyd 的小提示

排查过程中还发现 `keyd` 的配置里有警告：

```
WARNING: ... You should use layer(control) instead of assigning to leftcontrol directly.
```

当前配置：

```ini
leftcontrol = capslock
capslock = leftcontrol
```

虽然这和连发问题关系不大，但建议把 `capslock = leftcontrol` 改成 `capslock = layer(control)`，避免 keyd 后续版本行为变化。

## 总结

Linux 下 USB 音频设备（尤其是带线控的耳机）经常会把自己的媒体控制暴露成 HID 键盘。当 X11 同时管理这些“伪键盘”和真实键盘时，就可能出现长按不连发这种玄学问题。通过 `xinput disable` 临时禁用、配合 `xorg.conf.d` 持久忽略，可以彻底解决问题。
