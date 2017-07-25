---
author: ety001
comments: true
date: 2017-07-25
layout: post
title: SSL23_GET_SERVER_HELLO:unknown protocol
tags:
- Server&OS
---
今天配置服务器的https，结果配置完后，浏览器访问报错，显示

```
This site can’t provide a secure connection
1hour.win sent an invalid response.
```

用 *openssl* 看了下，发现报错如下

```
[root@host wwwroot]# openssl s_client -connect 1hour.win:443 -debug
CONNECTED(00000003)
write to 0x1d66480 [0x1e64440] (247 bytes => 247 (0xF7))
0000 - 16 03 01 00 f2 01 00 00-ee 03 03 59 77 63 d6 28   ...........Ywc.(
0010 - 1e d6 5a c6 ba ef 29 51-7a 37 7f 93 4b 6d 05 e1   ..Z...)Qz7..Km..
0020 - 1c 45 37 ba c2 11 3e 12-1d 36 2a 00 00 84 c0 30   .E7...>..6*....0
0030 - c0 2c c0 28 c0 24 c0 14-c0 0a 00 a3 00 9f 00 6b   .,.(.$.........k
0040 - 00 6a 00 39 00 38 00 88-00 87 c0 32 c0 2e c0 2a   .j.9.8.....2...*
0050 - c0 26 c0 0f c0 05 00 9d-00 3d 00 35 00 84 c0 2f   .&.......=.5.../
0060 - c0 2b c0 27 c0 23 c0 13-c0 09 00 a2 00 9e 00 67   .+.'.#.........g
0070 - 00 40 00 33 00 32 00 9a-00 99 00 45 00 44 c0 31   .@.3.2.....E.D.1
0080 - c0 2d c0 29 c0 25 c0 0e-c0 04 00 9c 00 3c 00 2f   .-.).%.......<./
0090 - 00 96 00 41 c0 12 c0 08-00 16 00 13 c0 0d c0 03   ...A............
00a0 - 00 0a 00 07 c0 11 c0 07-c0 0c c0 02 00 05 00 04   ................
00b0 - 00 ff 01 00 00 41 00 0b-00 04 03 00 01 02 00 0a   .....A..........
00c0 - 00 08 00 06 00 19 00 18-00 17 00 23 00 00 00 0d   ...........#....
00d0 - 00 20 00 1e 06 01 06 02-06 03 05 01 05 02 05 03   . ..............
00e0 - 04 01 04 02 04 03 03 01-03 02 03 03 02 01 02 02   ................
00f0 - 02 03 00 0f 00 01 01                              .......
read from 0x1d66480 [0x1e699a0] (7 bytes => 7 (0x7))
0000 - 48 54 54 50 2f 31 2e                              HTTP/1.
140304408045472:error:140770FC:SSL routines:SSL23_GET_SERVER_HELLO:unknown protocol:s23_clnt.c:769:
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 7 bytes and written 247 bytes
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
---
```

unknown protocol? 这是啥情况，仔细比对配置，发现原来是在 *listen* 配置项中掉了 *ssl* ，
正确配置应该是

```
listen 443 ssl;
```

之前写成了

```
listen 443;
```
