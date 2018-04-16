---
author: ety001
comments: true
date: 2014-06-01 01:48:50+00:00
layout: post
slug: foreach-point-in-php
title: PHP中foreach与引用的坑
wordpress_id: 2624
tags:
- 编程语言
---

```
<?php
$a = array(1,2,3);
foreach($a as $k => &$v){
    echo $v;
}
foreach($a as $k => $v){
    echo $v;
}
?>
```

这段程序的最终输出结果是123122.

原因解释：因为第一次foreach的时候使用了引用，所以，$v依次指向了$a[0],$a[1],$a[2]这几个空间，而foreach结束的时候，对于$v引用最后的一个值是不处理的，这个在php官方手册foreach部分有warning。因此这就导致了，第二次没有引用的循环的时候，$a[0]赋值给$v的时候，其实是赋值到了$v在上一次循环结束时引用的空间里的，也就是$a[2]指向的空间，第二遍循环的第一次结束后，数组$a的值就是1\2\1，第二次是1\2\2，第三次是1\2\2。

