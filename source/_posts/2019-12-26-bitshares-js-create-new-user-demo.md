---
author: ety001
layout: post
title: 使用 bitsharesjs 库创建新用户Demo
tags:
- Bitshares
---

整理了一下用 `js-sdk` 创建新用户的最简单的 `Demo` 实现代码。

# 代码

```
  import {PrivateKey, key, FetchChain, TransactionBuilder} from 'bitsharesjs';
  import {Apis, ChainConfig} from 'bitsharesjs-ws';

  generateKeyFromPassword(accountName, role, password) {
    const seed = accountName + role + password;
    const privKey = PrivateKey.fromSeed(seed);
    const pubKey = privKey.toPublicKey().toString();
    return {privKey, pubKey};
  }

  registerUser(username, password, registrar, referrer) {
    const privKey = '这里是用来签名数据的用户active私钥';
    const pKey = PrivateKey.fromWif(this.privKey);
    const referrerPercent = 0;
    const {pubKey: ownerPubkey} = generateKeyFromPassword(
      username,
      'owner',
      password
    );
    const {pubKey: activePubkey} = generateKeyFromPassword(
      username,
      'active',
      password
    );
    const {pubKey: memoPubkey} = generateKeyFromPassword(
      username,
      'memo',
      password
    );

    try {
      return Promise.all([
        FetchChain("getAccount", registrar),
        FetchChain("getAccount", referrer)
      ]).then((res) => {
        const [chainRegistrar, chainReferrer] = res;
        const tr = new TransactionBuilder();
        tr.add_type_operation("account_create", {
          fee: {
            amount: 0,
            asset_id: 0
          },
          registrar: chainRegistrar.get("id"),
          referrer: chainReferrer.get("id"),
          referrer_percent: referrerPercent,
          name: username,
          owner: {
              weight_threshold: 1,
              account_auths: [],
              key_auths: [[ownerPubkey, 1]],
              address_auths: []
          },
          active: {
              weight_threshold: 1,
              account_auths: [],
              key_auths: [[activePubkey, 1]],
              address_auths: []
          },
          memo: {
              weight_threshold: 1,
              account_auths: [],
              key_auths: [[memoPubkey, 1]],
              address_auths: []
          },
          options: {
              memo_key: memoPubkey,
              voting_account: "1.2.1",
              num_witness: 0,
              num_committee: 0,
              votes: []
          }
        });
        return tr.set_required_fees().then(() => {
          tr.add_signer(pKey);
          console.log("serialized transaction:", tr.serialize());
          tr.broadcast();
          return true;
        });
      }).catch((err) => {
        console.log('err:', err);
      });
    } catch(e) {
      console.log('unexpected_error:', e);
    }
  }

  registerUser('新用户名', '新用户的密码', '用来签名的用户的用户名', '推荐用户的用户名')；
```

# 说明
> * `registerUser` 函数参数中的 `registrar` 是用来签发数据的用户的用户名，函数里面的 `privKey` 是 `registrar` 的 `active` 私钥
> * `referrerPercent` 是分成比例，这里注意是基于手续费的 50% 再分成。也就是 `referrerPercent` 设置为 `10000` ，则代表 `registrar` 分成 0%，`referrer` 分成 50%。
> * 提交的数据中的 `voting_account` 是设置投票代理人是谁，**`memo_key` 是什么意思暂时还不知道**。

---
##### ET碎碎念，每周一，晚六点一刻更新，欢迎订阅
##### 也可以订阅号留言
![](/img/wechat-subscribe.jpg)
