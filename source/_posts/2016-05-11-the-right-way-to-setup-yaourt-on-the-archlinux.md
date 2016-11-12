---
title: 在archlinux上安装yaourt
author: ety001
tags:
- Server&OS
layout: post
---
`Yaourt` 全称 `Yet Another User Repository Tool 用户的另一个软件仓库管理工具`，是玩 `Archlinux` 必备的工具，
之前一直没有好好总结下该如何安装，因为之前的wiki有简单的安装步骤足够用，但是貌似现在找不到了，那就只能从 `makepkg` 一步一步去安装了。

* 首先，安装基础开发环境， `base-devel` 主要提供了编译环境

```
# pacman -S base-devel
```

* 安装 `yajl`

```
# pacman -S yajl
```

* 安装 `package-query`,

    注意：使用 makepkg 的时候，要用非root用户; 去 https://aur.archlinux.org/packages/ 找需要的 PKGBUILD

```
$ wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=package-query -O PKGBUILD

$ makepkg

$ sudo pacman -U package-query-1.8-2-armv7h.pkg.tar.xz
```

* 安装 `yaourt`,

```
$ wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yaourt -O PKGBUILD

$ makepkg

$ sudo pacman -U yaourt-1.8.1-1-any.pkg.tar.xz
```
