---
author: ety001
layout: post
title: 见证人服务器重做系统中
tags:
- Server&OS
---

一周三次出块都失败了，也不知道服务器到底抽了什么风，于是索性就重装系统吧，顺便把 `zram` 也折腾下。重做系统的时候没有再选择 `ubuntu16.04`，而是选择了我最熟悉的 `Archlinux`。重做很快就结束了，登陆系统看了下，还是 `Arch` 精简干练，即使把所有需要的软件都装完，内存依然占用很少。

![](https://steemeditor.com/storage/images/qXkl0bBuInhSWACOHmGeY2VzTeaDKBTmuh61nwkI.png)

由于我还是打算在 `docker` 里面跑见证人，所以先安装 `docker`，执行 `pacman -S docker` 搞定。

然后安装一个轻量的管理 `docker` 界面 `portainer`，

```
# docker volume create portainer_data
# docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --name portainer --restart always -v portainer_data:/data portainer/portainer
```

安装好，直接浏览器访问 `IP:9000` ，配置上用户名和密码，选择本地模式，搞定。

接下来就是做个文件的 `swap`，

```
# fallocate -l 50G /swapfile
# mkswap /swapfile
# swapon /swapfile
# echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
```

然后安装 `zramswap`，由于 `zramswap` 是在 `AUR` 里，所以先安装一下 `makepkg` 所要用到的编译环境

```
# pacman -S base-devel
```

然后新建一个普通用户，并切换到该用户的家目录，然后下载 `zramswap` 的安装包（在 <https://aur.archlinux.org/packages/zramswap/> 这里能找到下载地址），解压后编译安装

```
$ wget https://aur.archlinux.org/cgit/aur.git/snapshot/zramswap.tar.gz
$ tar xvf zramswap.tar.gz
$ cd zramswap
$ makepkg -si
```

安装好以后，确认下 `zram` 模块是否加载，如果没有加载的话，加载下

```
# lsmod | grep zram
# modprobe zram
```

启动 `zramswap` 并设置为开机自启动，

```
# systemctl start zramswap
# systemctl enable zramswap
```

检查是否正常

```
# zramctl
NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram9 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram8 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram7 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram6 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram5 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram4 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram3 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram2 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram1 lz4        1006.3M   4K   69B    4K      10 [SWAP]
/dev/zram0 lz4        1006.3M   4K   69B    4K      10 [SWAP]

# swapon
NAME       TYPE         SIZE USED PRIO
/swapfile  file          50G   0B   -2
/dev/zram0 partition 1006.3M   0B  100
/dev/zram1 partition 1006.3M   0B  100
/dev/zram2 partition 1006.3M   0B  100
/dev/zram3 partition 1006.3M   0B  100
/dev/zram4 partition 1006.3M   0B  100
/dev/zram5 partition 1006.3M   0B  100
/dev/zram6 partition 1006.3M   0B  100
/dev/zram7 partition 1006.3M   0B  100
/dev/zram8 partition 1006.3M   0B  100
/dev/zram9 partition 1006.3M   0B  100
```

发现 `zramswap` 只分配了10G内存，于是去查了下他的启动文件 `/usr/lib/systemd/system/zramswap.service`，发现最终执行的文件是 `/usr/lib/systemd/scripts/zramctrl`，打印下 `zramctrl` 的内容，

```
# cat /usr/lib/systemd/scripts/zramctrl 
#!/bin/sh

start() {
  exec awk -v ZRAM_SIZE=$ZRAM_SIZE -v ZRAM_PARM="$(modinfo zram | grep -E -o '(num_devices|zram_num_devices)')" '

  FILENAME == "/proc/cpuinfo" && ($1 == "processor" || $1 == "Processor") {
    cpucount++
    next
  }
  FILENAME == "/proc/meminfo" && $1 == "MemTotal:" {
    if (ZRAM_SIZE == "")
      ZRAM_SIZE = 20
    mem_total = int( (0 + $2) * 1024 * ( ZRAM_SIZE/100 ) )
    next
  }

....以下代码省略
```

发现需要设置一个 `$ZRAM_SIZE` 的环境变量，否则默认20%。在 `/usr/lib/systemd/system/zramswap.service` 中增加环境变量，

```
[Unit]
Description=Zram-based swap (compressed RAM block devices)

[Service]
Type=oneshot
Environment="ZRAM_SIZE=100"   # 这里是增加的环境变量
ExecStart=/usr/lib/systemd/scripts/zramctrl start
ExecStop=/usr/lib/systemd/scripts/zramctrl stop
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

重载配置文件并重启 `zramswap`，

```
# systemctl daemon-reload
# systemctl restart zramswap
```

再次查看 `zram` 状态，发现已经搞定。

```
# zramctl
NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
/dev/zram9 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram8 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram7 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram6 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram5 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram4 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram3 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram2 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram1 lz4           4.9G   4K   69B    4K      10 [SWAP]
/dev/zram0 lz4           4.9G   4K   69B    4K      10 [SWAP]
```

接下来就是去部署 @someguy123 的见证人镜像了，这个在之前写过教程，就不再细说了，这是链接 <https://steemit.com/cn/@ety001/5xtjgz> 。

看目前下载离线区块数据的速度应该不是网络卡导致的丢块，难道是之前配置的 `shared-file-size` 有问题？等部署完见证人运行起来再观察下看看还会不会频繁的丢块了吧。。。
