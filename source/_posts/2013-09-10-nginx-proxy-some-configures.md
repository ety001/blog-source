---
author: ety001
comments: true
date: 2013-09-10 03:04:01+00:00
layout: post
slug: nginx-proxy-some-configures
title: nginx的proxy相关配置
wordpress_id: 2457
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

最近在做的一个项目的web服务器是放在内网环境中的，使用lnmp，在整个网络的出口通过nginx进行proxy到这台web服务器。不过有时候访问的时候，会出现502错误，因此在出口处的nginx中增加了以下配置，有待观察效果：

```
proxy_connect_timeout 600;
proxy_read_timeout 600;
proxy_send_timeout 600;
proxy_buffer_size 16k;
proxy_buffers 4 32k;
proxy_busy_buffers_size 64k;
proxy_temp_file_write_size 64k;
proxy_temp_path /data/nginx_temp_path;
proxy_cache_path /data/nginx_cache_path levels=1:2 keys_zone=cac
he_one:2000m inactive=1d max_size=5m;
```
