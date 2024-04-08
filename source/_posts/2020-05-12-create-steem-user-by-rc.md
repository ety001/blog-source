---
author: ety001
layout: post
title: 通过RC注册新账号的总结
tags:
  - steem
  - 经验
---

在steem链上注册有三种途径，`account_create`,`create_claimed_account`和`account_create_with_delegation`，不过，最后这个 `account_create_with_delegation` 已经不再建议使用了。所以目前主要是通过 `account_create` 和 `create_claimed_account` 两个方法来注册新用户。

# 调用方法

## account_create

这个接口使用很简单，只需要交钱就能注册，即花费 steem 代币。

使用方法: [https://developers.steem.io/apidefinitions/#broadcast_ops_account_create](https://developers.steem.io/apidefinitions/#broadcast_ops_account_create)

## create_claimed_account

这个接口注册用户需要配合 `claim_account` 来进行。需要使用 `claim_account` 先花费 RC 申请一个牌子，然后再消耗牌子去使用 `create_claimed_account` 注册用户。

`claim_account` 使用方法: [https://developers.steem.io/apidefinitions/#broadcast_ops_claim_account](https://developers.steem.io/apidefinitions/#broadcast_ops_claim_account)

`create_claimed_account` 使用方法: [https://developers.steem.io/apidefinitions/#broadcast_ops_create_claimed_account](https://developers.steem.io/apidefinitions/#broadcast_ops_create_claimed_account)

这里给出一下 `claim_account` 的 `demo`:

```
const steem = require('steem');
steem.api.setOptions({ url: 'https://steem.61bts.com' });

const ac_key = "";
const user = "";

const keys = {active: ac_key};

const op = [
  "claim_account",
  {
    "fee": "0.000 STEEM",
    "creator": user,
    "extensions": []
  }
];

const tx = {
    extensions: [],
    operations: [
        op
    ]
};

steem.broadcast.send(tx, keys, (r) => {
    console.log(r);
});
```

# 关于花费

无论那个接口注册用户，都要涉及到注册费用，只不过 `account_create` 是直接花费注册费用，而 `create_claimed_account` 途径注册用户，需要计算消耗多少 RC。

## account_create

目前使用 `account_create` 注册用户会消耗当前用户 3 steem 代币。那么这个数是从哪里获得的呢？

我们看下面的代码：

```
   FC_ASSERT( o.fee == wso.median_props.account_creation_fee, "Must pay the exact account creation fee. paid: ${p} fee: ${f}",
                  ("p", o.fee)
                  ("f", wso.median_props.account_creation_fee) );
```
> 上面的代码来自 `/libararies/chain/steem_evaluator.cpp` 中的 `void account_create_evaluator::do_apply( const account_create_operation& o )`。
> 代码位置: [https://github.com/steemit/steem/blob/master/libraries/chain/steem_evaluator.cpp#L331](https://github.com/steemit/steem/blob/master/libraries/chain/steem_evaluator.cpp#L331)

可以看到在注册费这里需要断言，注册费用为 `wso.median_props.account_creation_fee`。

这个 `wso` 联系上下文看到是 `_db.get_witness_schedule_object()`，可以知道是拿的见证人的信息。其中里面涉及到一个 `median_props` 的成员，需要看看如何实现（看字面意思是中位数）。

```
   /// sort them by account_creation_fee
   std::sort( active.begin(), active.end(), [&]( const witness_object* a, const witness_object* b )
   {
      return a->props.account_creation_fee.amount < b->props.account_creation_fee.amount;
   } );
   asset median_account_creation_fee = active[active.size()/2]->props.account_creation_fee;
```
> 上面的代码来自 `/libararies/chain/witness_schedule.cpp` 中的 `void update_median_witness_props( database& db )` 。
> 位置在: [https://github.com/steemit/steem/blob/master/libraries/chain/witness_schedule.cpp#L37](https://github.com/steemit/steem/blob/master/libraries/chain/witness_schedule.cpp#L37)

其中 `active` 联系上下文，可以知道拿到的是当前活跃的所有见证人（目前的配置是21位），然后对这些活跃的见证人配置中的 `account_creation_fee` 进行排序，然后取中位数。

**结论：如果想要变动注册费用，需要半数以上的活跃见证人同时调整自己的 `account_creation_fee` 配置。**

## create_claimed_account

关于 `create_claimed_account` 和 `claim_account` 这两个函数，目前还没有完全看完，因为其中还涉及到了 RC 部分的代码。

**目前还不清楚要扣除的RC的计算公式或者说方法。当前只是了解到在使用 `claim_account` 的时候的几个限制条件。**

```
   if( o.fee.amount == 0 )
   {
      const auto& gpo = _db.get_dynamic_global_properties();

      // This block is a little weird. We want to enforce that only elected witnesses can include the transaction, but
      // we do not want to prevent the transaction from propogating on the p2p network. Because we do not know what type of
      // witness will have produced the including block when the tx is broadcast, we need to disregard this assertion when the tx
      // is propogating, but require it when applying the block.
      if( !_db.is_pending_tx() )
      {
         const auto& current_witness = _db.get_witness( gpo.current_witness );
         FC_ASSERT( current_witness.schedule == witness_object::elected, "Subsidized accounts can only be claimed by elected witnesses. current_witness:${w} witness_type:${t}",
            ("w",current_witness.owner)("t",current_witness.schedule) );

         FC_ASSERT( current_witness.available_witness_account_subsidies >= STEEM_ACCOUNT_SUBSIDY_PRECISION, "Witness ${w} does not have enough subsidized accounts to claim",
            ("w", current_witness.owner) );

         _db.modify( current_witness, [&]( witness_object& w )
         {
            w.available_witness_account_subsidies -= STEEM_ACCOUNT_SUBSIDY_PRECISION;
         });
      }

      FC_ASSERT( gpo.available_account_subsidies >= STEEM_ACCOUNT_SUBSIDY_PRECISION, "There are not enough subsidized accounts to claim" );

      _db.modify( gpo, [&]( dynamic_global_property_object& gpo )
      {
         gpo.available_account_subsidies -= STEEM_ACCOUNT_SUBSIDY_PRECISION;
      });
   }
```
> 上面的代码来自 `/libararies/chain/steem_evaluator.cpp` 中的 `void claim_account_evaluator::do_apply( const claim_account_operation& o )` 。
> 位置在: [https://github.com/steemit/steem/blob/master/libraries/chain/steem_evaluator.cpp#L3211](https://github.com/steemit/steem/blob/master/libraries/chain/steem_evaluator.cpp#L3211)

在代码中，我们能看到有两个数量上的限制：
* `current_witness.available_witness_account_subsidies`
* `gpo.available_account_subsidies`

其中还涉及到一个全局参数 `STEEM_ACCOUNT_SUBSIDY_PRECISION`。

上面这三个值，我们通过下面的代码可以快速的获取到：

```
steem.api.getActiveWitnesses(function(err, result) {
    result.forEach((w)=>{
        steem.api.getWitnessByAccount(w, (e, r) => {
            console.log(w, r.available_witness_account_subsidies);
        })
    })
});
steem.api.getDynamicGlobalProperties(function(err, result) {
  console.log('available_account_subsidies: ', result['available_account_subsidies']);
});
steem.api.getConfig(function(err, result) {
  console.log('STEEM_ACCOUNT_SUBSIDY_PRECISION:', result['STEEM_ACCOUNT_SUBSIDY_PRECISION']);
});
```

> 我们用 @justyy 提供的[网页工具](https://steemyy.com/steemjs/) 可以快速的看到结果。

**目前的结论就是，使用 RC 注册用户，不仅受到你自身 RC 数量影响，还会受到当前出块见证人的余量(available_witness_account_subsidies)，以及全局的余量(available_account_subsidies) 两个值的限制。具体这两个值怎么恢复，以及申领一个牌子消耗多少RC的计算，等我读完 RC Plugin 的代码应该就可以搞明白了。**

# 注册费最终流向

目前这里没有细看，但是可以看到费用是流向了 @null 账号。在最终的写入区块的操作的时候，也有对 @null 账号的单独处理，
截取一段代码如下：

```
         case STEEM_ASSET_NUM_STEEM:
         {
            asset new_vesting( (adjust_vesting && delta.amount > 0) ? delta.amount * 9 : 0, STEEM_SYMBOL );
            props.current_supply += delta + new_vesting;
            props.virtual_supply += delta + new_vesting;
            props.total_vesting_fund_steem += new_vesting;
            if( check_supply )
            {
               FC_ASSERT( props.current_supply.amount.value >= 0 );
            }
            break;
         }
```
> 上面的代码来自 `/libararies/chain/database.cpp` 中的 `void database::adjust_supply( const asset& delta, bool adjust_vesting )` 。
> 位置在: [https://github.com/steemit/steem/blob/master/libraries/chain/database.cpp#L4689](https://github.com/steemit/steem/blob/master/libraries/chain/database.cpp#L4689)

其中 `delta` 就是要扣除的手续费，`props` 是 `dynamic_global_property_object`。可以看到是对整个系统的供应做了修改，但是具体如何修改，由于这里涉及的条件很多，还没有理顺清楚。

# 还未解决

最后列出一下还没有搞清楚的事情：

* 申请牌子的 RC 计算公式
* 除了上面提到的 `available_witness_account_subsidies` 和 `available_account_subsidies` 这两个限制条件外，对于使用 RC 申请牌子是否还有其他的限制条件。
* `available_witness_account_subsidies` 和 `available_account_subsidies` 这两个值如何恢复。
* 注册费用最终是如何影响全局供给的。

---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
