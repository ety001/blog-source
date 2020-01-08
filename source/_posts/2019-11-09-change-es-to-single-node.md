---
author: ety001
layout: post
title: 把 elasticsearch 又换回了单节点
tags:
- Bitshares
- Server&OS
---

之前不知道怎么想的，在一台物理机上通过 docker 来搭建两个 Node 的 Elasticsearch 集群。

由于 ES 默认分片要有一个备份，所以导致我的硬盘用量很大，关键是在同一台物理机上搞两个 Node 没有什么意义。

所以今天我又换回了单 Node 模式。

新的 Dockerfile 我放在了我的库里，[https://github.com/ety001/dockerfile/tree/master/bts-es](https://github.com/ety001/dockerfile/tree/master/bts-es) ，
那个 `docker-compose.yml.single` 就是了。

切换回单节点后，集群的健康状态里就会显示各个索引都是 yellow。原因就是刚才说的，ES 默认会
保持一个备份分片，而单节点后，没法分发备份分片到其他节点，所以就会报不健康。

我们可以通过执行下面的命令，来让分片默认0备份

```
$ curl -u elastic:123456 -XPUT "http://127.0.0.1:9200/_template/default_template" -H 'Content-Type: application/json' -d'
{
  "index_patterns": ["*"],
  "settings": {
    "number_of_replicas": 0
  }
}
'
```

通过设置默认模板，再创建的新的分片就不再需要有备份了。

PS：我搭建的国内 Bitshares ES 节点也上线了，目前还在数据同步中
```
https://es.61bts.com
用户名: bts
密码: btsbts
```
