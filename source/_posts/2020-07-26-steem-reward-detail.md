---
author: ety001
layout: post
title: 在 alpine 容器中使用 crontab
tags:
  - steem
  - 经验
---

> 为了方便查看相关的系统参数和变量，我写了一个工具，文章中提到的参数都可以在工具中看到。
> 工具地址：[https://dev-tools.steem.fans/](https://dev-tools.steem.fans/)

# 一、通胀与每个块理论产出STEEM量

steem 的通胀率是按照规律线性递减的，直到达到设置的值，通胀率就不会再减小了。

**通胀率如何计算？**

通胀率从 `STEEM_INFLATION_RATE_START_PERCENT（978）`开始，到 `STEEM_INFLATION_RATE_STOP_PERCENT（95）`结束。

即从 9.78% 到 0.95%。其中递减率是每 `STEEM_INFLATION_NARROWING_PERIOD（250000）`块减少 0.01%。

公式：

```
current_inflation_rate = max( STEEM_INFLATION_RATE_START_PERCENT - head_block_num / STEEM_INFLATION_NARROWING_PERIOD, STEEM_INFLATION_RATE_STOP_PERCENT )
```

通胀是针对现有供应量来算的，所以每年新增的STEEM数量按照当前所在的25万块这个区间的通胀率算的话是：

```
virtual_supply * current_inflation_rate
```

由于每3秒出一个块，所以理论上如果不丢块，每年出块数量为 `STEEM_BLOCKS_PER_YEAR`（即 60*60*24*365*3），

进而当前25万块区间内，每个块的理论产出为：`virtual_supply * current_inflation_rate / STEEM_BLOCKS_PER_YEAR`

按照当前写文章时间的高度（45429466）算出来的块理论产出STEEM数量为 `EachBlockRewardInTheory = 2.944 STEEM` 。



相关代码：[https://github.com/steemit/steem/blob/0.23.x/libraries/chain/database.cpp#L2396-L2403](https://github.com/steemit/steem/blob/0.23.x/libraries/chain/database.cpp#L2396-L2403)



# 二、每个块理论产生STEEM量如何分配

总的来说，每个块是按照 65% content reward, 15% vesting_reward, 10% SPS fund, 10% witness reward。

按照上边的例子，分别得到

```
content_reward = EachBlockRewardInTheory * 0.65 = 1.913 STEEM
vesting_reward = EachBlockRewardInTheory * 0.15 = 0.441 STEEM
sps_fund = EachBlockRewardInTheory * 0.1 = 0.294 STEEM
```

> 注意：
> 这里在 HF17 之后有这样的操作，new_content_reward = pay_reward_funds( content_reward )，
> 目前 pay_reward_funds 没看懂，我的工具暂时定义 new_content_reward = content_reward 。

另外，见证人收益不是直接乘以 10%，而是减出来的，即

```
witness_reward = EachBlockRewardInTheory - new_content_reward - vesting_reward - sps_fund
```

如此便得到最初的四项分配值。

之后还需要进行一些计算和分类，来最终把块产生的STEEM加入到各个池子中。

其中，需要先处理见证人的收益。

见证人分为TOP20（Elected）和非TOP20（TimeShare），两者的权重（weight）不同。

见证人的最终收益计算公式：

```
new_witness_reward = witness_reward * STEEM_MAX_WITNESSES * weight / witness_pay_normalization_factor
```

其中 `STEEM_MAX_WITNESSES` 为 21，`witness_pay_normalization_factor` 为 25.

TOP20的权重（elected_weight）为 1，非TOP20的权重（timeshare_weight）为 5.


除了见证人外，对于 `sps_fund_reward` 也需要单独计算，因为 SPS 最终是以 SBD 为单位，而块产生的是STEEM，所以需要进行转换。

转换率来自喂价，即 `current_median_history`。最终公式为：

```
sps_sbd = sps_fund_reward * current_median_history
```

这个时候，所有的计算工作基本结束，开始对数据进行写入操作，也就是进入各个池子，

```
total_vesting_fund_steem += vesting_reward
total_reward_fund_steem += new_content_reward
current_supply += new_content_reward + vesting_reward + new_witness_reward
current_sbd_supply +=  new_sbd
virtual_supply += new_content_reward + vesting_reward + new_witness_reward + sps_fund
sps_interval_ledger += sps_fund
```

最后一步，把 `new_witness_reward` 以 `vesting_shares` 的形式发放给见证人。 vesting_shares 就是 SP 的实质。


相关代码：[https://github.com/steemit/steem/blob/0.23.x/libraries/chain/database.cpp#L2404-L2453](https://github.com/steemit/steem/blob/0.23.x/libraries/chain/database.cpp#L2404-L2453)

最后是我画的产出STEEM流向图：


![steem-block-reward.jpg](/img/2021/steem-block-reward.jpg)

---
#### Some very cheap and good VPS
* [1Core/1G RAM/18G Disk/1Gbps, $23/year](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2Core/2G RAM/25G Disk/1Gbps, $33/year](https://my.racknerd.com/aff.php?aff=856&pid=208)
