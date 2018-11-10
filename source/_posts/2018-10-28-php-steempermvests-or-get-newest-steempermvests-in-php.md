---
author: ety001
layout: post
title: 在PHP中获取最新的 steem_per_mvests
tags:
- steem
---

```
<?php
function steem_per_mvests() {
    $url = 'https://api.steemit.com';

    $data = '{"jsonrpc":"2.0", "method":"database_api.get_dynamic_global_properties", "id":1}';
    $options = array(
      'http' =>
        array(
          'header' => "Content-Type: application/json\r\n".
                      "Content-Length: ".strlen($data)."\r\n".
                      "User-Agent:SteemMention/1.0\r\n",
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
    return $result['total_vesting_fund_steem']['amount'] / ($result['total_vesting_shares']['amount'] / 1e6);
}

function vests_to_sp($vests) {
    $steem_per_mvests = steem_per_mvests();
    if ($steem_per_mvests) {
        return $vests / 1e6 * $steem_per_mvests;
    } else {
        return false;
    }
}
```