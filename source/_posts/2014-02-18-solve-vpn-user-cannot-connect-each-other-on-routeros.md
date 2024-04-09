---
author: ety001
comments: true
date: 2014-02-18 14:30:18
layout: post
slug: solve-vpn-user-cannot-connect-each-other-on-routeros
title: 解决RouterOS上vpn互访问题
wordpress_id: 2579
tags:
- Server&OS
- 配置
---

今天，在所里跟同事同时登陆vpn，测试能不能互访，结果成功了，但是晚上，都回家后，再测试却不成功，tracert一下后，发现第一跳路由是WAN口的IP，显然就是这里的问题了，在PPP项目下，修改profiles配置中的localAddress为LAN口IP，问题即可解决。

