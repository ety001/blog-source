---
author: ety001
date: 2023-10-26 13:25:31+00:00
layout: post
title: ubuntu22.04 server 安装 xfce4 和 xrdp
tags:
- Server&OS
- 经验
- 服务器
---

最近需要在服务器上安装桌面。于是总结一下。

```
apt update && apt-get upgrade -y && \
  apt install -y xubuntu-desktop && \
  apt install -y xrdp
```

在用户家目录输出 xfce4 的 session

```
echo "xfce4-session" | tee .xsession
```

重启 xrdp 

```
systemctl restart xrdp
```