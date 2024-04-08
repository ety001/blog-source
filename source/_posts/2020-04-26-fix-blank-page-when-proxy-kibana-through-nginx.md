---
author: ety001
layout: post
title: 解决nginx反代kibana显示空白页的问题
tags:
  - 服务器
  - 经验
  - 配置
  - Server&OS
  - kibana
  - elastic
---

之前[搭建的 **bitshares elastic search**](/2019/10/11/bitshares-es-node-add-kibana.html) ，已经有太久不维护了，最近因为调整服务器的硬盘为 RAID0，这才发现有挺多问题了。其中一个问题就是，通过公网服务器的 `nginx` 进行反向代理的 `kibana` 面板一直是空白。

具体的现象就是，直接访问服务端口，一切正常，但是只要通过 `nginx` 进行反向代理，就是空白页。通过看浏览器，能看到已经把页面的 `HTML` 代码都下载回来了，但是不知道哪里解析不了。

最终发现是反向代理的配置有问题，贴出来已经测试通过的配置来记录下这次的问题吧：

```
server {
    listen 443 ssl;
    server_name **********;
    ssl_certificate /etc/nginx/ssl/****.cer;
    ssl_certificate_key /etc/nginx/ssl/****.key;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    location / {
        #proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
        proxy_pass http://172.20.0.1:5601;
    }
}
```

---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
