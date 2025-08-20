---
author: ety001
title: Harmony Next 使用 L2TP IPSec PSK VPN
date: 2025-08-21 0：00：0jjj0
layout: post
tags:
- 经验
- 服务器
---

之前在我的 {% post_link docker-pptp-vpn-l2tp-ipsec-vpn %} 一文中，我介绍了如何使用 Docker k快速署 L2TP IPSec VPN，但是在纯血鸿蒙下一直无法成功。

发现是因为无法匹配通讯加密方法。

进入容器，如下修改一下 `/etc/ipsec.conf` 文件的通讯加密方法，

```
conn l2tp-psk
    ...
    ike=aes128-sha1-modp1024,aes256-sha1-modp1024  # 匹配客户端的AES-CBC + SHA1 + MODP1024
    phase2alg=aes128-sha1  # 第二阶段算法也需匹配
    ...
```

之后重启服务即可，`service ipsec restart`。