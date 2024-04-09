---
author: ety001
date: 2022-02-23 08:24:49
layout: post
title: Chromebook 无法访问 websocket
tags: chromebook
---

最近我的 Chromebook 无法访问 websocket 资源，这让人很烦恼。

查来查去，最后发现国外一篇文章提到，如果全局代理中勾选了“对所有协议使用同一代理”，就会出现这个问题。这是由于 websocket 会使用 socks 代理作为通讯方法，

我之前都是分着设置，前几天测试个东西，找省劲，勾选了“对所有协议使用同一代理”，而我的 socks 代理端口和 http 代理端口其实不是同一个，才导致现在访问所有 websocket 资源不成功。