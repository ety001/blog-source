---
author: ety001
date: 2023-09-29 13:25:31
layout: post
title: 安装 termux 和 proot，并安装 archlinux 桌面
tags:
- 经验
- Android
---

# 1.安装 termux
去 [https://github.com/termux/termux-app](https://github.com/termux/termux-app) 下载并安装

# 2.打开 termux 执行下面的命令
```
$ pkg update
$ pkg upgrade
$ pkg install x11-repo proot-distro pulseaudio vim
$ pkg install termux-x11-nightly virglrenderer-android
$ proot-distro install archlinux
```
上面的命令是更新 termux 的包管理，安装 x11 相关工具，安装 proot，安装声音相关内容，安装 3D 相关内容，安装 archlinux。

# 3.进入 archlinux
```
$ proot-distro login archlinux --user root --shared-tmp
```
以 root 用户身份进入 archlinux，并且跟 termux 共享 /tmp

# 4.更换 archlinux 源（/etc/pacman.d/mirrorlist）
```
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/$arch/$repo
```

# 5.更新安装archlinux相关内容
```
# pacman -Syu
# pacman -S vim firefox networkmanager xorg xorg-server pulseaudio noto-fonts-cjk git openssh fakeroot base-devel
# pacman -S xfce4 xfce4-goodies lightdm tigervnc
```

# 6.配置密码和普通用户
```
# passwd
# pacman -S sudo
# useradd -m -g users -G wheel,audio,video,storage -s /bin/bash ety001
# passwd ety001
```

# 7.配置 sudo
```
# vim /etc/sudoers

ety001  ALL=(ALL:ALL)  NOPASSWD:  ALL
```

# 8.安装 yay
```
# su ety001
$ git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

# 9.设置时区
```
# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

# 10.配置语言

修改 `/etc/locale.gen` 中 `zh_CN.`开头的注释符，并执行 `locale-gen`

配置默认语言

```
# echo "LANG=zh_CN.UTF-8" >> /etc/locale.conf
```

# 11.配置 vncserver

```
$ vncserver -localhost
```
如果是第一次启动 vncserver，会提示配置 vnc 的密码。

```
$ vncserver -kill :1
```

停止服务，然后访问 `~/.vnc/xstartup`，注释掉所有内容后，添加下面的内容

```
startxfce4 &
```

这样启动 vncserver 后，会执行启动 xfce4 桌面的命令。

这里需要注意的是，在启动 vncserver 前，还需要设置下面的环境变量

```
export DISPLAY=:1
```

# 12.启动桌面

回到 termux，创建 `start.sh` 脚本

```
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

virgl_test_server_android &

proot-distro login archlinux --user ety001 --shared-tmp -- bash -c "export DISPLAY=:1 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session vncserver :1"
```

以后，只需要打开 termux 后，执行 `start.sh` 脚本即可启动 archlinux 容器和桌面。

只需要用 vnc 软件连接 127.0.0.1:5901 即可。

另外，还需要在 xfce4 的配置面板中，关闭屏保和锁屏功能。
