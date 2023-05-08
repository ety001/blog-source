---
author: ety001
date: '2022-04-02 08:24:49+00:00'
layout: post
title: 在 github actions 中使用 telegram 推送消息
tags:
  - 经验
  - Server&OS
---

最近在研究 github actions。 这个是 github 提供的 CI/CD 服务，并且对于开源库来说，几乎就是免费使用。

得利于 github actions 支持很多的环境，所以可以做很多的事情。

最近研究的方向就是 github actions 的计划任务功能。

而计划任务执行完需要通知我一下。

当前我自己用的比较多的是 telegram，所以优先找了一下如何发消息到 telegram 的方法。

```
name: 'GitHub Actions Test for Telegram Notification'

on:
  schedule:
    - cron: '30 0 * * *'

jobs:
  bot:
    runs-on: ubuntu-latest
    steps:
      - name: 'Send telegram message'
        uses: appleboy/telegram-action@master
        with:
          to: ${{ secrets.TELEGRAM_TO }}
          token: ${{ secrets.TELEGRAM_TOKEN }}
          message: |
            this is the test message
```

只要再在 github 这个库的设置里面，增加 secrets 设置（TELEGRAM_TO 和 TELEGRAM_TOKEN）即可。