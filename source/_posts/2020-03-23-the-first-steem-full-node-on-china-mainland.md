---
author: ety001
layout: post
title: 中国大陆地区第一台不稳定Steem全节点正式上线
tags:
  - 经验
  - 配置
  - steemit
  - steem
  - 服务器
---

# 前言

鉴于之前全节点的内存占用太高（需要256G内存），一直没有机会去部署一台。后来Mira版出来后，社区也没有看到有相关的运行信息的帖子，而我也是懒，所以这个事情就一直拖到现在。

最近由于 Tron 收购 Steem 的事件发酵过程中，曾有一段时间多数节点不可用，于是我又重新把这个事情提上了议事日程。

经过两周的折腾，目前服务器已上线，地址是：
> https://steem.61bts.com

# 相关信息

下面就来总结下，以给想要搭建全节点的同学参考。

## 软件实施方案

目前我是使用 @someguy123 的 Docker 工具来部署的，整个部署过程还是很轻松的。其中需要注意的就是 `config.ini` 的配置中的 `plugin` 配置，可以参考官方的配置文件。

> [https://github.com/steemit/steem/blob/master/contrib/fullnode.config.ini](https://github.com/steemit/steem/blob/master/contrib/fullnode.config.ini)
> 官方配置中缺少了 `follow` 插件

另外就是 `Shared file` 的配置，如果要省内存，就不要把 `Shared file` 放到 `/dev/shm` 里，我的配置信息可以参考下：

```
shared-file-size = 64G
shared-file-dir = /steem/witness_node_data_dir/blockchain/
```

记得把 `web` 服务端口打开

```
webserver-http-endpoint = 0.0.0.0:8091
webserver-ws-endpoint = 0.0.0.0:8090
```

同时还要在 `run.sh` 中打开端口

```
: ${PORTS="2001,8090,8091"}
```

## 硬件参考

目前我的服务器配置如下：

* 双路 E5 2670
* 256G 内存
* 硬盘是 一块希捷 6T 硬盘（ST6000NM0115）和一块希捷 2T 硬盘（ST2000DM006）组成的 8T 大小的 LVM 卷

## 网络情况

由于在国内主机服务商买大内存+高带宽的设备太特么几吧贵了，所以我用了一个折中的办法，这也是为什么我说是不稳定全节点的原因。

折中方案就是，机器自己组装放在家里，网络出口从机房买。

目前家里是联通光纤，上行是 30Mbps，然后在阿里云买了一台 1核 1G内存 5Mbps 青岛节点的 ECS（我家离青岛节点近，延时 10ms 以内），最后使用 [NPS/NPC](https://github.com/ehang-io/nps) 把家里的服务器端口映射到阿里云的 ECS上。

之所以使用 NPS 也是积累的经验。

最早的时候，我是家里用 DDNS 把动态公网 IP 绑定在一个域名A上，然后在 ECS 上，用 Nginx 反向代理到域名A。

这个方案的缺点就是，如果动态 IP 变了，那么你的 ECS 上的 Nginx 也需要重启才能刷新域名A到 IP 的 DNS 缓存。

而 NPS 是服务端/客户端程序。客户端跑在家里的服务器上，服务端跑在 ECS 上。这样就是客户端主动去连接服务端，并建立隧道。这就避免了动态 IP 变动的尴尬。

目前服务最大的不稳定性，就是由于服务器在家里，意外断电的情况还是存在的。

## 运行参考

目前全节点运行后，内存占用情况是，**真实内存占用不到 3G ，虚拟内存占用不到 14G**。

区块数据的硬盘占用，在当前高度（41626529），`witness_node_data_dir/blockchain` **目录的大小是 362G**。

这次我先后尝试了带 `--memory-replay` 参数和不带参数的 `replay`。带着 `--memory-replay` 参数，目前的区块高度进行 `replay` 的话，需要 230G 内存。而不带参数，则只需要不到 3G 内存。

所以，内存足够的话，可以尝试用 `--memory-replay` 参数加速 `replay` 过程，等 `replay` 结束后，可以停掉进程后，去掉参数再启动，就可以了。

目前高度的数据，不使用 `--memory-replay` 参数，在机械硬盘的情况下，`replay` 一次大概需要6天多的时间。

# 总结

MIra版的确是最大程度把数据从内存里摘出来了，这对于社交平台服务端来说太重要了。因为社交平台的数据是爆炸性增长的，如果都怼到内存里，服务端的运行成本就太高了！

不过目前的架构设计还是没有完全解决后期数据量暴涨可能导致的成本问题、维护问题。

如果有什么问题，可以直接回复本帖。

完！撒花！
