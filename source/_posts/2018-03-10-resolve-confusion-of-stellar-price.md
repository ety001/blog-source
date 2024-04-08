---
author: ety001
layout: post
title: '困惑我很久的价格单位终于弄明白了'
tags:
- 教程
---

> 这篇可能又会是一篇比较晦涩的文章了。可能也许写完了也就只有我自己能看懂了吧。。

在没有开发恒星做市机器人之前，一直都没有仔细关注过交易市场的价格单位。

由于交易市场之前都是 `CNY` 和具体的数字货币交易，所以交易所显示的价格都是买一个数字货币需要多少 `CNY`，我只需要看具体的数值即可，并不影响我判断什么时候买入，什么时候卖出。

在开发[第一版的机器人](https://stellar.to0l.cn)的时候，由于只是在单网关下做 `XLM` 和 `CNY`这一个交易对，也就没有在意价格单位的问题。

但是从开发[第二版机器人](https://stellarbot.top)开始，由于加入了多网关多币种之间互相做市的功能，就不得不看看具体的单位到底代表什么意思了。

之前每次扫到类似 `BTC/CNY ` 这样的单位的时候，总以为这是个分数，比如 `60000 BTC/CNY` 我会以为是每一个 `CNY` 可以买到 60000 个 `BTC`，由于这个例子使用的是 `CNY` ，我们心里清楚目前 `BTC` 值多少 `CNY`，因此才知道我刚才的阅读单位的方式是错误的。

目前我开发机器人过程中，会出现两个陌生币种之间的交易，这个时候，如果不能真正了解价格单位的意义，开发出来的机器人肯定会是有问题的。

所以到底类似 `BTC/CNY` 这样的交易对价格单位该如何正确解读呢？

在说正确方法之前，还要再插一句，就是 `BTS` 内盘的价格单位其实在很长一段时间都是给我有误导作用的。我们看一下在内盘抵押 `BTS` 的时候，出现的喂价和强平触发价的单位。

![](https://steemitimages.com/DQmQw1vDLJDuF2CxznpCxenw2pkXapvEkG88yGPRf7XgdMt/image.png)

*这里的单位就真的是分数式的解读啊！*比如强平触发价 `2.97143 BTS/bitCNY`，就是当 1 个 `bitCNY` 可以买到 2.97143 个 `BTS`，也就是 1 个 BTS 值大约 0.3365 `bitCNY` 的时候爆仓。

下面就来说下到底该如何解读交易所的交易对的价格单位。

我以 `base currency and counter currency` 作为关键词，在 `Google` 上搜索了下，发现了这个解释 [https://www.investopedia.com/terms/b/basecurrency.asp](https://www.investopedia.com/terms/b/basecurrency.asp)。

简单来说，这是外汇市场的一个约定俗成的表示方法，而 **不是** 一个分数形式的表示，只是通过先后顺序来表示关注程度。一个交易对的价格使用类似 `base currency/counter currency` 的格式来表示，意味着我更关注 `base currency` 的价值是升了还是跌了，也就是我买一个 `base currency` 要花多少 `counter currency` 或者 卖一个 `base currency` 能得到多少 `counter currency`。就是这么简单的按照顺序阅读即可。

举个例子，比如说 `BTC/CNY` 这个交易对，之前 `60000 BTC/CNY` 应该解读为我购买 1 个 `BTC` 需要花费 60000 个 `CNY`，如果购买一天后价格变为了 `70000 BTC/CNY`，就意味着我关注的这个 `base currency` 即 `BTC` 升值了。

**总结一下，其实 `counter currency` 就是你手里的筹码。`base currency` 是你想持有的。**

这样一来，你关心哪个币的涨跌，就把哪个币设置为 `base currency` 就可以轻松的了解是否升值了。

以上就是完整的价格单位如何解读的内容了，下面是吐槽内容，选读：

> 除了恶心的价格单位外，再说一下 `bid` 和 `ask`，这个也是让我头疼的东西。
> 放狗搜索了下，发现了这篇文章，[https://www.bitcoinmarketjournal.com/difference-bid-ask-buy-offer-cryptocurrency-trading/](https://www.bitcoinmarketjournal.com/difference-bid-ask-buy-offer-cryptocurrency-trading/)，发现老外也真是够了。
> 原来 `bid price` 代表了最高的买价，`ask price` 代表了最低的卖价，而 `buy price` 和 `sell price` 只是代表最终的成交价。。。
> WTF，为啥要多搞出来两个名词，对于中文来说都是买价卖家，无非加上最低和最高这样的形容词罢了。。。
> 我还要吐槽的是，恒星币的接口返回的 `orderbook` 里用 `buy` 和 `sell` 来表示买单列表和卖单列表并没有不严谨吧，反而用的是 `asks` 和 `bids` 来表示卖单列表和买单列表。每次我都是要反应半天！只能说还是我的英语学的不好。
> 说到 `orderbook`，又想起了另外一个槽点，就是在恒星币的 `API` 体系里清一色的都是 `offer`，而这里却是 `orderbook`，你咋不叫 `offerbook` 呢？
> 吐槽完毕！