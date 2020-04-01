---
author: ety001
layout: post
title: Steem Fullnode 部署大致步骤
tags:
  - 服务器
  - 经验
  - 配置
  - steem
  - steemit
---

# 前言

这篇讲述了如何部署 steemd 的 fullnode 版本。部署好以后，可以提供大部分 API 使用，但是无法直接用于 steemit 的 UI（即 [https://github.com/steemit/condenser](https://github.com/steemit/condenser)）。

> 注意：由于该方案使用 Docker 部署，所以请先自行安装 Docker。
> 注意：**该方案是部署 0.22.5 mira 版本**

# 下面是步骤：

## （一）克隆控制脚本

```
git clone https://github.com/Someguy123/steem-docker.git
```

## （二）进入目录

```
cd steem-docker/
```

## （三）如果你还没有装 Docker 可以执行下面的命令

```
./run.sh install_docker
```

## （四）下载 block_log

如果你不想从0开始同步，可以选择下载已有区块数据。
由于 @someguy123 目前提供的数据可能是 hive 的，最
好不要用 run.sh 脚本内的下载指令。目前我提供了一份
镜像下载。

```
# 进入存放目录
cd data/witness_node_data_dir/blockchain/
# 下载
wget -c http://da.mypi.win/block_log
```

> 建议：把下载放在 screen 中执行，下载结束后，返回 steem-docker/ 目录

## （五）修改配置文件

```
vim data/witness_node_data_dir/config.ini
```

### 需要着重修改的是
* (1) 把 p2p 节点注释掉，可以使用默认p2p节点，也可以参考这里 [https://steemit.com/cn/@ety001/steem-seed](https://steemit.com/cn/@ety001/steem-seed)
* (2) 注释掉 **shared-file-dir**，也就是不使用 **/dev/shm** ，这可以剩下不少内存
* (3) 打开下面的两个配置
  ```
  webserver-http-endpoint = 0.0.0.0:8090
  webserver-ws-endpoint = 0.0.0.0:8091
  ```

* (4) 增加plugin，其中没有 follow 插件，该插件可能有些问题，建议直接上 hivemind。
  ```
  plugin = webserver p2p json_rpc witness account_by_key reputation market_history
  plugin = database_api account_by_key_api network_broadcast_api reputation_api market_history_api condenser_api block_api rc_api
  ```
## （六）下载镜像
由于 @someguy123 没有提供打包好的 0.22.5 mira 版镜像，
所以你需要用 `dkr_fullnode` 目录下的 `Dockerfile` 自己编译。

或者直接使用我编译好的，该教程则以我的镜像为例。

* (1) 先拉取镜像
  ```
  docker pull ety001/steem-full-mira:0.22.5
  ```
* (2) 镜像重命名。`run.sh` 使用的镜像名须为 `steem`。
  ```
  docker tag ety001/steem-full-mira:0.22.5 steem
  ```

## （七）修改 run.sh
由于默认是只映射了 2001 端口出来，所以还需要修改 `run.sh`。
打开文件，找到头部 `PORTS` 设置，参照下面的方式修改

```
: ${PORTS="2001,8090,8091"}
```

> 上面的例子就是映射容器的 2001，8090，8091三个端口

## （八）开始replay

```
./run.sh replay
```

## （九） replay 结束后
replay结束后，可以选择不管，也可以 `./run.sh stop && ./run.sh start` 重新启动。

# 总结
以上就是大致的部署 0.22.5 mira 版的步骤。真正的全节点还需要部署 jussi 和 hivemind。

jussi 相当于是接口层，后面跟着 steemd 和 hivemind 提供数据。

目前还没有研究 hivemind 的搭建。

---
#### PS: [便宜的独立服务器推荐](https://billing.dacentec.com/hostbill/?affid=723)
