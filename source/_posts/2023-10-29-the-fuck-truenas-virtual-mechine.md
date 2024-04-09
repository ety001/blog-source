---
author: ety001
date: 2023-10-29 13:25:31
layout: post
title: 太TM坑爹的 TrueNAS 的虚拟机了
tags:
- Server&OS
- 经验
- 服务器
- TrueNas
---

这两天折腾 TrueNas，然后想要在 TrueNas 的虚拟机里安装 Archlinux。

但是安装完，总是无法引导启动。

搜索了很久，终于发现了一个小哥的安装视频，[https://www.youtube.com/watch?v=UgkuDVaU16c&ab_channel=aespa](https://www.youtube.com/watch?v=UgkuDVaU16c&ab_channel=aespa)

原来， `bootloader-id` 必须命名为 `boot`，然后 `.efi` 文件也必须从 `grubx64.efi` 手动改为 `bootx64.efi`。

这TM不是坑爹是啥？！