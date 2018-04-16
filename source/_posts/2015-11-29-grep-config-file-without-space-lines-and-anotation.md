---
author: ety001
layout: post
title: 用grep剔除掉配置文件空白行和注释
tags:
- Server&OS
---

```
grep -ve "^[[:space:]]*[#;]\|^$\|^[[:space:]]*$" /etc/samba/smb.conf
```

