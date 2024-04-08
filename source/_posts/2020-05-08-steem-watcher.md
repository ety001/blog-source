---
author: ety001
layout: post
title: 开发了一个Steem链上监测程序
tags:
  - 服务器
  - 配置
  - Server&OS
  - steem
  - steemit
---

# Steem Watcher

**项目地址**: [https://github.com/ety001/steem-watcher](https://github.com/ety001/steem-watcher)

该项目基于之前[项目的程序](https://github.com/ety001/steem-tools/tree/master/watcher)修改而来，目的是为了可以定制化监控链上数据.
目前只监控 `claim_account`, `create_claimed_account`, `account_create` 三种数据.

> 如果你想监测更多类型数据，请自行修改 `bin/lib/opType.py`

# 部署

由于使用了 `docker` 技术，整个部署过程非常简单。

## 克隆代码

```
git clone https://github.com/ety001/steem-watcher.git
```

## 修改配置参数

```
cd steem-watcher
cp .env.example .env
```

参数说明：

```
STEEMD=https://api.steemit.com  # 节点地址
MYSQL_HOST=172.22.2.2           # 数据库地址，如果 docker-compose.yml 未改动，这里请保持不变
MYSQL_USER=root                 # 数据库用户名，如果 docker-compose.yml 未改动，这里请保持不变
MYSQL_PASS=123456               # 数据库密码，如果 docker-compose.yml 未改动，这里请保持不变
BLOCK_NUM=43191800              # 从指定高度开始收集数据
SLACK_URL=                      # Slack 的 Webhook 地址
```

## 启动

```
./start.sh
```

## 查看 Log

```
./logs.sh
```

## 停止

```
./stop.sh
```

# 其他说明

* `crontab` 配置文件在 `config/crontab`，需要用 `root` 权限修改
* `crontab` 日志在 `./logs` 目录下
* 如需删除数据库重新开始，请先停止，然后 `sudo rm -rf db/*`

# 如有疑问

提 Issue 或者 发邮件给我: work@akawa.ink


---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
