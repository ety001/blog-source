---
author: ety001
layout: post
title: Vesting Shares 与 Steem Power 的关系
tags:
  - steem
  - 经验
---

`SteemPower` 平时都被叫做 SP，这个单位虽然我们经常见，但是这个并不是真正的资产。

SP 的背后其实是 `VestingShares`。鉴于 `Steem` 的通胀，SP其实是用来表示当前你持有的 `VestingShares` 价值多少 Steem 的单位。

`VestingShares` 我们把他看做一个商品会更容易理解。

用 `Steem` 币购买 `VestingShares` 的过程就是 `PowerUP`，相对的，卖出 `VestingShares` 得到 `Steem` 币的操作就是 `PowerDown`。

而购买价格就是 `total_vesting_shares` 和 `total_vesting_fund_steem` 的比值，

这个在这里可以看到：[https://github.com/steemit/steem/blob/0.23.x/libraries/chain/include/steem/chain/global_property_object.hpp#L67-L73](https://github.com/steemit/steem/blob/0.23.x/libraries/chain/include/steem/chain/global_property_object.hpp#L67-L73)


之所以价格这样计算，是因为系统要求，当用户 `PowerUp` 的时候，要求 `total_vesting_shares / total_vesting_fund_steem` 比值不变。

即 `total_vesting_shares / total_vesting_fund_steem = (total_vesting_shares + delta_vesting_shares) / (total_vesting_fund_steem + delta_vesting_fund_steem)`

其中 `delta_vesting_fund_steem` 就是我们要 `PowerUp` 的 `Steem`，我们需要知道能获取多少 `vesting_shares`，即 `delta_vesting_shares`。

整理一下就是 `delta_vesting_shares = (total_vesting_shares / total_vesting_fund_steem) * delta_vesting_fund_steem`

由此得到价格关系。

相关代码：[https://github.com/steemit/steem/blob/0.23.x/libraries/chain/database.cpp#L1199-L1314](https://github.com/steemit/steem/blob/0.23.x/libraries/chain/database.cpp#L1199-L1314)

`total_vesting_fund_steem` 这个池子除了上面提到的 `PowerUp` 操作会增加这个池子，还有就是每次出块会增加。

每次出块，每个块总产出 `Steem` 的 15% 会进入到 `total_vesting_fund_steem`。

而 `total_vesting_shares` 的增加来源于见证人收益，因为每个块的见证人收益（即不到10%的块总产出）是以 `VestingShares` 发放，而不是以 `Steem` 发放。

发放见证人收益的时候，会同时增加 `total_vesting_fund_steem` 和 `total_vestting_shares`。

综上两点，就意味着 `total_vesting_fund_steem` 增长速度会快于 `total_vesting_shares`，也就是说 `vesting_shares` 会越来越值钱。

而 SP 的意义目前也就是实时展示你持有的 `VestingShares` 现在值多少 `Steem`。你如果不在这个时刻 `PowerDown`，那么这个 SP 就是没有意义的，只是一个数字。

如果说 SP 只是为了实时表示 `VestingShares` 的 `Steem` 价值，那么 SP 这个概念可能是个很失败的引入。

---

#### Some very cheap and good VPS
* [1Core/1G RAM/18G Disk/1Gbps, $23/year](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2Core/2G RAM/25G Disk/1Gbps, $33/year](https://my.racknerd.com/aff.php?aff=856&pid=208)
