---
author: ety001
layout: post
title: 原来Steem的operation有这么多
tags:
- Server&OS
- Steem
---
之前在开发 **Steem LightDB** 的时候，曾经总结过 **Steem** 的 **Operation** ，当时只是基于从数据块中总结出来了一些常见的类型。

最近在用 **PHP** 去实现一些公私钥生成，签名操作这样的功能，在比对着 **steem-js** 库在一点点用 **PHP** 仿写，过程真的是蛋碎一地，几度要放弃。

目前公私钥可以用 **PHP** 去生成了，目前正在实现如何组装 **Transaction** 并签名发送。

组装部分已经实现，目前就是签名这里实现很复杂，需要先对 **Transaction** 的原始数据 —— JSON 对象，进行转换，转换为二进制的形式，然后才是签名。

在看 **steem-js** 如何把 **Transaction** 转二进制的时候，发现了这么一段代码，里面应该就是目前 **Steem** 的所有操作方法吧，记录一下，说不定以后有用：

```
operation.st_operations = [
vote,
comment,
transfer,
transfer_to_vesting,
withdraw_vesting,
limit_order_create,
limit_order_cancel,
feed_publish,
convert,
account_create,
account_update,
witness_update,
account_witness_vote,
account_witness_proxy,
pow,
custom,
report_over_production,
delete_comment,
custom_json,
comment_options,
set_withdraw_vesting_route,
limit_order_create2,
claim_account,
create_claimed_account,
request_account_recovery,
recover_account,
change_recovery_account,
escrow_transfer,
escrow_dispute,
escrow_release,
pow2,
escrow_approve,
transfer_to_savings,
transfer_from_savings,
cancel_transfer_from_savings,
custom_binary,
decline_voting_rights,
reset_account,
set_reset_account,
claim_reward_balance,
delegate_vesting_shares,
account_create_with_delegation,
fill_convert_request,
author_reward,
curation_reward,
comment_reward,
liquidity_reward,
interest,
fill_vesting_withdraw,
fill_order,
shutdown_witness,
fill_transfer_from_savings,
hardfork,
comment_payout_update,
return_vesting_delegation,
comment_benefactor_reward
];
```
