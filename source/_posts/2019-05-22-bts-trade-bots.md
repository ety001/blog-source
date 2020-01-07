---
author: ety001
layout: post
title: 做了个非常精简的BTS内盘做市机器人
tags:
- Server&OS
- Bitshares
---


去年年初一直想修 **btsbots**，但是水平有限，在解析 **BTS** 区块数据那块，实在是搞不定，于是就放下了。前天，花了6个小时，按照之前 **btsbots** 的大致逻辑，实现了核心部分，现在已经封装成了 **Docker** 镜像。

# 拉取镜像
```
docker pull ety001/btsbots-cli
```

# 创建环境变量
```
vim env
```
环境变量的内容如下：
```
# 节点地址
API_URL=wss://bts.open.icowallet.net/ws
# 账号名
ACCOUNT=
# 账号active私钥
PRIV_KEY=
# 钱包密码
PASSWD=
# 做市市场 Quote:Base
MARKET=BTS:CNY
# 买单价格比率
BUY_RATE=0.01
# 卖单价格比率
SELL_RATE=0.01
# 花费base的数量
BUY_AMOUNT=10
# 得到base的数量
SELL_AMOUNT=10
# base货币最大持有量
BASE_MAX=2000
# quote货币最大持有量
QUOTE_MAX=2000
```

# 启动
```
docker run -d\
 --name btsbots\
 --restart always\
 --env-file env\
 ety001/btsbots-cli
```

# 查看log
```
docker logs btsbots
```

# 查看代码
```
docker run -it\
 --rm\
 ety001/btsbots-cli\
 cat /app/bots.py
```

# 解释
**btsbots** 的做市逻辑就是按照比当前最高买价低 `BUY_RATE` 的价格下买单，比当前最低卖价高 `SELL_RATE` 的价格下卖单。
举例说明一下，比如目前做 `BTS:CNY` 市场（`quote:base`)，当前最高买入BTS价是 `0.45 CNY`，最低卖出价是 `0.46 CNY`，
你的账号目前有 `200 CNY` 和 `500 BTS`，`BUY_RATE = 0.01`，`SELL_RATE = 0.02`，`BUY_AMOUNT=10`，`SELL_AMOUNT=20`。

> 市场中`quote`是要交易的对象，也就是如果你把 `BTS` 设置为 `quote`，那么就意味着你是在拿一种货币买入 `BTS`，
> 或者卖出 `BTS` 获取某种其他货币。

机器人的下单数据计算如下:

1.计算买入价: `buyPrice = 0.45 * (1-0.01)`
2.计算卖出价: `sellPrice = 0.46 * (1+0.02)`
3.买单买入 `BTS` 数量: `BUY_AMOUNT / buyPrice`
4.卖单卖出 `BTS` 数量: `SELL_AMOUNT / sellPrice`

符合下买单的条件:

1.当前没有买单
2.当前持有的 `quote币` 数量小于 `QUOTE_MAX` （要买的币还没买够，继续买）
3.当前持有的 `base币` 数量大于 `BUY_AMOUNT` （拿来买币的币足以下买单）

符合下卖单的条件

1.当前没有卖单
2.当前持有的 `base币` 数量小于 `BASE_MAX` （要卖的币还没卖够，继续卖）
3.当前持有的 `quote币` 数量大于 `SELL_AMOUNT / sellPrice` （要卖的币足够下卖单）

# 完

在不考虑小白用户的无脑输入异常处理，不考虑用户体验的情况下，只开发核心真的是轻松加愉快，只用了6个小时就完工了。

### 该程序不提供任何支持、答疑，不提供任何担保，交易风险自行承担。
### 该程序不提供任何支持、答疑，不提供任何担保，交易风险自行承担。
### 该程序不提供任何支持、答疑，不提供任何担保，交易风险自行承担。

祝玩的愉快～

![](http://image2.135editor.com/cache/remote/aHR0cHM6Ly9tbWJpei5xcGljLmNuL21tYml6X3BuZy91TjFMSWF2N29KOFc2ZHVCMU5samNoUWliaWNwczRlQTNoYnR2WnJRbENRODROUFRBN3RFdDZvSkxYeGlhUFdsSDlkNlFKV1pLbHdNUzJEQWhXMEgxMGZwZy8wP3d4X2ZtdD1wbmc)

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
