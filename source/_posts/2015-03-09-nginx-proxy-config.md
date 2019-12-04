---
author: ety001
layout: post
title: nginx反向代理配置
tags:
- Server&OS
---

**2019-11-09 补充**
websocket 的反代
```
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

upstream websocket {
    server 172.20.0.1:8090;
}

server {
    listen 443 ssl;
    server_name test.com;
    ssl_certificate /etc/nginx/ssl/test.com.fullchain.cer;
    ssl_certificate_key /etc/nginx/ssl/test.com.key;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    location / {
        proxy_pass http://websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}
```

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
