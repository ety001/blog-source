---
author: ety001
date: 2017-12-13 22:04:00
layout: post
title: 解决frp在Archlinux下安装时文件验证失败的方法
tags: Server&OS
---
使用 `yaourt` 安装 `frp` 的时候，报告以下的错误:

```
==> Validating source files with sha256sums...
    frps.service ... FAILED
    frpc.service ... FAILED
    frps@.service ... FAILED
    frpc@.service ... FAILED
==> ERROR: One or more files did not pass the validity check!
:: failed to verify frp integrity
```

解决方案，重新自己生成 `PKGBUILD` 文件:

```
$ yaourt -G frp
$ cd frp
$ makepkg -g >> PKGBUILD
$ makepkg
$ sudo pacman -S frp-0.14.0-2-x86_64.pkg.tar.xz
```

使用方法:

```
To start the client, simply modify /etc/frp/frpc.ini, and start the service by:

    systemctl start frpc

or create your own config file, for example myconf.ini, and start the service by:

    systemctl start frpc@myconf

You can also start frps the same way
```

具体配置参数见 <https://github.com/fatedier/frp>
