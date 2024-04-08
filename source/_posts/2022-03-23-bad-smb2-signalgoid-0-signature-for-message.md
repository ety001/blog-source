---
author: ety001
date: '2022-03-23 08:24:49+00:00'
layout: post
title: 解决 Bad SMB2 (sign_algo_id=0) signature for message 问题
tags:
  - 经验
  - Server&OS
---

解决 Bad SMB2 (sign_algo_id=0) signature for message 问题
最近线下培训教育机构都停了，孩子报的班都改为了线上授课，教练和老师会把视频发过来，看着学。

由于手机屏幕太小，所以打算把视频放到家里的服务器上，通过 samba 共享让投影可以读取。

但是却遇到不能连接的问题，看了下服务器的日志，发现有报错：

```
[2022/03/23 00:57:09.728871,  0] ../../libcli/smb/smb2_signing.c:722(smb2_signing_check_pdu)
  Bad SMB2 (sign_algo_id=0) signature for message
[2022/03/23 00:57:09.729142,  0] ../../lib/util/util.c:570(dump_data)
  [0000] 73 34 44 8A 28 41 5E 00   D4 5E 9D 5D 38 39 9B A0   s4D.(A^. .^.]89..
[2022/03/23 00:57:09.729263,  0] ../../lib/util/util.c:570(dump_data)
  [0000] 6C 38 C8 B5 93 51 16 95   12 2C 64 92 54 A0 E2 8E   l8...Q.. .,d.T...
[2022/03/23 00:57:42.258662,  0] ../../source3/smbd/server.c:1734(main)
```

搜索了一下，似乎只有一个方案，就是降级协议，在 `/etc/samba/smb.conf` 文件的 `[global]` 中增加下面的配置：

```
server min protocol = LANMAN2
```

重启服务， `systemctl restart smb`。

再次连接，成功！