---
author: ety001
date: '2022-03-27 08:24:49+00:00'
layout: post
title: 把 makepkg 的下载器从 curl 换成了 aria2c
tags:
  - 经验
  - Server&OS
---

今天才知道，原来 archlinux 的 makepkg 可以更换下载器啊。

按照 arch 官方文档的说明，修改一下 `/etc/makepkg.conf` 的 `DLAGENTS` 变量。

```
DLAGENTS=('file::/usr/bin/curl -qgC - -o %o %u'
	  'ftp::/usr/bin/aria2c -UWget -s4 %u -o %o'
	  'http::/usr/bin/aria2c -UWget -s4 %u -o %o'
	  'https::/usr/bin/aria2c -UWget -s4 %u -o %o'
          'rsync::/usr/bin/rsync --no-motd -z %u %o'
          'scp::/usr/bin/scp -C %u %o')
```

然后以后再用 makepkg 的时候，就能体验到 aria2 优秀的下载体验了。