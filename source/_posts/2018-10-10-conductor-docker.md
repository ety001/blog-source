---
author: ety001
layout: post
title: 把 conductor 封装进 docker
tags:
- steem
---

今天才发现，自从上次重装服务器后，一直忘记恢复 `Steem` 见证人的喂价程序了。之前一直使用的是 @furion 开发的 [conductor](https://github.com/Netherdrake/conductor)，并且之前没有用 `Dockerfile` 封装成镜像，而是直接在 `ubuntu:16.04` 的镜像上启动容器，添加的命令。这次就直接做成镜像方便以后使用。

## 镜像文件

* 你可以自己编译，`Dockerfile` 如下：
```
FROM alpine:3.6
RUN apk add --no-cache python3 python3-dev gcc git musl-dev libffi-dev openssl-dev \
    && pip3 install -U git+git://github.com/Netherdrake/steem-python \
    && pip3 install -U git+https://github.com/Netherdrake/conductor \
    && apk del git gcc musl-dev libffi-dev python3-dev
ENV UNLOCK=123456
CMD ["conductor"]
```

* 也可以直接用我封装好的，`docker pull ety001/steem-conductor`。

## 使用方法

* 添加 active_key 。
```
docker run -it --rm -v ~/.local/share/steem:/root ety001/steem-conductor /bin/ash
```
执行后，进入容器，再执行
```
steempy addkey
```
输入 `active key` 后就可以把你要操作的用户加入到本地数据库里了，数据库文件最终会存储在你宿主机的 `~/.local/share/steem/.local/share/steem` 位置。添加好以后，执行 `exit` 退出容器环境即可，效果如下图：
![](/img/2018/10/W5gkMOnNlicX27TEaefIrXHj5T1C8jzztFVibMCv.png)

* 初始化 `conductor`
```
docker run -it --rm -v ~/.local/share/steem:/root ety001/steem-conductor conductor init
```
![](/img/2018/10/Wn36kvnMBbvTyKj1FDRxknaV4s6XqqAllGmgoU9d.png)

* 测试喂价程序
```
docker run -it --rm -v ~/.local/share/steem:/root ety001/steem-conductor conductor feed
```
![](/img/2018/10/oyrpAWa4MFtSsI8A8AFYO5VzJmM5R3UpZsbAdKJZ.png)
可以工作

* 启动喂价容器
```
docker run -itd --name steem-feed -v ~/.local/share/steem:/root --restart always ety001/steem-conductor conductor feed
```
![](/img/2018/10/My7FKQkHkc5j5JMP5nVyeg9sjxXEuoqUdIvhJYil.png)

完工！以后再部署喂价程序，两行命令就搞定了。