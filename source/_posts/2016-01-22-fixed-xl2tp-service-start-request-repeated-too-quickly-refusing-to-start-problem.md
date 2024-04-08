---
title: 解决 xl2tpd.service start request repeated too quickly refusing to start
author: ety001
tags:
- Server&OS
layout: post
---

今天在CentOS7中安装部署L2TP，但是用`systemctl`启动的时候，总是报下面的错误:

```
xl2tpd.service start request repeated too quickly refusing to start
```

直接使用`xl2tpd -D`就能启动成功，于是把重点检查对象放在了`/usr/lib/systemd/system/xl2tpd.service`这个文件上。

通过多次试验，发现把下面的这行注释掉后，就能正常使用了

```
#ExecStartPre=/sbin/modprobe -q l2tp_ppp
```

另外再附带上iptables的配置：

```
iptables --table nat --append POSTROUTING --jump MASQUERADE
```

