---
author: ety001
title: 使用 openresty 对 websocket 进行消息频次限制的尝试
date: 2023-12-13 17:21:15
layout: post
tags:
- 经验
- 服务器
- 配置
- openresty
---

最近我的 BTS 见证人总是收到丢块报警，排查了原因，大概率是因为 API 和 出块都使用同一个程序的原因。

从 Abit 那里了解到，API 请求和出块并没有做线程优先级，所以在有大量 API 请求进入或者长耗时操作的时候，都会对出块造成影响。

对于底层的 C++ 改起来太麻烦，主要我也不会改，所以思路变换一下，那么就在入口位置进行拦截。

最初尝试使用 nginx 的 limit_conn 来限流，但是没有效果。

主要原因是 Websocket 握手建立连接后，就不会再触发规则了，而所有的请求都以 Websocket 的消息形式与后端交互了。

于是换成了 openresty，通过 lua 来建立一个 Websocket 的消息转发机制，符合条件的放行，不符合的拦截。

最终代码越写越复杂，成型的规则就是在 IP 黑名单中的，且 method 也在黑名单里，那么就限流。

具体的代码实现在这里：[https://github.com/ety001/openresty/blob/master/scripts/lua/bts/limit_req.lua](https://github.com/ety001/openresty/blob/master/scripts/lua/bts/limit_req.lua)，可以作为参考。





