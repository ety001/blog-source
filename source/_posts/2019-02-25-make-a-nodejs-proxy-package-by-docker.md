---
author: ety001
layout: post
title: 用Docker封装了一个简易的图片代理服务
tags:
- nodejs
- Docker
- proxy
---
在开发 `SteemTools` 服务号的文章单独页面的时候，遇到的一个问题就是有些人的图片存放在了被墙的服务器上了，导致文章中的图片无法正常显示。

从网上搜索了下，找到了一个用 `node` 写的图片代理，我已经 `fork` 到了自己的库中，[https://github.com/ety001/node-image-proxy](https://github.com/ety001/node-image-proxy) 。

为了方便部署和管理，把这个服务封装进了 `Docker` 中。

运行命令如下：

```
docker run -itd --name node-image-proxy -p 9091:9091 -v /data/node-image-cache:/app/cache --restart always ety001/node-image-proxy
```

其中 `/data/node-image-cache` 目录是用来存储缓存的，自己手动建立一个目录就好了。

启动成功后，可以用 `nginx` 的反向代理来实现 `https`，也可以直接使用，只需要把要代理的图片地址放到 `url` 后面就好了，例如这样：

```
https://img.steemtools.top/http://newappaz.oss-cn-hongkong.aliyuncs.com/wherein_images/post/20190224/89a2802d622c4940b2ece51eea04aecd.jpg
```

这样只需要把服务部署在国外服务器上，然后在解析 `markdown` 的时候把原来的图片地址加上代理地址后，就可以正常的访问文章中的图片了。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
