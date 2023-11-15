---
author: ety001
date: 2023-11-16 13:25:31+00:00
layout: post
title: 关于 SPS 相关总结
tags:
- steem
- steemit
- 经验
- 数字货币
- blockchain
- 区块链
---

# SPS的机制概述

* 用户提交提案，提案只要有投票就算是激活了。
* 提案的钱来自 steem.dao 账号，理论上每小时结算一次，按照投票数排序提案，顺次发钱，发完为止（因为每小时发放数额有限）。

# 资金来源

steem.dao 账号的资金来源于每次出块时 10% 的 steem，按照喂价中位数转化为 SBD 后存入，同时更新 dgp.sps_interval_ledger（相关逻辑在 database::process_funds() 中）。

dgp.sps_interval_ledger 会在每小时结算的时候清零（相关逻辑在 sps_processor::record_funding() 中）。

# 资金发放

**公式一:**

```
每天发放资金量 = steem.dao中的 SBD 数量 / 100 + 每日通胀
```

**公式二:**

```
当前小时发放资金 = (当前块时间戳 - 上次发放时间戳)/(24*3600) * 每天发放资金量
```

发放资金的时候，会按照投票数，从多到少排序所有激活的提案。

然后遍历排序好的提案，每个提案从公式二计算出的资金里发钱，直到公式二计算的资金发完为止（该逻辑在 sps_processor::transfer_payments() ）。

> 备注1: 当前块时间戳，在区块浏览器的某个块的 timestamp 字段。
> 备注2: 上次发放时间戳，可以从 dgp.last_budget_time 获得。
> 备注3: SPS 中的通胀在当前的 HF23 版本还没有设计好，所有涉及到通胀的地方都是 0。
> 备注4: 公式一和公式二在 sps_processor::calculate_maintenance_budget() 中。
> 备注5: https://steemdb.io/block/79880772 在这个页面的 Virtual Ops 下可以看到当时那个小时的结算情况。

# 当前状态

目前排名第一的提案，每小时提取 24w SBD 到 steem.dao 账号，而系统每小时发放的资金大约在 1600 SBD，所以第一名的提案把钱都花完了，相当于变相停止了 SPS 系统。

**但是目前排名第一的提案截止到 2029年12月31日，在其后面的还有一个截止 2030年3月1日的。这就意味着，最后这个提案可以从 2030年1月1日 到 2030年3月1日，每小时获得 1000 SBD。**