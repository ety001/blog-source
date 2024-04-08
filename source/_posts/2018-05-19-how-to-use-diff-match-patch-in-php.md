---
author: ety001
layout: post
title: '如何用PHP完成Steem中的patch'
tags:
- 教程
---

在 [LightDB](https://github.com/ety001/steem-lightdb) 开发过程中，如何把已修改的文章更新到原有文章上，是个很重要的功能。

Steem 对于大篇幅的文章修改，使用的是 patch 的方式，把增量信息存入到区块链上，这样可以很大程度上减少空间开销，但是原始数据对人类不友好。因此在最终给人阅读前，需要由程序把所有变动的 patch 都依次打上才行。

经过调研，发现 Steem 使用的是 Google 的 [DiffMatchPatch](https://github.com/google/diff-match-patch) 这个库，但是遗憾的是，没有针对 PHP 的封装。不过最终我也还是找到一个 PHP 的库，[https://github.com/yetanotherape/diff-match-patch](https://github.com/yetanotherape/diff-match-patch) 。

这个库的使用非常的简单，直接上示例

```
<?php
require __DIR__ . '/vendor/autoload.php';
use DiffMatchPatch\DiffMatchPatch;
$dmp = new DiffMatchPatch();

$old = "[SteemLightDB](https://github.com/ety001/steem-lightdb) (以下简称 LightDB ) 是一个基于 Steem 链的 MySQL 数据服务。

在有 SBDS 的情况下，为啥还要在弄一个 SteemLightDB 呢？

由于之前搭建过 SBDS 服务，发现里面有很多的问题，其中稳定性、数据原始性、数据容量这三个问题比较突出。

* SBDS 的稳定性直接依赖于其取数据的节点的稳定性；
* SBDS 的数据太原始，加工度不够，如果应用开发者需要一些数据之间的关系，需要开发者获取后自己加工，增加了开发者的开发工作量和难度；
* SBDS 占用空间太大，对于穷人来说，服务器费用开销太大。";


$patches = "@@ -32,11 +32,8 @@
 om/e
-ty0
 01/s
@@ -90,17 +90,16 @@
  %E6%95%B0%E6%8D%AE%E6%9C%8D%E5%8A%A1%E3%80%82%0A%0A
-%E5%9C%A8
 %E6%9C%89 SBDS %E7%9A%84
";



$new_content = "[SteemLightDB](https://github.com/e01/steem-lightdb) (以下简称 LightDB ) 是一个基于 Steem 链的 MySQL 数据服务。

有 SBDS 的情况下，为啥还要在弄一个 SteemLightDB 呢？

由于之前搭建过 SBDS 服务，发现里面有很多的问题，其中稳定性、数据原始性、数据容量这三个问题比较突出。

* SBDS 的稳定性直接依赖于其取数据的节点的稳定性；
* SBDS 的数据太原始，加工度不够，如果应用开发者需要一些数据之间的关系，需要开发者获取后自己加工，增加了开发者的开发工作量和难度；
* SBDS 占用空间太大，对于穷人来说，服务器费用开销太大。";



$patches = $dmp->patch_fromText($patches);
$res = $dmp->patch_apply($patches, $old);
var_dump($res);
var_dump($new_content);
```

这里需要注意一点，就是 patch 中数据的格式。之前一直卡在这里调不出来的原因就是 [steemd.com](https://steemd.com/) 中提供的 patch 数据格式有问题。就像我上面给出的示例代码中的 patch ，其中有些行前面是有空格的，而在 [steemd.com](https://steemd.com/) 提供数据中，这些空格是消失了的。。。

![](https://steemeditor.com/storage/images/yvNCoVX0AvlY0tozipdljcqLA3fJslbYnRAhfpFL.png)

除此之外，还有一个坑，就是 Steem 会针对文章长短来采取是否使用 patch。。。也就是说如果你的文章就一句话，如果你编辑修好提交了，那么就不会用 patch，而是直接把你新修改的内容直接提交保存。。。具体多长我也不清楚，我没有看源码，但是有一点可以肯定就是这个操作让人很蛋疼。目前我的解决方案是使用 try catch 来区分是否使用了 patch。

```
try {
	$patches = $dmp->patch_fromText($patches);
	$res = $dmp->patch_apply($patches, $old);
} catch(\Exception $e) {
	$res = $patches;
}
```

虽然目前看貌似没有什么问题，但是感觉实现的很不优雅。

OVER!