---
author: ety001
layout: post
title: bitshares-ws 的 API 配置疑惑
tags:
- Bitshares
---

目前正在开发针对 `Bitshares` 的测试工具，一开始就让我遇到了疑惑，先来看代码：

```
import {Apis} from "bitsharesjs-ws";
var {ChainStore} = require("bitsharesjs");

Apis.instance("wss://eu.nodes.bitshares.ws", true).init_promise.then((res) => {
    console.log("connected to:", res[0].network);
    ChainStore.init().then(() => {
        ChainStore.subscribe(updateState);
    });
});

let dynamicGlobal = null;
function updateState(object) {
    dynamicGlobal = ChainStore.getObject("2.1.0");
    console.log("ChainStore object update\n", dynamicGlobal ? dynamicGlobal.toJS() : dynamicGlobal);
}
```

上面这段代码是来自 `bitshares-js` 的官方文档的示例代码，其中我有两个疑惑，一个是 `API` 地址的设置，一个是 `subscribe` 是在什么时候调用的，`ChainStore` 到底该如何使用。

这篇文章是来写第一个疑惑的。

通过翻代码，可以看到在 `ChainStore.init()` 中也有调用 `Apis.instance()`，但是却没有方法指定 `API` 的 `URL`。于是我很好奇这个到底是怎么确定 `ChainStore` 在使用哪个节点呢？

去看 `bitshares-ws` 中关于 `Apis.instance()` 的代码，发现有其中一段代码

```
var Apis = null;
export const instance = (
  cs = "ws://localhost:8090",
  connect,
  connectTimeout = 4000,
  optionalApis,
  closeCb
) => {
  if (!Apis) {
    Apis = newApis();
    Apis.setRpcConnectionStatusCallback(statusCb);
  }

  if (Apis && connect) {
    Apis.connect(cs, connectTimeout, optionalApis);
  }
  if (closeCb) Apis.closeCb = closeCb;
  return Apis;
};
```

这里我们可以看到在 `Apis.instance()` 这个库代码里，有一个变量 `Apis`，对于我这种 `js` 半路出家的人来说，并不理解这个 `Apis` 到底是在哪个局部生效的。

也就是说，我在同一个项目的不同位置，`import` 同一个库的时候，库里的变量到底是指向两个内存地址，还是指向了同一个内存地址。按照目前 `bitshares-js` 给的示例代码来猜测，是指向了同一个内存地址。

于是我自己写了个简单的例子，来测试了一下。

```
-- main.js --
import t from './test2';
import init from './test1';

t();
const anotherGVal = init();
console.log('another g val:', anotherGVal);

-- test1.js --
var g = null;
export const init = () => {
  if (!g) {
    console.log('not defined');
    g = 1;
  }
  console.log('has defined');
  return g;
}

-- test2.js --
import init from './test1';

export const t = () => {
  const gVal = init();
  console.log('gVal is:', gVal);
}
```

最终指向结果就是，只打印了一次 `not defined`，也就说明了，在我的测试代码中，第二次调用 `test1.init()` 的时候，变量 `g` 其实已经存在了。

这也就说明了 `ChainStore.init()` 中再次调用 `Apis.instance()` 的时候，由于之前已经调用过，所以 `Apis` 已经存在了。

再后来我又搜索了关于 `javascript` 中 `import` 相关的文章，发现了这篇文章 [https://zhuanlan.zhihu.com/p/33843378](https://zhuanlan.zhihu.com/p/33843378) 。

** 总结下就是在同个项目下， `import` 同一个库只会执行一次，且返回结果是引用。 **
