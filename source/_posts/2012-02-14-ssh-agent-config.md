---
author: ety001
comments: true
date: 2012-02-14 01:27:43+00:00
layout: post
slug: ssh-agent-config
title: ssh代理命令
wordpress_id: 1943
tags:
- 后端
- 理论
---

vpn安装神马的都弱爆了，在linux下，直接一条命令就用ssh翻墙了，对以前的无知感到羞愧呀。。。。
命令如下：

```
sudo ssh -qTfnN -D 7070 root@host
```

7070是在本地开的代理端口，root是vps的用户名，host是vps的地址。
命令执行后，输入完vps密码，再在系统里设置代理即可，IP填127.0.0.1,端口7070.

