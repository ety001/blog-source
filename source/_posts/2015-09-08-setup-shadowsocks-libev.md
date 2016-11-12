---
author: ety001
title: 编译安装shadowsocks-libev
tags:
- 配置
layout: post
---
在centos下编译安装shadowsocks-libev，需要先安装必要的依赖，命令如下：

```
yum install -y gcc automake autoconf libtool make build-essential autoconf libtool gcc curl curl-devel zlib-devel openssl-devel perl perl-devel cpio expat-devel gettext-devel git asciidoc xmlto
```

然后克隆下源代码，

```
git clone https://github.com/madeye/shadowsocks-libev.git
```

从源码编译安装

```
cd shadowsocks-libev
./configure
make && make install
```
这样即可编译好一个新的ss，所有程序是以ss-开头，其他系统下面的编译安装，请参考
<https://github.com/madeye/shadowsocks-libev>。

