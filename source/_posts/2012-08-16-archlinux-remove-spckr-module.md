---
author: ety001
comments: true
date: 2012-08-16 00:38:30+00:00
layout: post
slug: archlinux-remove-spckr-module
title: Archlinux关闭机器报警音
wordpress_id: 2165
tags:
- Server&OS
---

<del>archlinux加载模块时默认加载了pcspkr，去除掉即可。去除命令：sudo rmmod pcspkr，加载命令：sudo modprobe pcspkr。但这样只能起到临时作用，如果机器启动时就禁止加载模块，那么需要编辑/etc/rc.conf，在modules中加入：！pcspkr</del>

最新方法：

在 `/etc/modprobe.d/` 中创建 `.conf` 文件，使用 `blacklist` 关键字屏蔽不需要的模块，例如如果不想装入 `pcspkr` 模块：


    /etc/modprobe.d/nobeep.conf
    # Do not load the pcspkr module on boot
    blacklist pcspkr




**注意: **`blacklist` 命令将屏蔽一个模板，所有不会自动装入，但是如果其它非屏蔽模块需要这个模块，系统依然会装入它。


要避免这个行为，可以让 modprobe 使用自定义的 `install` 命令，直接返回导入失败：


    /etc/modprobe.d/blacklist.conf
    ...
    install MODULE /bin/false
    ...


这样就可以 "屏蔽" 模块及所有依赖它的模块。

