---
author: ety001
comments: true
date: 2015-01-17 04:55:58+00:00
layout: post
slug: when-click-bootstrap-modal-open-and-auto-close-immediately
title: bootstrap的modal打开后立即自动关闭
tags:
- 前端
---

今天遇到了一个bootstrap的问题，就是modal打开后，自动又关闭了，感觉像是toggle方法被触发了两次的感觉，
最终查到原因是因为modal的js代码加载了两次，去掉多加载的那一遍即可解决问题。

