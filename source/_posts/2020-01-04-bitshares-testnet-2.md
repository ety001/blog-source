---
author: ety001
layout: post
title: 快速搭建私有单节点 Bitshares Testnet（二）
tags:
- Bitshares
---

# 前言

在 [《快速搭建私有单节点 Bitshares Testnet（一）》](/2019/11/27/bitshares-testnet-1.html) 中，讲解了如何搭建一个私有测试网络，这一篇将会讲解如何部署 Web 界面用于注册新用户，以及向新用户转账测试币。

# 部署

## 拉取代码

```
git clone https://github.com/ety001/bitshares-testnet-for-dapp-developers.git
```

## 编译镜像

```
cd bitshares-testnet-for-dapp-developers
docker build -t btfdd:latest .
```

> 你也可以直接使用我编译好的镜像，`docker pull ety001/btfdd:latest`

## 运行

```
docker run -itd \
  --restart always \
  --name btfdd \
  -p 3000:3000 \
  -e PRIV_KEY=5Jxxxxxx \
  -e API_URL=ws://192.168.0.10/ws \
  -e CHAIN_ID=2d20869f3d925cdeb57da14dec65bbc18261f38db0ac2197327fc3414585b0c5
  -e CORE_ASSET=TEST
  btfdd:latest
```

**环境变量说明**
* `PRIV_KEY` 是你用来作为水龙头的账号的 `active` 私钥
* `API_URL` 是你私有测试网络的地址。**这里需要注意下地址是否可访问。**
* `CHAIN_ID` 是你私有测试网络的 `CHAIN_ID`
* `CORE_ASSET` 是你私有网络的测试币名

## 访问

如果一切正常，这个时候浏览器访问 `http://localhost:3000` 即可看到工具页面了。

![](/upload/20200104/r8pKvKBaGy8mEqOYCTia9xCycrqyx4v9eMvWFAnl.png)

目前工具只提供创建账号和转账的功能。

## 公共服务

目前我也搭建了公共服务免费供大家使用，地址: [https://testnet.61bts.com](https://testnet.61bts.com) 。

# 疑问

如果有问题可以给我发邮件 `work#akawa.ink` 或者提交 [issue](https://github.com/ety001/bitshares-testnet-for-dapp-developers/issues)。
