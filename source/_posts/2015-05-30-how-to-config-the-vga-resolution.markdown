---
author: ety001
layout: post
title: 如何设置Kali的外接显示器分辨率
tags:
- Server&OS
---

首先打开终端输入

```
xrandr
```

得到如下信息

```
ety001@ETYkali:~$ xrandr
Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
LVDS1 connected (normal left inverted right x axis y axis)
   1920x1080      60.0 +   59.9     40.0  
   1680x1050      60.0     59.9  
   1600x1024      60.2  
   1400x1050      60.0  
   1280x1024      60.0  
   1440x900       59.9  
   1280x960       60.0  
   1360x768       59.8     60.0  
   1152x864       60.0  
   1024x768       60.0  
   800x600        60.3     56.2  
   640x480        59.9  
VGA1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1024x768       60.0  
   800x600        60.3     56.2  
   848x480        60.0  
   640x480        59.9  
HDMI1 disconnected (normal left inverted right x axis y axis)
DP1 disconnected (normal left inverted right x axis y axis)
```

其中，LVDS1即为笔记本的显示屏幕，VGA1为外接显示器。

输入如下命令，

```
cvt 1920 1080
```

可以得到相关的分辨率配置信息，如下

```
ety001@ETYkali:~$ cvt 1920 1080
# 1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```

新建模式

```
xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```

增加模式

```
xrandr --addmode VGA1 "1920x1080_60.00"
```

接下来就能在显示配置列表中看到1920x1080的选项了。

如果希望下次开机也能自动设置，配置下家目录下面的.profile，加入下面三行即可

```
cvt 1920 1080
xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode VGA1 "1920x1080_60.00"
```

参考：http://www.ahlinux.com/ubuntu/6728.html
