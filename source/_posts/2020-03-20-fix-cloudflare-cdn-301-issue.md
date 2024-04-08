---
author: ety001
layout: post
title: 解决CDN缓存301的问题
tags:
  - 服务器
  - 经验
  - 配置
---
今天在部署新的节点的时候，遇到了一个奇怪的事情，就是配置完 Nginx 后，访问 443 端口出现莫名其妙的 301 循环。

我的 Nginx 的配置文件如下：

```
server {
    listen 80;
    server_name s2.61bts.com;
    location / {
        return 301 https://s2.61bts.com$request_uri;
    }
}
server {
    listen 443 ssl;
    server_name s2.61bts.com;
    ssl_certificate /etc/nginx/ssl/s2.61bts.com.fullchain.cer;
    ssl_certificate_key /etc/nginx/ssl/s2.61bts.com.key;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    location / {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://172.20.0.21:8080;
    }
}
```

正常情况下，访问 80 端口会 301 到 443 端口去，然后就正常访问了。

但是这次，却出现了 301 循环。

检查了 Nginx 配置，防火墙等等各个地方，就是没有查出原因来。

在命令行下用 curl 访问 443 端口显示的是 301 跳转的内容，总感觉哪个地方有缓存一样。

郁闷了小半天，突然想起来了我还有CDN没有检查。由于这个服务器是在国外，为了提升国内访问速度，所以我配置了CDN。

我登陆域名管理面板，把CDN先关掉，再访问一切正常！！还真是CDN的问题。

但是是哪里的配置导致的缓存呢？

最终发现原来是回源的问题。

![](/upload/202003/2gsjgna1uruvUuS7ndgyCHjMdwbmktNvgzSa547pgFWFJLZKjAD3p9cNJFT1hhCFZFRxW8gNuejRvqKX5fMeP1dfh59wsRPWRKuRvAMjrQHLi6wZSW.png)

Cloudflare 默认的 SSL 策略是 Flexible，也就是回源的时候不使用 SSL/TLS 加密，而是直接访问 80 端口。然后CDN一般都会直接缓存 301 页面，这就导致访问 443 的时候其实是访问的缓存，进而产生循环。

既然找到了原因那就好办了，只需要设置为 Full 模式，强制回源的时候走 443 端口就可以了。

设置好以后，重新打开CDN，清掉所有缓存，再访问，一切正常！
