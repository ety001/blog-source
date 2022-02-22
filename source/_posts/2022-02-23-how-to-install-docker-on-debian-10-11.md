---
author: ety001
layout: post
title: How to install docker on Debian 10/11
tags:
  - 服务器
  - 经验
  - 配置
  - Docker
---

This is one line command to install docker on Debian 10/11.

```
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release &&
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null &&
  apt-get update &&
  apt-get install -y docker-ce docker-ce-cli containerd.io
```

This command line has been verified on Debian 10/11.

This will speed up deploying a fresh vps process. That is why I write all command in one line.

