---
author: ety001
layout: post
title: '基于 alpine 构建 PHP 的 docker镜像时 iconv 扩展有缺陷'
tags:
- 教程
---

在部署 [LightDB](https://github.com/ety001/steem-lightdb) 第二阶段的代码的时候，需要基于 alpine 构建 PHP 镜像，结果发现 iconv 扩展有缺陷，具体表现见 [https://github.com/docker-library/php/issues/240](https://github.com/docker-library/php/issues/240) 。

通过该 issue 中提到的那个 hack 方法可以临时解决

```
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
```

但是并不是完美解决，虽然 iconv 函数可用了，但是扩展使用的库版本依旧是 unknown，并且在使用 [yetanotherape/diff-match-patch](https://github.com/yetanotherape/diff-match-patch) 的时候，依旧有报错无法使用。( [yetanotherape/diff-match-patch](https://github.com/yetanotherape/diff-match-patch) 在我之前的 [这篇文章]() 里有介绍 )

基本上导致 iconv 有问题的原因，可能是 alpine 使用的是 musl ，目前基于 musl 的 iconv 库可能本身就有些问题，具体问题不详。

最终不得不改用 ubuntu 18.04 来构建，可参考我的 [构建文件](https://github.com/ety001/dockerfile/tree/master/php7.2-ubuntu18.04)。使用 ubuntu 构建的最大问题就是最终的镜像包过大，目前我的这个封装，镜像包大约300多兆，之前基于 alpine 构建的话，大小在100M以内。