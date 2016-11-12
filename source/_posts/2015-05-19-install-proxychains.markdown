---
author: ety001
layout: post
title: 安装proxychains
tags:
- Server&OS
---

在终端下翻墙的重要性，当你使用composer之类的东西的时候就体现出来了。
安装proxychains可以实现执行指定的命令的时候，使用代理去访问。

```
brew install proxychains-ng

vim /usr/local/etc/proxychains.conf

proxychains4 php composer.phar update

```
