---
author: ety001
layout: post
title: 'Stellar开发中关于offer相关的总结'
tags:
- 教程
- 理论
---
最近完工的 [StellarBot v0.0.8](https://steemit.com/utopian-io/@ety001/stellarbot-v0-0-8-has-been-released) 对核心进行了重写，由于之前赶比赛进度，一直没有在offer这块搞明白。这次花了大量的时间来研究orderbook和创建offer这两部分的重要参数。这篇文章就是对于之前研究的一个总结。（是不是现在就已经开始晕了？一会order一会offer的。）

本文将会根据 `base/counter` 为交易单位来总结，如果对于 `base/counter` 还不明白的，请先看我之前写的 [这篇文章](https://steemit.com/cn/@ety001/6duqmh)，里面解释了这种单位的意思是怎样的。

# Orderbook


```
GET /order_book?selling_asset_type={selling_asset_type}&selling_asset_code={selling_asset_code}&selling_asset_issuer={selling_asset_issuer}&buying_asset_type={buying_asset_type}&buying_asset_code={buying_asset_code}&buying_asset_issuer={buying_asset_issuer}&limit={limit}
```

上面的就是 *Orderbook* 的 *REST API*。我们可以看到这个接口有以下参数：

| name | notes | description | example |
| --- | --- | --- | --- |
| `selling_asset_type` | required, string | Type of the Asset being sold | `native` |
| `selling_asset_code` | optional, string | Code of the Asset being sold | `USD` |
| `selling_asset_issuer` | optional, string | Account ID of the issuer of the Asset being sold | `GA2HGBJIJKI6O4XEM7CZWY5PS6GKSXL6D34ERAJYQSPYA6X6AI7HYW36` |
| `buying_asset_type` | required, string | Type of the Asset being bought | `credit_alphanum4` |
| `buying_asset_code` | optional, string | Code of the Asset being bought | `BTC` |
| `buying_asset_issuer` | optional, string | Account ID of the issuer of the Asset being bought | `GD6VWBXI6NY3AOOR55RLVQ4MNIDSXE5JSAVXUTF35FRRI72LYPI3WL6Z` |
| `limit` | optional, string | Limit the number of items returned | `20` |

（该表格来自 [https://www.stellar.org/developers/horizon/reference/endpoints/orderbook-details.html](https://www.stellar.org/developers/horizon/reference/endpoints/orderbook-details.html)）

官方给的这张表格，感觉太不好理解了，以下是我总结出来的参数和 `base/counter` 的对应关系：

![1.png](https://steemitimages.com/DQmf8dnAFZbrBHrtAEPQbkDjPKqzdTjatsnTVkDeWo9JduQ/1.png)

再结合着实际的数据来看一下（[接口](https://horizon.stellar.org/order_book?selling_asset_type=native&buying_asset_type=credit_alphanum4&buying_asset_code=CNY&buying_asset_issuer=GAREELUB43IRHWEASCFBLKHURCGMHE5IF6XSE7EXDLACYHGRHM43RFOX&limit=2) 返回数据与钱包数据的对应图）：

![](https://steemitimages.com/DQmanWcxba8m88vtDUBHsZ3dSVUJCkHTt2LZFfaZyzE4QaM/image.png)

**注意 *Orderbook* 接口返回的数据里，买卖单的 `amount` 是不同货币的》**

# 提交 Offer 的各种参数

在 *Stellar* 系统里把单个订单称作 *offer*，这就跟之前的 *orderbook* 感觉跟别扭。这样的命名别扭会一直贯穿整个开发过程，所以我直接在我的代码里用了 *order* 代替 *offer*。

管理订单的接口文档 [在这里](https://www.stellar.org/developers/horizon/reference/resources/operation.html#manage-offer) 可以看到，我摘录过来相关的参数表格如下：

| Field | Type | Description |
| --- | --- | --- |
| offer_id | number | Offer ID. |
| amount | string | Amount of asset to be sold. |
| buying_asset_code | string | The code of asset to buy. |
| buying_asset_issuer | string | The issuer of asset to buy. |
| buying_asset_type | string | Type of asset to buy (native / alphanum4 / alphanum12) |
| price | string | Price to buy a buying_asset |
| price_r | Object | n: price numerator, d: price denominator |
| selling_asset_code | string | The code of asset to sell. |
| selling_asset_issuer | string | The issuer of asset to sell. |
| selling_asset_type | string | Type of asset to sell (native / alphanum4 / alphanum12) |

**这里面最需要注意的就是 *price* 的计算是不同于 *orderbook* 中的 *price* 的。**，以下是我总结的参数(params)和 *base/counter* 的对应关系：

![创意 - 9.png](https://steemitimages.com/DQmRx5cHkkZN5bnLRDkFuk4YqR5C1U2PZfXDSaBRQwrNcXo/%E5%88%9B%E6%84%8F%20-%209.png)

# 总结

开发中，主要注意的就是各个位置的 *price* 和 *amount* 计算和其代表的意义。多对照钱包和接口返回数据看几遍，应该就可以慢慢的参透其中的奥义，也就能看明白我总结的两张图里面的意思。再开发的时候，我的这两张图就会起到类似公式一样的作用。
