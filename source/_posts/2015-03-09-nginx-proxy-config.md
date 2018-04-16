---
author: ety001
layout: post
title: nginx反向代理配置
tags:
- Server&OS
---

下面是简单的一个nginx反向代理的配置，只需要替换掉`proxy_pass`中的配置内容即可。

```
server
{
    listen 80;
    server_name fuckspam.in;
    location / {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://192.168.10.1:3000;
    }
}

```

