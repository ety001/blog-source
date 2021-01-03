---
author: ety001
layout: post
title: lz4压缩是真的香
tags:
  - 服务器
  - steem
  - 经验
---

最近在看官方库的[Dockerfile相关的脚本](https://github.com/steemit/steem/tree/master/contrib)，学习到了一些有价值的点。

比如在区块数据备份这块，我发现官方使用的 `lz4` 压缩工具。

去查了下，发现 `lz4` 是目前综合来看效率最高的压缩算法，更加侧重压缩解压速度，压缩比并不是第一。在当前的安卓和苹果操作系统中，内存压缩技术就使用的是 `lz4` 算法，及时压缩手机内存以带来更多的内存空间。本质上是时间换空间。

压缩效率高，对于像 `steem` 这样的庞大的数据怪物的备份来说，太重要了。

使用起来也很方便，系统应该都是默认安装了 `lz4` 的。

在目的目录执行下面的命令：

```
tar  -cf  steem_blockchain.tar.lz4  --use-compress-program=lz4   -C  /data2/steem/data/witness_node_data_dir   blockchain/
```

就可以把 `/data2/steem/data/witness_node_data_dir` 下面的 `blockchain` 文件夹打包并使用 `lz4` 压缩。

经过测试，源目录 `blockchain` 的大小是 `374G`，压缩后的文件是 `261G`，压缩比还可以。

最重要的是时间。往常在我的服务器上使用 `gzip` 和 `tar` 打包备份，一般就是大半天的时间。而这次使用 `lz4` 压缩才用了大约两个小时，太惊艳了！

接下来，要把目前所有的备份都换成使用 `lz4` 进行压缩打包。

---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
