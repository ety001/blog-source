---
author: ety001
comments: true
date: 2014-10-23 21:17:27+08:00
layout: post
slug: fix-ios-cannot-drag-webpage-in-iframe
title: 解决ios设备iframe无法拖动问题
wordpress_id: 2647
tags:
- 前端
---

需要在iframe 外面的div加上
```
overflow: auto;
-webkit-overflow-scrolling: touch;
```

