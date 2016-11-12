---
author: ety001
comments: true
date: 2013-01-20 14:42:47+00:00
layout: post
slug: adding-undetected-resolutions
title: Adding undetected resolutions
wordpress_id: 2283
tags:
- Server&OS
---

From:ArchLinux Wiki [https://wiki.archlinux.org/index.php/Xrandr#Adding_undetected_resolutions](https://wiki.archlinux.org/index.php/Xrandr#Adding_undetected_resolutions)


### Adding undetected resolutions


Due to buggy hardware or drivers, your monitor's correct resolutions may not always be detected by xrandr. For example, the EDID data block queried from the monitor may be incorrect. However, we can add the desired resolutions to xrandr.

First we run `gtf` or `cvt` to get the **Modeline** for the resolution we want:

For some LCD screens (samsung 2343NW), the command "cvt -r" (= with reduced blanking) is to be used.


     $ cvt 1280 1024

     # 1280x1024 59.89 Hz (CVT 1.31M4) hsync: 63.67 kHz; pclk: 109.00 MHz
     Modeline "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync


<!-- more -->Then we create a new xrandr mode. Note that the Modeline keyword needs to be ommited.


       xrandr --newmode "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync


After creating it we need an extra step to add this new mode to our current output (VGA1). We use just the name of the mode, since the parameters have been set previously.


       xrandr --addmode VGA1 1280x1024_60.00


Now we change the resolution of the screen to the one we just added:


       xrandr --output VGA1 --mode 1280x1024_60.00


Note that these settings only take effect during this session.

If you are not sure about the resolution you will test, you may add a "sleep 5" and a safe resolution command line following, like this :


       xrandr --output VGA1 --mode 1280x1024_60.00 && sleep 5 && xrandr --newmode "1024x768-safe" 65.00 1024 1048 1184 1344 768 771 777 806 -HSync -VSync && xrandr --addmode VGA1 1024x768-safe && xrandr --output VGA1 --mode 1024x768-safe


Also, change the output to the real one : VGA1 or DVI-I-1, ...
