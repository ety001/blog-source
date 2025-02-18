---
author: ety001
title: hclient-cli 纯终端界面下接入懒猫网络工具
date: 2025-02-18 17:21:15
layout: post
tags:
- 经验
- 服务器
---

# 简介

[hclient-cli](https://gitee.com/lazycatcloud/hclient-cli) 是官方推出的一个面向无图形界面的机器的接入方案。

有这个工具的情况下，我们可以让我们远端的服务器接入到懒猫的网络中，访问懒猫上的数据资源。

# 使用

官方库文档有接口的使用说明，这里就不再阐述，我[提交了一个 PR](https://gitee.com/lazycatcloud/hclient-cli/pulls/2)，对官方的接口简单的用 bash 脚本封装了一下，减少使用过程中的输入量。同时还包含了一个构建 Docker 镜像的方案，其实就是把 cli 程序加入到镜像中。

目前我的远端服务是 Docker 容器形式运行的，因此这里分享一下 Docker 使用样例。

这里的远端应用以我的远端服务器上的青龙面板为例。

首先给出一个 Docker 容器启动命令示例：

```
docker run -itd \
    --privileged \
    --name lazycat \
    --hostname lazycat_in_docker \
    --restart always \
    --network lnmp \
    --ip 172.20.0.66 \
    -p 127.0.0.1:7777:7777 \
    -p 127.0.0.1:61090:61090 \
    -v /data/cfg:/app/cfg \
    ety001/lazycat-cli:latest \
    /app/hclient-cli \
      -api-addr "172.20.0.66:7777" \
      -http-addr "172.20.0.66:61090"
```

> 1. 请注意不要暴露你的 7777 管理端口和 61090 代理端口给全局网络
> 2. 容器启动后，所有 lnmp 网络中的容器可以通过 `172.20.0.66:61090` 代理访问懒猫资源。
> 3. 宿主机可以通过 `127.0.0.1:7777` 管理，通过 `127.0.0.1:61090` 代理访问。

在宿主机中，调用 `cmd.sh` （在我的那个 PR 中）完成懒猫网络的登陆。

```
./cmd.sh add_box
./cmd.sh add_tfa
./cmd.sh client_info
```

登陆成功后，打开远端的青龙面板，安装依赖 `axios` 和 `https-proxy-agent`。之后增加环境变量配置如下：

```
LAZYCAT_PROXY=http://172.20.0.66:61090
INFLUXDB_TOKEN=xxxx
INFLUXDB_URL=http://influxdb.ecat.heiyu.space:8086
```

创建一个新的测试 js 脚本如下：

```
const axios = require('axios');
const { HttpsProxyAgent } = require('https-proxy-agent');

const proxy = process.env.LAZYCAT_PROXY;
const agent = new HttpsProxyAgent(proxy);

// 自定义 HTTP 客户端，使用 axios 和代理
const customHttpClient = axios.create({
    httpAgent: agent,
    httpsAgent: agent,
});

const token = process.env.INFLUXDB_TOKEN;
const url = process.env.INFLUXDB_URL;
const org = 'default';
const bucket = 'steem';


// 定义 Flux 查询
const fluxQuery = `
  from(bucket: "${bucket}")
    |> range(start: -1h)
    |> filter(fn: (r) => r._measurement == "price")
    |> filter(fn: (r) => r._field == "lowest_ask")
`;

// 发送查询请求
async function queryData() {
  try {
    const response = await customHttpClient.post(
      `${url}/api/v2/query?org=${org}`,
      {
        query: fluxQuery,
        type: 'flux',
      },
      {
        headers: {
          Authorization: `Token ${token}`,
          'Content-Type': 'application/json',
        },
      }
    );
    console.log('查询结果:', response.data);
  } catch (error) {
    console.error('查询数据时出错:', error.response ? error.response.data : error.message);
  }
}

queryData();
```

调试运行，成功获取到懒猫微服上的 `Influxdb` 中的数据。

![image.png](/img/2025/286002a6-e5d5-4aaa-90d8-f99d5be5a4d3.png "image.png")