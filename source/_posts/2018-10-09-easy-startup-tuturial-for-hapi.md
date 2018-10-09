---
author: ety001
layout: post
title: '使用 hapijs 快速构建自己的 api 服务'
tags:
- 后端
- 编程语言
---

![](/img/2018/10/8.png)

最近接手的 `Stellar` 钱包的外包小活需要搭建个 `API` 服务，考虑再三，由于 `Stellar SDK` 中我只会 `Javascript`，因此打算使用 `Nodejs` 去完成这个服务搭建工作。

大约5年前曾经用 `Express` 框架搭建过一个记事本网站，不过这次是做 `API`，用 `Express` 感觉好像太重了，于是搜索了下，发现了 [hapi](https://hapijs.com/) 这个框架。

说干就干。

首先初始化一个 `Nodejs` 项目

```
npm init
```

然后安装一下 `hapi`，

```
npm install hapi -s
```

创建一个 `index.js` 文件，并粘贴下面的代码

```
'use strict';

const Hapi = require('hapi');
const server = Hapi.server({
    port: 8877,
});

server.route({
  method: 'GET',
  path: '/',
  options: {
    cors: true
  },
  handler: (request, h) => {
    return 'Hello, ' + request.query.r;
  }
});

const init = async () => {
  await server.start();
  console.log(`Server running at: ${server.info.uri}`);
};

process.on('unhandledRejection', (err) => {
  console.log(err);
  process.exit(1);
});

init();
```

启动一下，并访问 `http://localhost:8877/?r=ety001`，会看到 `Hello, ety001`。

这样最简单的 `API` 服务就搞定了。

> 这里需要注意下 cors 这个配置，这个设置为 true，就可以避免跨域的报错，不过安全性需要注意，详细的配置参数请看 hapi 的文档。

除此之外，我还加入了缓存。因为每次去获取 `Trade Aggregation` 数据都需要大约5--6秒，这样的性能还是不行的。因此加入一个10秒的缓存，10秒内访问，将会返回缓存数据。

加入方法很简单，大致的代码结构如下：

```
const getTradePair = async (pointPair) => {
  // the code to get trade pairs and trade aggregation
}
const traidPairCache = server.cache({
  expiresIn: 10 * 1000,
  segment: 'customSegment',
  generateFunc: async (pair) => {
    return await getTradePair(pair);
  },
  generateTimeout: 20000
});
server.route({
  method: 'GET',
  path: '/v2/api/trade_aggregations',
  options: {
    cors: true
  },
  handler: async (request, h) => {
    return await traidPairCache.get('pair');
  }
});
```

这里说明下。 `traidPairCache` 中 `generateFunc` 方法就是在缓存未命中的时候，去获取新数据的方法。第一个参数相当于是缓存的标示，`generateTimeout` 就是 `generateFunc` 的执行超时时间。

> hapi 使用 [catbox](https://github.com/hapijs/catbox) 来实现缓存，框架默认使用 `memory` 作为缓存介质。

以上就是目前我所用到的功能，`hapi` 框架真的很轻，在处理些类似我这样的需求的时候，最省时间，尤其再配合 `Docker`，把服务直接做成镜像，部署起来也就一句话的事儿~~
