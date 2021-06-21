---
author: ety001
layout: post
title: How to install docker on Ubuntu 20.04
tags:
  - 服务器
  - 经验
  - 配置
  - Docker
---

This is one line command to install docker on Ubuntu 20.04.

```
apt update -y && \
apt install -y apt-transport-https ca-certificates curl software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
apt update -y && \
apt install -y docker-ce
```

This command line has been verified on Ubuntu20.04.

This will speed up deploying a fresh vps process. That is why I write all command in one line.

