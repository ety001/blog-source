---
author: ety001
layout: post
title: 在自有私链上使用bitshares-js库
tags:
- Bitshares
---

由于我正在搭建的测试网络属于私有链，在这两天的开发中，我发现使用 `bitshares-ws` 中的 `Apis` 进行初始化的时候，一直有下面截图中的问题

![](/upload/20191213/fOe22UYf8pNGrgze9EQ8MmBEfpMJyHYPpbzbusO7.png)

我的代码是官方文档示例中的

```
import {Apis} from 'bitsharesjs-ws';
const apiUrl = 'wss://api-testnet.61bts.com';
Apis.instance(apiUrl, true).init_promise.then((res) => {
    console.log(res);
});
```

即返回值的第一个值一直是 `undefined`，目前还不确定这个会导致什么问题，不过有个 `undefined` 肯定是不对的。

去看了下 `Apis.instance().init_promise` 的代码，我摘了关键部分如下：

```
const newApis = () => ({
  connect: (
    cs,
    connectTimeout,
    optionalApis = { enableCrypto: false, enableOrders: false }
  ) => {
    ......
    Apis.init_promise = Apis.ws_rpc
      .login(rpc_user, rpc_password)
      .then(() => {
        //console.log("Connected to API node:", cs);
        Apis._db = new GrapheneApi(Apis.ws_rpc, "database");
        Apis._net = new GrapheneApi(Apis.ws_rpc, "network_broadcast");
        Apis._hist = new GrapheneApi(Apis.ws_rpc, "history");
        if (optionalApis.enableOrders)
          Apis._orders = new GrapheneApi(Apis.ws_rpc, "orders");
        if (optionalApis.enableCrypto)
          Apis._crypt = new GrapheneApi(Apis.ws_rpc, "crypto");
        var db_promise = Apis._db.init().then(() => {
          //https://github.com/cryptonomex/graphene/wiki/chain-locked-tx
          return Apis._db.exec("get_chain_id", []).then(_chain_id => {
            Apis.chain_id = _chain_id;
            return ChainConfig.setChainId(_chain_id);
            //DEBUG console.log("chain_id1",this.chain_id)
          });
        });
        ......
        let initPromises = [db_promise, Apis._net.init(), Apis._hist.init()];

        if (optionalApis.enableOrders) initPromises.push(Apis._orders.init());
        if (optionalApis.enableCrypto) initPromises.push(Apis._crypt.init());
        return Promise.all(initPromises);
      })
      ......
  },
  ......
});
```

可以看到 `Apis.init_promise` 最终是返回了一个 `Promise.all()`，其中索引 `0` 的值是 `db_promise`。

再看了一下，`db_promise` 的结果由 `ChainConfig.setChainId()` 来决定。

再找出 `ChainConfig` 的代码，这个文件代码不长，我就全部贴出来了

```
var config = {
  core_asset: "CORE",
  address_prefix: "GPH",
  expire_in_secs: 15,
  expire_in_secs_proposal: 24 * 60 * 60,
  review_in_secs_committee: 24 * 60 * 60,
  networks: {
    BitShares: {
      core_asset: "BTS",
      address_prefix: "BTS",
      chain_id:
        "4018d7844c78f6a6c41c6a552b898022310fc5dec06da467ee7905a8dad512c8"
    },
    Muse: {
      core_asset: "MUSE",
      address_prefix: "MUSE",
      chain_id:
        "45ad2d3f9ef92a49b55c2227eb06123f613bb35dd08bd876f2aea21925a67a67"
    },
    Test: {
      core_asset: "TEST",
      address_prefix: "TEST",
      chain_id:
        "39f5e2ede1f8bc1a3a54a7914414e3779e33193f1f5693510e73cb7a87617447"
    },
    Obelisk: {
      core_asset: "GOV",
      address_prefix: "FEW",
      chain_id:
        "1cfde7c388b9e8ac06462d68aadbd966b58f88797637d9af805b4560b0e9661e"
    }
  },

  /** Set a few properties for known chain IDs. */
  setChainId: chain_id => {
    let result = Object.entries(config.networks).find(
      ([network_name, network]) => {
        if (network.chain_id === chain_id) {
          config.network_name = network_name;

          if (network.address_prefix) {
            config.address_prefix = network.address_prefix;
          }
          return true;
        }
      }
    );

    if (result) return { network_name: result[0], network: result[1] };
    else console.log("Unknown chain id (this may be a testnet)", chain_id);
  },

  reset: () => {
    config.core_asset = "CORE";
    config.address_prefix = "GPH";
    config.expire_in_secs = 15;
    config.expire_in_secs_proposal = 24 * 60 * 60;

    console.log("Chain config reset");
  },

  setPrefix: (prefix = "GPH") => (config.address_prefix = prefix)
};

export default config;
```

可以看到在 `ChainConfig` 对象中有个 `networks` 的值，在进行 `setChainId()` 操作的时候，会在这个 `networks` 里搜索，找不到符合条件的结果，就会进入 `else`，也就是这个 `setChainId()` 会返回 `undefined`。

好了找到了问题所在，那么我们只需要在 `Apis.instance().init_promise` 之前，先配置下 `ChainConfig`。

但是 `ChainConfig` 在 `init_promise` 中，我们怎么配置呢？

结合上一篇文章 [https://blog.domyself.me/2019/12/12/bitshares-ws-api-url-confuse.html](https://blog.domyself.me/2019/12/12/bitshares-ws-api-url-confuse.html) ，我们知道使用 `import` 可以引入库的引用，那么我们在调用前，先 `import ChainConfig` 配置好就OK了。

最终代码如下：

```
import {Apis, ChainConfig} from 'bitsharesjs-ws';
const apiUrl = 'wss://api-testnet.61bts.com';
ChainConfig.networks['LiuyeTest'] = {
    core_asset: 'TEST',
    address_prefix: 'TEST',
    chain_id: 'd5dfe0da7cda9426dc4761752d889d44401c5f04f76c17970e90437b02c038d4',
};
Apis.instance(apiUrl, true).init_promise.then((res) => {
    console.log(res);
});
```

---
##### ET碎碎念，每周一，晚六点一刻更新，欢迎订阅
##### 也可以订阅号留言
![](/img/wechat-subscribe.jpg)
