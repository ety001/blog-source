---
author: ety001
layout: post
title: 终于部署成功 handshake 域名
tags:
  - 服务器
  - 经验
  - 配置
  - handshake
  - namebase
---
# 前言

`handshake` 是一个基于区块链的分布式域名服务链。他的目标就是要把目前中心化的 ICANN 给取代掉。

由于 `handshake` 针对 `github` 的开发者进行了空投，我运气比较好的符合了空投规则，拿到了4000多个代币，于是我就有机会来体验一下整个拍卖和运行的过程。

# 原理

在目前阶段，我们是如何解析域名的呢？

假如我们有一个 `steem.61bts.com` 这样的域名，当我们访问这个域名的时候，系统会去DNS服务器获取 `61bts.com` 的 `NS` 记录，`NS`记录实际就是一台 `name server`，上面记录了 `61bts.com` 下面的所有域名与IP的对应关系。系统拿到 `NS` 记录后，访问 `name server`，就能拿到 `steem.61bts.com` 的真实 IP 地址了，然后就可以建立访问链接了。

那么有了 `handshake` 后是什么流程呢？

其实 `handshake` 做的工作就是把你的域名的 `NS` 记录存储在区块链上，这样人们访问 `steem.61bts.com` 的时候，会去区块链上找寻 `61bts.com` 的 `NS` 记录，然后再去访问 `name server`，最终拿到 IP 地址。

# 操作

目前 `handshake` 有一个面向用户友好的 `UI` 界面，即 [https://namebase.io](https://namebase.io)。

`Namebase` 的作用就是给用户提供一个方便拍卖，方便配置的 UI 界面。尤其是最近 `Namebase` 在配置面板上增加了他们自己维护的 `name server`（下面就简称 `NS` 了），更加方便用户去配置了。

这次的教程就是基于 `Namebase` 提供的 `NS` 服务器来搞的。

## 配置 NS 记录上链

访问 [https://www.namebase.io/domain-manager](https://www.namebase.io/domain-manager) ，选择你要配置的域名，点击后面的 **Edit DNS**。

在新的页面上，你可以看到分为上下两部分。

![](/upload/202004/handshake.png)

上半部分是配置域名的 `NS` 记录，下半部分是配置域名的解析地址（也就是 `Namebase` 官方提供给我们的 `NS` 的配置面板）。

在目前的中心化网络里，我们在域名商处买了域名，常见到的就是下半部分的配置面板。

在此之前，我们需要运行一台自己的 `NS` 服务器，但是现在，我们只需要把 `Namebase` 官方提供的 `NS` 的 IP 地址 `44.231.6.183` 添加进去即可。

具体操作方法就是在上半部分，增加一条 `NS` 记录，其中 `Name` 栏填写 `ns1`，`Value/Data` 栏填写 `44.231.6.183`，然后，在页面最下面，点击保存。

由于这个记录需要上链，所以需要等一段时间，等自己的记录成功打包进块，就完成了这部分的配置。也就是大家可以通过区块链查到你的域名指向了哪个 `NS` 服务器。

之后，你可以在下半部分，配置域名的 `A` 记录之类的了。

## 配置 handshake 全节点

那么在这个等待的时间，我们需要去搭建一个 `handshake` 的全节点。全节点的作用就是把整个区块链的数据下载下来，然后提供 `DNS` 服务，供你查询链上的域名 `NS` 记录。

我个人比较喜欢使用 `Docker`，所以这里的部署方案也是 `Docker` 部署。

目前，我已经编译好了一个 `Docker` 镜像，大家可以直接使用。

```
docker pull ety001/hsd:latest
```

> 你当然也可以自己去编译，源码库在这里： [https://github.com/handshake-org/hsd](https://github.com/handshake-org/hsd) 。

拉取完镜像后，创建一个目录用来存放区块数据，假设目录名为 `/data`

如果你想用宿主机网络运行容器，则执行下面的命令

```
docker run -itd \
    --name hsd \
    --restart always \
    -v /data:/root/.hsd \
    ety001/hsd:latest \
    hsd --rs-host 0.0.0.0 --rs-port 53 --rs-no-unbound true
```

如果你想用 `Docker` 独立的内部网络，则执行下面的命令

```
docker run -itd \
    --name hsd \
    --restart always \
    -v /data:/root/.hsd \
    -p 53:53 \
    -p 53:53/udp \
    ety001/hsd:latest \
    hsd --rs-host 0.0.0.0 --rs-port 53 --rs-no-unbound true
```

> 注意：请先查看你的 53 端口是否有其他程序占用

这样，一个全节点就在你的本地启动了。你可以使用下面的命令来查看 `Log` 信息

```
docker logs -f --tail 100 hsd
```

等到所有区块同步完成，你就可以测试下你的全节点是否可以正确检索到你的域名的 `NS` 记录了。

```
dig @localhost 你的handshake域名
```

如果一切顺利，你就可以看到你刚才配置的域名 `A` 记录了。

# 完成

上面的操作，如果一切顺利的话，这个时候，你就可以把你网络中的首选DNS换成你运行全节点的机器的IP了。

我是在我家里的磁盘阵列上搭建的全节点，然后在路由器上，把首选 `DNS` 设置为了磁盘阵列的机器的 IP，这样我家里的所有设备就都可以访问 `handshake` 的域名了。

另外，我还在公网上搭建了一个全节点用于解析，`172.81.246.231`，欢迎体验。
