---
author: ety001
layout: post
title: PHP如何计算当前账号Upvote的价值
tags:
- steem
---

由于最近开发需要计算指定账号的赞的价值，因此研究了下。

* 参考了官方的开发文档，地址：[https://developers.steem.io/tutorials-recipes/estimate_upvote](https://developers.steem.io/tutorials-recipes/estimate_upvote)
* 参考了这个工具网站，地址：[https://steemnow.com/upvotecalc.html](https://steemnow.com/upvotecalc.html)

代码如下：

```
<?php
    function postData($data) {
        $url = 'https://api.steemit.com';
        $options = array(
          'http' =>
            array(
              'header' => "Content-Type: application/json\r\n".
                          "Content-Length: ".strlen($data)."\r\n".
                          "User-Agent:SteemTools/1.0\r\n",
              'method'  => 'POST',
              'content' => $data,
            )
        );
        $context  = stream_context_create($options);
        try {
            $result = file_get_contents($url, false, $context);
            $r = json_decode($result, true);
            $result = $r['result'];
        } catch (\Exception $e) {
            return false;
        }
        return $result;
    }

    function getRewardFund() {
        $result = postData('{"id":0,"jsonrpc":"2.0","method":"call","params":["database_api","get_reward_fund",["post"]]}');
        if (isset($result['reward_balance'])) {
            $result['reward_balance'] = str_replace(' STEEM', '', $result['reward_balance']);
        }
        return $result;
    }

    function getAccountVests($username) {
        $result = postData('{"jsonrpc":"2.0", "method":"condenser_api.get_accounts", "params":[["'.trim($username).'"]], "id":1}');
        return str_replace(' VESTS', '', $result[0]['vesting_shares']) + str_replace(' VESTS', '', $result[0]['received_vesting_shares']) - str_replace(' VESTS', '', $result[0]['delegated_vesting_shares']);
    }

    function getCurrentMedianHistoryPrice() {
        $result = postData('{"id":1,"jsonrpc":"2.0","method":"call","params":["database_api","get_current_median_history_price",[]]}');
        return str_replace(' SBD', '', $result['base']) / str_replace(' STEEM', '', $result['quote']);
    }

    function getAccountUpvoteValue($username, $vp, $weight) {
        $power = (100*$vp * 100*$weight / 1e4 + 49) / 50;
        $total_vests = getAccountVests($username);
        $final_vests = $total_vests * 1e6;
        $rshares = $power * $final_vests / 1e4;
        $rewards = getRewardFund();
        $sbd_median_price = getCurrentMedianHistoryPrice();
        $estimate = $rshares / $rewards['recent_claims'] * $rewards['reward_balance'] * $sbd_median_price;
        return $estimate;
    }

    // var_dump(getRewardFund());
    // var_dump(getAccountVests('ety001'));
    // var_dump(getCurrentMedianHistoryPrice());
    var_dump(getAccountUpvoteValue('ety001', 100, 100));
```

官网的公式已经很明确了，其中遇到的问题就是 `voting power` 和 `weight` 的精度问题了。由于在官网公式上并没有指明，所以很容易被忽略。

在我的代码中，很清楚的看到我传入的 `voting power` 是 `90`，`weight` 是 `100`，由于 Steem 在百分比上的精度是下面这样子的：

```
100.00%
```

而存储在区块上的是整数 `10000`。因此官方给出的代码中，`power = (voting_power * weight / 10000) / 50` 要看你传入是什么精度的数据了。按照我的传参，我必须要给传入的值再乘以100才是正确结果，也就是我的代码是 `$power = (100*$vp * 100*$weight / 1e4 + 49) / 50;`。其中的 `+49` 是挺高精度的一种方式，可以去掉。

完工！