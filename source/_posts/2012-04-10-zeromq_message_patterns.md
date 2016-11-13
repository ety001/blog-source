---
author: ety001
comments: true
date: 2012-04-10 06:46:59+00:00
layout: post
slug: zeromq_message_patterns
title: ZeroMQ的模式
wordpress_id: 2092
tags:
- 理论
---

转自：[http://blog.codingnow.com/2011/02/zeromq_message_patterns.html](http://blog.codingnow.com/2011/02/zeromq_message_patterns.html)

在需要并行化处理数据的时候，采用消息队列通讯的方式来协作，比采用共享状态的方式要好的多。Erlang ，Go 都使用这一手段来让并行任务之间协同工作。

最近读完了 [ZeroMQ](http://www.zeromq.org/) 的 [Guide](http://zguide.zeromq.org/chapter:all)。写的很不错。前几年一直有做类似的工作，但是自己总结的不好。而 ZeroMQ 把消息通讯方面的模式总结的很不错。

ZeroMQ 并不是一个对 socket 的封装，不能用它去实现已有的网络协议。它有自己的模式，不同于更底层的点对点通讯模式。它有比 tcp 协议更高一级的协议。（当然 ZeroMQ 不一定基于 TCP 协议，它也可以用于进程间和进程内通讯。）它改变了通讯都基于一对一的连接这个假设。

ZeroMQ 把通讯的需求看成四类。其中一类是一对一结对通讯，用来支持传统的 TCP socket 模型，但并不推荐使用。常用的通讯模式只有三类。

  1. 请求回应模型。由请求端发起请求，并等待回应端回应请求。从请求端来看，一定是一对对收发配对的；反之，在回应端一定是发收对。请求端和回应端都可以是 1:N 的模型。通常把 1 认为是 server ，N 认为是 Client 。ZeroMQ 可以很好的支持路由功能（实现路由功能的组件叫作 Device），把 1:N 扩展为 N:M （只需要加入若干路由节点）。从这个模型看，更底层的端点地址是对上层隐藏的。每个请求都隐含有回应地址，而应用则不关心它。


  2. 发布订阅模型。这个模型里，发布端是单向只发送数据的，且不关心是否把全部的信息都发送给订阅端。如果发布端开始发布信息的时候，订阅端尚未连接上来，这些信息直接丢弃。不过一旦订阅端连接上来，中间会保证没有信息丢失。同样，订阅端则只负责接收，而不能反馈。如果发布端和订阅端需要交互（比如要确认订阅者是否已经连接上），则使用额外的 socket 采用请求回应模型满足这个需求。


  3. 管道模型。这个模型里，管道是单向的，从 PUSH 端单向的向 PULL 端单向的推送数据流。

任何分布式，并行的需求，都可以用这三种模型组合起来解决问题。ZeroMQ 只专注和解决了消息通讯这一基本问题，干的非常漂亮。

基于定义好的模型，我们可以看到，api 可以实现的非常简单易用。我们不再需要 bind/listen/accept 来架设服务器，因为这个模型天然是 1:N 而不是 1:1 的，不需要为每个通道保留一个句柄。我们也不必在意 server 是否先启动（bind），而后才能让 client 工作起来（connect）。

这以上模型中，关注的是通讯双方的职责，而不是实现的方式：监听端口还是连接对方端口。对于复杂的多进程协同工作的系统, 不必纠结于进程启动的次序（在我前几年设计的系统中，启动脚本写起来就非常麻烦）。

使用 ZeroMQ 不必在意底层实现是使用短连接还是长连接方式。ZeroMQ 中的 Transient (短暂) 和 Durable (持久) socket 也并非区别于实现层是否保持了 tcp 连接。而是概念上的不同。对于 Durable socket ，其生命期可以长于一个进程的生命期，即使进程退出，再次启动后依旧可以维持继续之前的 socket 。当然，这并不是帮助你挽救你的程序因出错而崩溃的。它只是提出这个模式，让你根据设计需要可以实现。对于 ZeroMQ ，如有需求（若内存有限），甚至把数据传输的 buffer 放到磁盘上。


对于网络游戏，我觉得基于 ZeroMQ 来架构服务器非常合适。对于玩家 Client - Server 部分倒不必使用 ZeroMQ ，而可以写一个前端程序，比如[前些年写过的一篇 blog 中提到的连接服务器](http://blog.codingnow.com/2006/04/iocp_kqueue_epoll.html)依然适用。这个连接服务器对内的服务集群则可以用 ZeroMQ 的协议通讯。
