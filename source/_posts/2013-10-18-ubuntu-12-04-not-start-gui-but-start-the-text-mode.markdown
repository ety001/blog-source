---
author: ety001
comments: true
date: 2013-10-18 07:18:34+00:00
layout: post
slug: ubuntu-12-04-not-start-gui-but-start-the-text-mode
title: Ubuntu 12.04 不启动GUI直接进入命令行
wordpress_id: 2512
tags:
- Server&OS
---

修改/etc/default/grub文件中的GRUB_CMDLINE_LINUX_DEFAULT参数值为 text，再执行下update-grub 重启即可。
