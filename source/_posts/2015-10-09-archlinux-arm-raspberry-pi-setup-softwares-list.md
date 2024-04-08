---
title: 树莓派Archlinux初始化安装软件清单
author: ety001
tags:
- Server&OS
layout: post
---
#### 添加国内的源

```
Server = http://mirrors.ustc.edu.cn/archlinuxarm/$arch/$repo
```

#### 增加ssh配置，允许root用户登陆

```
# 配置文件是 /etc/ssh/sshd_config
PermitRootLogin yes
```

#### 更新系统

```
pacman -Syy
pacman -Syu
```

#### 安装 vim , base-devel , wpa_supplicant , net-tools

```
pacman -S vim base-devel wpa_supplicant net-tools iw dialog wget git
```

#### 安装yaourt

首先安装软件包组 `base-devel` , 以及 `fakeroot` 和 `sudo` 软件包，这样就不会在编译时缺少 gcc 或者 make 的问题。
安装 package-query：

```
$ wget http://mir.archlinux.fr/~tuxce/releases/package-query/package-query-1.7.tar.gz
$ tar zxvf package-query-1.7.tar.gz
$ cd package-query-1.7
$ wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=package-query
$ mv PKGBUILD?h=package-query PKGBUILD
$ makepkg -si
$ cd ..
```

安装 yaourtAUR：

```
$ wget http://mir.archlinux.fr/~tuxce/releases/yaourt/yaourt-1.7.tar.gz
$ tar zxvf yaourt-1.7.tar.gz
$ cd yaourt-1.7
$ wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yaourt
$ mv PKGBUILD?h=yaourt PKGBUILD
$ makepkg -si
$ cd ..
```

