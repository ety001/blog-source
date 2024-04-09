---
author: ety001
date: 2023-03-27 13:25:31
layout: post
title: Demo code about how to create a new account by Steem JS SDK
tags:
- steem
- steemit
- 配置
- 经验
---

Here is the demo code which displays how to create a new account with Steem JS SDK in two different ways ( by taking fee or by taking interests of claimed account).

```
const steem = require('steem')

const creator = 'test1';
const activeWif = '';
const newUsername = 'test2';
const newPasswd = 'P5KZS6bp8sVxxxxxxxxxD48jwBKxshpNZxsYnJ';
const fee = '3.000 STEEM'

const newKeys = steem.auth.getPrivateKeys(newUsername, newPasswd, ['owner', 'active', 'posting', 'memo']);
console.log(newKeys);

const weightThreshold = 1;
const accountAuths = [];
const owner = {
    weight_threshold: weightThreshold,
    account_auths: accountAuths,
    key_auths: [[newKeys.ownerPubkey, 1]],
};
const active = {
    weight_threshold: weightThreshold,
    account_auths: accountAuths,
    key_auths: [[newKeys.activePubkey, 1]],
};
const posting = {
    weight_threshold: weightThreshold,
    account_auths: accountAuths,
    key_auths: [[newKeys.postingPubkey, 1]],
};
const memoKey = newKeys.memoPubkey;

// create a new user by creator with 3.000 STEEM fee
steem.broadcast.accountCreate(activeWif, fee, creator, newUsername, owner, active, posting, memoKey, '{}', function(err, result) {
    console.log(err, result);
});

// create a new user by creator with claimed account interests
const op = [
    "create_claimed_account",
    {
        "creator": creator,
        "new_account_name": newUsername,
        "owner": owner,
        "active": active,
        "posting": posting,
        "memo_key": memoKey,
        "json_metadata": "{}"
    }
];
const tx = {
    operations: [op],
};
steem.broadcast.send(tx, [activeWif], function(err, result) {
    console.log(err, result);
});
```
