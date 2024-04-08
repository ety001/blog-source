---
author: ety001
date: 2023-10-14 13:25:31+00:00
layout: post
title: 解决安卓12限制32个线程
tags:
- 经验
- Android
---

Android 12及以上用户在使用Termux时，有时会显示 `[Process completed (signal 9) - press Enter]`，这是因为Android 12的 `PhantomProcesskiller` 限制了应用的子进程，最大允许应用有32个子进程。

解决方案就是通过 adb 命令来修改底层的配置，命令如下：

```
adb shell device_config set_sync_disabled_for_tests persistent 
adb shell device_config put activity_manager max_phantom_processes 65536
```

这两条命令执行完，即修改最大子进程数为 65536。

补充：

可以直接在 termux 中安装 adb 工具，使用开发者工具里的无线调试来连接，并执行上面的两条指令。

```
pkg install android-tools

adb pair ip:port

adb connect ip:port
```

---

补充：

鸿蒙系统的话，执行下面的命令

```
adb shell /system/bin/device_config set_sync_disabled_for_tests persistent 
adb shell /system/bin/device_config put activity_manager max_phantom_processes 65536
```
