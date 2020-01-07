---
author: ety001
layout: post
title: 把服务器的 frp 换成了 nps
tags:
- Server&OS
---
由于国内家庭网络的 80 和 443 端口是被运营商封锁的，因此为了提供 web 服务，我就要用一台公网服务器做一下转发。

之前选择的是 `frp` 这个方案，不过最近在开发 `Bitshares Testnet` 的工具集的时候，发现 `frp` 非常的不稳定，连接经常莫名其妙的断掉，如下图

![](/upload/20191216/ESFm799WTnYv0Cr3itlcex8PcehctIFmKOGeru83.png)

这蛋疼的断线，让我一直以为是 `bitshares-js` 库我使用的不对，看了大半周的源码。

在网上搜索了下，都说断线是 `mtu` 的问题，我折腾了一周，也没有弄好，最后放弃了，换了另外一个方案 `nps`。

这是 `nps` 的官方库: [https://github.com/cnlh/nps](https://github.com/cnlh/nps) 。

配置也非常的简单，服务端根据文档配置下 `nps.conf`，启动后，在 `web` 界面配置下客户端。

客户端指定服务器的 `IP` 和端口，以及密码，就可以连接到服务端了。

![](/upload/20191216/RgdJPEIzbHhoUpa7f619xd7AW7CN9xjyp2snskRS.png)

目前我觉得 `nps` 比 `frp` 好的两点，一个是配置可以在服务端通过 `web` 轻松解决，一个是服务端和客户端的连接可以是基于 `KCP` 协议的，这意味着在网络不是很好的情况下，依然可以提供相对稳定的服务。

至于稳定性，容我再观测一段时间。现在终于可以正常使用我的 `wss://api.61bts.com` 节点了。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
