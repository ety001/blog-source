---
author: ety001
layout: post
title: 用php如何获取当前Steem用户的Voting Power
tags:
- steem
---

再来一篇，这篇代码是获取指定用户当前的 `Voting Power`，不废话直接上代码。

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

    function getAccountVotingPower($username) {
        $data = postData('{"jsonrpc":"2.0", "method":"condenser_api.get_accounts", "params":[["'.trim($username).'"]], "id":1}');
        $user = $data[0];
        $last_vote_time = $user['last_vote_time'];
        var_dump(strtotime($last_vote_time));
        $voting_power = $user['voting_power'];
        var_dump($voting_power);
        $vpow = $voting_power + (10000 * (time() - strtotime($last_vote_time)) / 432000);
        return number_format(min($vpow, 10000) / 100, 2);
    }
    var_dump(getAccountVotingPower('ety001'));
```

完工！