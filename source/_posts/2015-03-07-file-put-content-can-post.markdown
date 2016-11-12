---
author: ety001
layout: post
title: file_put_content也可以post提交数据
tags:
- 编程语言
---

这算是file_put_content的高级用法了吧~

```
$params     = array(
    'access_token'      => $access_token
);
$options            = array(
    'http' => array(
        'method'  => 'POST',
        'content' => http_build_query($params)
    )
);
$context    = stream_context_create($options);
$r          = file_get_contents($url, false, $context);
```
