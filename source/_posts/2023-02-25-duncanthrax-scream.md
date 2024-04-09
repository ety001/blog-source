---
author: ety001
date: 2023-02-25 13:25:31
layout: post
title: 配置 duncanthrax/scream 虚拟声卡
tags:
- 配置
- 经验
---

我的服务器宿主机安装的是 PVE，上面跑着一台 Archlinux 的虚拟机作为工作机（显卡、键盘、鼠标、USB声卡直通），一台 Windows 的虚拟机作为辅助（在 Archlinux 下使用 KRDC 连接后一直开着一个窗口，用来运行没法在 Linux 下原生运行的程序，比如微信）。

最近看到 Atlas OS 不错，于是想要用 Atlas OS 重做 Windows 虚拟机。

但是问题是 Atlas OS 不支持 RDP，于是我只能选择 VNC 方式连接（tightvnc）。

但是众所周知，VNC 不支持声音传输。

搜索了一晚上，终于找到了一个牛逼的库，可以在 Windows 下实现虚拟声卡，然后通过 multicast 或者 unicast 的方式，把声音转到同局域网下的其他设备播放。

地址：[https://github.com/duncanthrax/scream](https://github.com/duncanthrax/scream)

我们的目的就是在 Windows 虚拟机安装虚拟声卡，在 Archlinux 下安装 Receiver。

Archlinux 下安装 Receiver 非常简单，直接用 Aur 库安装即可，

```
yay -S scream-git
```

安装后，启动

```
scream -u -o pulse
```

这样就指定 Receiver 用 unicast 方式接收数据，然后转给 pulseaudio 进行播放。

然后去 [duncanthrax/scream](https://github.com/duncanthrax/scream) 库的 Release 页面下载最新版本。

解压后，找到安装 bat 脚本，选择 x64 架构的，右键，用管理员权限执行。

这里在 Atlas 下有个问题，就是 Atlas 把 netlogon 服务给干掉了，导致 bat 脚本的 `net session` 执行失败，进而检查用户权限失败，进而无法安装。解决方法就是用记事本编辑 bat 脚本，把里面的 if 部分去掉，然后再用管理员权限执行，即可完成安装。

之后，需要配置 Windows 端也使用 unicast 。

![image.png](https://cdn.steemitimages.com/DQmSXbJXEvpdpqMTLnVDbu491GQncxZzavgUTEXrd7ii8Ld/image.png)

按照图片在注册表中新建指定内容即可，一个配置指向 IP，一个配置指向端口，截图里的端口是 4011，Receiver 的默认端口是 4010。

修改完注册表，需要重启计算机，之后就能在 Windows 里播放声音测试了。

测试没有问题，我们需要在 Receiver 端配置开启启动，

新建 `~/.config/systemd/user/scream.service` 文件，内容如下：

```
[Unit]
Description=scream

[Service]
ExecStart=/usr/bin/scream -u -p 4011 -o pulse
Restart=always

[Install]
WantedBy=default.target
```

然后执行下面的命令，设置为开机自启动

```
$ systemctl --user enable scream
```

最后重启下 Archlinux 试试。
