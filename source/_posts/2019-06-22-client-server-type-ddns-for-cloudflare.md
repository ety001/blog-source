---
author: ety001
layout: post
title: 自己实现了一个cs类型的ddns更新
tags:
- Server&OS
---

最近家里的服务器的 `cloudflare` 的 `DDNS` 更新功能总是不灵验，估计问题是跟墙有关吧。

不得不说这种基础设施还是得自己开发。

考虑到有墙的原因，所以实现更新IP的思路就是，本地获取公网IP，然后发送到墙外的服务器。
然后墙外的服务器拿到IP后再更新 `cloudflare`。

获取并转发公网IP的代码：

[https://github.com/ety001/dockerfile/tree/master/transfer_ip](https://github.com/ety001/dockerfile/tree/master/transfer_ip)

获取到IP并更新的代码：

[https://github.com/ety001/dockerfile/tree/master/update-ip-to-cloudflare](https://github.com/ety001/dockerfile/tree/master/update-ip-to-cloudflare)

为了方便使用，我还封装成了 `Docker` 镜像，分别是： `ety001/transfer_ip` 和 `ety001/update-ip-to-cloudflare`。

使用方法如下：

假如你要更新的域名是 `abc.ppp.com`，先在墙外的服务器(1.1.1.1)上部署，命令是

```
docker run -itd --name update-cloudflare --restart always \
    -p 8888:80
    -e "EMAIL=xxxxxxxx@yyyyyyy.com" \
    -e "AUTH_KEY=xxxxxxxxxxxxxxxx" \
    ety001/update-ip-to-cloudflare:latest
```

其中环境变量 `EMAIL` 是 `cloudflare` 的 `email`，`AUTH_KEY` 是 `cloudflare` 的 `API KEY`。

部署好这个后，你就可以通过 `http://1.1.1.1:8888/?domain=ppp.com&record=abc.ppp.com&ip=` 地址更新IP地址了。

然后在墙内的服务器上执行

```
docker run -itd --name send-ip --restart always \
    -e "TO_URL=http://1.1.1.1:8888/?domain=ppp.com&record=abc.ppp.com&ip=" \
    -e "IP_URL=https://api.ipify.org/" \
    ety001/transfer_ip:latest
```

这里面的两个环境变量，`TO_URL` 就是墙外服务器的更新IP的地址，`IP_URL` 是可以返回你公网IP的网址。

这样两个容器跑起来以后，你就可以本地获取公网IP传到墙外服务器，然后再更新DNS了。

如果你想再更新一个新的地址，只需要在本地再启动一个容器，然后手动修改下 `TO_URL` 参数配置即可。

---
#### ET碎碎念，每周一，晚六点一刻更新，欢迎订阅
![](/img/wechat-subscribe.jpg)---
