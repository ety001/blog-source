---
author: ety001
layout: post
title: 在同一个路径下反代 Websocket 和 HTTP 服务
tags:
- Server&OS
---

昨天重做了一个线上VPS的操作系统，结果忘记了备份 `nginx` 配置，
其中有一个配置还是比较棘手，这个服务是我的 [Online Clipboard](https://oc.to0l.cn)。

这个工具最初后端服务是基于 `Swoole` 实现的 `Websocket`，后来
用户提了一个需求，希望在命令行下也能用，所以又在 `Websocket` 的
基础上增加了响应 `HTTP` 的功能，在[代码](https://github.com/ety001/online-clipboard/blob/master/server.php)里可以很清楚的看到这些。

然后最终的服务是依靠 `Nginx` 反代出来的。这里就有个问题，那就是
`Websocket` 和 `HTTP` 都在一个路径下面。也就是说下面的两个路径
一个可以创建 `Websocket` 连接，一个可以直接通过 `HTTP` 访问 (其中
`username` 和 `password` 是参数)

```
wss://oc-server.to0l.cn/username/password
https://oc-server.to0l.cn/username/password
```

尴尬的事情就是，之前我怎么配置的忘记了。这次重做系统丢掉配置后，
重新配置怎么也配不出来了，最后搜索到一个方案，就是通过报文头来
区分是 `Websocket` 还是 `HTTP`，示例配置如下：


```
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

upstream clip-server {
    server 172.20.0.2:8080;
}

server {
    listen 443 ssl;
    server_name oc-server.to0l.cn;
    ssl_certificate /etc/nginx/ssl/oc.to0l.cn.fullchain.cer;
    ssl_certificate_key /etc/nginx/ssl/oc.to0l.cn.key;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    location / {
        try_files /noexistfile @$http_upgrade;
    }

    location @websocket {
        proxy_pass http://clip-server;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }

    location @ {
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://clip-server;
    }
}
```

思路就是解析 `/` 的时候，尝试访问一个不存在的文件，既然不存在，
那么势必要内部访问 `location @$http_upgrade`。

当来访访问是 `Websocket` 请求的时候， `$http_upgrade` 的值是
`websocket`，而来访访问是 `HTTP` 请求的时候，则是空值。

这样就把两个不同报文头的请求转发到两个不同的 `location` 中去了。
这样之前尴尬的问题就解决了。

配置好后，通过 `curl https://oc-server.to0l.cn/public/public -d "content=test"`
测试提交数据到剪切板，成功！

通过 `curl https://oc-server.to0l.cn/public/public` 访问最后
一条剪切板数据，成功！

浏览器访问 `https://oc.to0l.cn`，分别输入剪切板名和密码后，可以
看到之前发的 `test` 信息，成功！
