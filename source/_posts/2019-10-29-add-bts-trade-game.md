---
author: ety001
layout: post
title: 我也加入了bitshares交易赛的战局
tags:
- Bitshares
- Docker
---
具体的比赛贴子：[https://bitsharestalk.org/index.php?topic=29665.0](https://bitsharestalk.org/index.php?topic=29665.0)

使用我之前开发的机器人参赛非常简单。这里是之前发布机器人时的贴子：[http://blog.domyself.me/2019/05/22/bts-trade-bots.html](/2019/05/22/bts-trade-bots.html) 。

本教程是在Linux下运行。

首先，需要有Docker环境，具体Docker安装方法请参考Docker官方网站。

然后，创建一个环境变量文件，用于配置你的机器人，内容如下：

```
# 节点地址
API_URL=wss://bts.open.icowallet.net/ws
# 账号名
ACCOUNT=
# 账号active私钥
PRIV_KEY=
# 钱包密码
PASSWD=123456
# 做市市场 Quote:Base
MARKET=GDEX.BTC:BTS
# 买单价格比率
BUY_RATE=0.01
# 卖单价格比率
SELL_RATE=0.01
# 花费base的数量
BUY_AMOUNT=100
# 得到base的数量
SELL_AMOUNT=100
# base货币最大持有量
BASE_MAX=2000
# quote货币最大持有量
QUOTE_MAX=2000
```

假设该文件名为 `bts_bts`。

启动机器人的命令如下：

```
docker run -itd \
 --name bot1 \
 --restart always \
 --env-file btc_bts \
 ety001/btsbots-cli:latest
```

启动之后，可以用 `docker logs -f --tail 100 bot1` 来查看机器人的运行状态。

如果想要停止并删除机器人，执行 `docker stop bot1 && docker rm bot1` 即可。

---
#### ET碎碎念，每周一，晚六点一刻更新，欢迎订阅
![](http://blog.domyself.me/img/wechat-subscribe.jpg)
