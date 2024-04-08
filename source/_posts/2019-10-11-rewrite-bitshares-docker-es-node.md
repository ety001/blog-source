---
author: ety001
layout: post
title: 重写了我的bitshares-elasticsearch的docker-compose
tags:
- Server&OS
- Bitshares
- Docker
---

![OlGLOj5UsS2Ms4mf4wfRQMZWWQwmD2Uoeu6lIuaj.png](https://cdn.steemitimages.com/DQmSWLDEXYtzT8XP4Geq549MY2415EC9JRSsN7VwcMW4wxq/OlGLOj5UsS2Ms4mf4wfRQMZWWQwmD2Uoeu6lIuaj.png)

之前在[《用 docker compose 搭建 bitshares elastic search》](/2019/07/15/bitshares-es-node.html)中已经介绍了如何使用`docker-composer`搭建 `Bitshares Elastic Search 服务`。

最近有些时间，就对之前的部署进行了优化，并且升级了 `elastic search` 的版本和 `Bitshares` 的版本。

**仓库地址(Repository)** => [https://github.com/ety001/dockerfile/tree/master/bts-es](https://github.com/ety001/dockerfile/tree/master/bts-es)

**Manual in English** => [https://github.com/ety001/dockerfile/blob/master/bts-es/README.md](https://github.com/ety001/dockerfile/blob/master/bts-es/README.md)

## 如何部署

### 1. 克隆代码库

```
$ git clone https://github.com/ety001/dockerfile.git
$ cd dockerfile/bts-es
```

### 2. 修改 docker-composer.yaml 中的部分参数

* **ES_JAVA_OPTS=-Xms3g -Xmx3g** 这里可以调整 es 的内存占用
* **ELASTIC_PASSWORD** 这是你的es密码. 请同时修改 `--elasticsearch-basic-auth` 的值
* **#ports: - 9200:9200**, 如果你想直接让http服务可以被访问，可以取消这个地方的注释

### 3. 生成证书

```
$ docker run \
    -it --rm \
    -v $(pwd)/ssl:/usr/share/elasticsearch/config/certs \
    docker.elastic.co/elasticsearch/elasticsearch:7.4.0 \
    /bin/bash

-- 进入临时容器 --

# elasticsearch-certutil ca
ENTER ENTER （两次回车）

# elasticsearch-certutil cert --ca elastic-stack-ca.p12
ENTER ENTER ENTER （三次回车）

# mv *.p12 config/certs/
# chown 1000:1000 config/certs/*.p12

# exit
```

### 4. 增加 vm.max_map_count 配置

```
$ sudo sysctl -w vm.max_map_count=262144
```
如果想要永久修改这个配置值，在 `/etc/sysctl.conf` 中增加 `vm.max_map_count` 设置。
配置好需要重启，执行 `sysctl vm.max_map_count` 检查是否配置成功。

### 5. 启动

```
$ docker-compose up -d
```

## 其他常用命令

### 1. 检查运行日志

```
$ docker-compose logs -f --tail 100
```

### 2. 停止所有容器

```
$ docker-compose down
```

### 3. 检查es是否成功运行

```
$ curl -u elastic:123456 -X GET 'http://172.22.0.2:9200/_cat/health'
```
> `123456` 是你在 `docker-compose.yml` 中配置的密码.

### 4. 把 es01 加入到 nginx 的容器网络中

如果你同时使用 `docker` 来部署 `nginx`，你可以把 `es01` 容器加入到 `nginx` 容器
所在的网络里，这样可以方便 `nginx` 做反向代理到 `es` 的 `http` 服务并加上证书。

> 假设你的 nginx 容器所在网络名为 lnmp
```
docker network connect --ip 172.20.0.3 lnmp es01
```

## 任何问题？

如果有任何问题，欢迎提 issue。

My bitshares account: **ety001**
My witness account: **liuye**
