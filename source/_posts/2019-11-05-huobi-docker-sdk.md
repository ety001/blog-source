---
author: ety001
layout: post
title: 用Docker封装了火币的python sdk
tags:
- Docker
---

天天盯盘实在是有点吃不消了，有些工作还是需要用机器来完成。
由于已经习惯了靠 Docker 部署，所以先把基础工作做好，把火币
的 python sdk 环境封装个 Docker 基础包。

# Dockerfile
```
FROM alpine:3.9
WORKDIR /app
ARG TAG=1.0.5
RUN apk --no-cache add git python3 && \
    git clone https://github.com/HuobiRDCenter/huobi_Python.git && \
    cd huobi_Python && \
    git checkout ${TAG} && \
    python3 setup.py install && \
    cd .. && \
    rm -rf huobi_Python
CMD ["pwd"]
```

编译的时候，可以通过 ARG 来控制你要使用的版本。

```
docker build --build-arg TAG=1.0.5 -t ety001/huobi-lib:1.0.5 .
```

# 测试一下
在当前目录创建个测试文件 `a.py`
```
from huobi import SubscriptionClient
from huobi.model import *
from huobi.exception.huobiapiexception import HuobiApiException
from huobi import RequestClient

request_client = RequestClient()

# Get the timestamp from Huobi server and print on console
timestamp = request_client.get_exchange_timestamp
print(timestamp)

# Get the latest btcusdt‘s candlestick data and print the highest price on console
candlestick_list = request_client.get_latest_candlestick("btcusdt", CandlestickInterval.DAY1, 20)
for item in candlestick_list:
    print(item.high)
```

启动一个临时容器，测试一下我们的 SDK 是否安装正确

```
docker run -it --rm -v $(pwd):/app ety001/huobi-lib:1.0.5 python3 /app/a.py
```

如果环境正确，则会正常输出数据。

OVER！接下来就要去研究下火币的各个 API 了。
