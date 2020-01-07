---
author: ety001
layout: post
title: 如何使用Bitshares Python库一次下多个Fill or Kill单
tags:
- Bitshares
---

Bitshares Python库的文档并没有写如果在一个tx中下多个单的方法，经过看源码，找到了方法。
现总结下代码

```
from bitshares import BitShares
from bitshares.market import Market
from bitshares.asset import Asset
from bitshares.account import Account
from bitshares.utils import formatTimeFromNow
from bitsharesbase import transactions, memo, account, operations, objects

API_URL = 'ws://127.0.0.1:8090/ws'
PRIV_KEY = '这是账号私钥'
ACCOUNT_NAME = 'ety001'

# 创建连接
bitshares = BitShares(API_URL, keys=PRIV_KEY)
# 创建账号实体
importAccount = Account(ACCOUNT_NAME, blockchain_instance=bitshares)

# 拿到 orderbook
market = Market('BTS:CNY', blockchain_instance=bitshares)
orderbook = market.orderbook(1)
sellAssetId = orderbook['bids'][0]['quote']['asset']['id']
receiveAssetId = orderbook['bids'][0]['base']['asset']['id']
amountToSell = 3 * 10 ** orderbook['bids'][0]['quote']['asset']['precision']
receiveAmount = 5 * 10 ** orderbook['bids'][0]['base']['asset']['precision']

# 创建订单
op1 = operations.Limit_order_create(
    **{
        "fee": {"amount": 0, "asset_id": "1.3.0"},
        "seller": importAccount['id'],
        "amount_to_sell": {
            "amount": int(round(amountToSell)),
            "asset_id": sellAssetId,
        },
        "min_to_receive": {
            'amount': int(round(receiveAmount)),
            "asset_id": receiveAssetId,
        },
        "expiration": formatTimeFromNow(60 * 60 * 24 * 7),
        "fill_or_kill": True,
        "extensions": [],
    }
)
op2 = operations.Limit_order_create(
    **{
        "fee": {"amount": 0, "asset_id": "1.3.0"},
        "seller": importAccount['id'],
        "amount_to_sell": {
            "amount": int(round(amountToSell)),
            "asset_id": sellAssetId,
        },
        "min_to_receive": {
            'amount': int(round(receiveAmount)),
            "asset_id": receiveAssetId,
        },
        "expiration": formatTimeFromNow(60 * 60 * 24 * 7),
        "fill_or_kill": True,
        "extensions": [],
    }
)
opList = []
opList.append(op1)
opList.append(op2)

# 下单
bitshares.finalizeOp(opList, ACCOUNT_NAME, 'active')
```

**说明：**

> 1. 需要连接获取数据的方法，请使用参数 `blockchain_instance` 把你自己创建的对象传入，
> 否则连接的 `API` 并不是你指定的。默认连接库作者的 `API`。
> 2. 买入卖出数量需要转换成整数，即乘以 `precision`

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
