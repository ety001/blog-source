---
author: ety001
layout: post
title: 封装了一个Bitshares的喂价程序
tags:
- Server&OS
- Bitshares
- Docker
---
最近 [GBAC](http://gbacenter.org/) 计划参与 Bitshares 的见证人竞选，而我负责见证人服务节点等一系列服务的搭建。

一个见证人，最好是配备2台节点服务器（主备），1台测试节点服务器，1个API节点服务器，1个喂价程序。

其中像API和测试节点为了省成本，可以跟备机一块。最让我头疼的就是喂价程序了。

找了两个老的开源的喂价程序，折腾了一整天，总是各种各样的报错，最后@abit 提供了一个 [https://github.com/Zapata/bitshares-pricefeed](https://github.com/Zapata/bitshares-pricefeed) ，最终终于打包成可用的 docker 镜像了。

目前已经[提交 PR 给原库](https://github.com/Zapata/bitshares-pricefeed/pull/9)了，不过还没有合并。目前想要使用的话，可以先用我的库，

```
git clone https://github.com/ety001/bitshares-pricefeed.git
cd bitshares-pricefeed
git checkout develop
docker build -t bitshares-pricefeed .
```

打包好以后，镜像大约在250MB左右，比原作者的1G多的镜像小了很多。

使用前，先生成默认配置文件

```
docker run -it --rm -v /path/to:/app bitshares-pricefeed:latest bitshares-pricefeed create
```

执行后，在 `/path/to` 目录下会有一个 `config.yml` 的配置文件，里面的注释解释的比较清楚，自己看一下就好。

然后执行下面的命令即可启动喂价程序

```
docker run -v /path/to/config.yml:/config/config.yml bitshares-pricefeed:latest bitshares-pricefeed --configfile /config/config.yml --node wss://ws.gdex.top update --active-key=XXXXXXX
```

> 其中 active-key 就是你的见证人账号的 active 权限的私钥

简单来说，就是简单的两步，创建配置文件，启动喂价程序。

不得不说，现在我对于docker的依赖越来越严重了。。。
