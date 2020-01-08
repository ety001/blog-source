---
author: ety001
layout: post
title: 上手 Genymotion
tags:
- 教程
- Genymotion
---
由于最近需要在模拟器里搞事情，Genymotion 是个很好用的模拟器，
然而初始状态下，并不好用，需要安装很多必备软件。
这篇会简述下大致的步骤。

### 1. 安装 Genymotion
具体安装过程请去 Genymotion 的官网查看。
安装好以后，安装 `Google Nexus 5X 8.0-API26` 这个版本。

### 2. 安装 OpenGapps
安装 OpenGapps 的目的是为了使用 Google Play Store 来安装浏览器。
在 Genymotion 的 3.0.3 版本中，已经自带了 OpenGapps 的安装途径，
就在模拟器的控制栏上，如图所示

![](/upload/20191031/zSdTodxe7HzkorbjbeRDQwU3j5yrB6JaTiOsr467.png)

点击后，按照提示即可完成安装，重启后，就可以登录 Google Play Store 来安装个浏览器了。

### 3. 安装 Genymotion ARM Translation
由于 Genymotion 的模拟器是 x86 架构编译的 Android 系统，有一些 App 是不支持 X86 的，
所以我们需要安装一个翻译器。

访问 [https://github.com/m9rco/Genymotion_ARM_Translation](https://github.com/m9rco/Genymotion_ARM_Translation) 这里，
找到 Android 8.0 版本的下载包，下载后直接把 zip 包拖拽进模拟器里，
按照提示信息安装即可，完成后重启模拟器。

### 4. 安装 XPosed 框架
访问 [https://forum.xda-developers.com/showthread.php?t=3034811](https://forum.xda-developers.com/showthread.php?t=3034811) ，
在这个页面，下载 `XposedInstaller_*.apk`。

然后访问 [https://dl-xda.xposed.info/framework/](https://dl-xda.xposed.info/framework/) ，
依次打开 sdk26 / x86 目录，下载最新的 zip 包。下载完成后，拖拽入模拟器安装。

安装完重启模拟器，再拖入 `XposedInstaller_*.apk` 进行安装，完成后，重启模拟器。

### 这样一些基础软件就都完成了安装，再使用起来就方便了很多。
