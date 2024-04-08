---
author: ety001
layout: post
title: 用swoole + redis 实现一个网络剪切板
tags:
- 后端
- DM实验室
---

应用地址：<https://oc.mypi.win>

之前一直计划接触下 swoole 、redis 、docker。最近时间稍微宽裕些，于是就把这三者揉到一起，
把之前自己用的剪切板重新写了一遍，之前的那个是个nodejs版的。

redis在上一个公司有过接触，但是由于都是封装在底层的，平时用的时候，也只是调用方法，所以认识不够深刻。
这次读了些资料，主要是看了下redis提供的数据结构。现在我对这货的核心功能的认识就是，用C实现了一个安全操作层，
用来对内存进行读取写入操作，并且实现了几种数据结构，用于存储结构化的数据。

开发目标是应用要能允许建立多个剪切板，每个剪切板有个唯一标示，每个剪切板的容量是50条。因此先想到了队列，
于是最后用的是redis的list的数据结构，用户提供剪切板的name和进入剪切板的password，产生唯一标示的方法如下：

```
$hash = md5($password . $name);
```

然后用$hash作为这个剪切板list的key。

另外一个问题就是如何把websocket的frame_id 和 $hash 关联起来。
frame_id其实就是client_id，即连入到服务器的客户端的唯一标示，$hash和client的关系是，一对多的，
即一个剪切板，可能会有多台终端接入。

最后考虑了下，使用redis的hash数据结构和list数据结构来完成这个对应关系。hash数据结构用来存储
frame_id 到 hash 的关系，即通过该结构，提供 frame_id 即可找到 对应的剪切板list的key，即 $hash 值。

那么list结构是用来做什么的呢？list中存储的是 $hash 做key，每个 list 里面存储着当前连接到该剪切板的
所有终端的 frame_id，这个list的作用就是用来广播的，即同一个剪切板内的某个终端更新剪切板后，通知其他终端更新。

关于制作swoole的docker镜像，可以看这里 <https://akawa.ink/2015/06/13/make-swoole-docker.html>


代码：<https://github.com/ety001/online-clipboard>

swoole-docker：<https://registry.hub.docker.com/u/ety001/min_swoole/>
