---
author: ety001
comments: true
date: 2014-07-12 13:34:45+00:00
layout: post
slug: open-remote-sevice
title: 远程开启3389
wordpress_id: 2633
tags:
- Hacker
---

前提，开启了23.
```
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Terminal" "Server /v fDenyTSConnections /t REG_DWORD /d 00000000 /f
```

