---
author: ety001
layout: post
title: 使用 nsenter 配合 wireshark 来抓取容器数据包
tags:
- Bitshares
- 经验
---

最近在开发 Bitshares 内盘交易机器人，使用的 `pybitshares` 库，文档写的很基础，真是苦了我了。

这不就遇到了下单时，给我说 `UnhandledRPCError`，然后就没有然后了。

WTF！这特么让我怎么调试？你代码不知道怎么处理，你倒是把错误信息打出来啊。

我尝试过了 `pdb` 工具，逐步调试，也没有拿到信息，主要是不熟悉调试工具。最后打算直接上 `wireshark` 抓包了。

不过由于公开节点都是 `http` 的，用 `wireshark` 抓包也没法看，都是加密的。

于是我只能把我远端的节点服务器上的 `8090` 端口映射到我本地，这样我就可以直接使用 `http` 协议了。

但是还有个问题，就是我的开发环境在 `Docker` 容器里，而 `8090` 是映射在宿主机上，
用 `wireshark` 抓包没有抓到（后来想了下，应该要监听错了网卡，应该监听 `Docker` 的那块虚拟网卡才对）。

抓不到包咋办？

搜索了下，发现 `Linux` 大多数发行版会带着一个叫做 `nsenter` 的工具。

这个工具可以以其他程序的名字空间运行某个程序。而 `Docker` 容器在宿主机上其实就是一个进程，
那么我们就可以用这个工具把容器的名字空间搞出来，再运行 `wireshark`，那就相当于是在容器里
直接运行 `wireshark`。

所以，我们需要先看下当前开发用的 `Docker` 容器的进程ID

```
docker ps
```

找到进程ID是 `4030`，再执行下面的命令完成映射，

```
# nsenter -n -t 4030
```

这时候，再执行

```
# wireshark
```

这时就能在 `wireshark` 里看到跟宿主机不一样的网卡列表，这就成功了。

启动抓包，重新执行我的程序，终于拿到了错误信息！！

![](/upload/20191114/Xz8NAJEozUzgxtsnujTWjP101VQVb1NY6tNNo5mZ.png)
