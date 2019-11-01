---
author: ety001
layout: post
title: 用 docker compose 搭建 bitshares elastic search
tags:
- Server&OS
- Bitshares
- Docker
---

> 怕是这是第一篇中文说如何部署 `bitshares elastic search` 的文章吧。

# 前置知识
* docker
* elastic search

# 准备工作

## 安装 docker 和 docker-compose

```
# 这里只给出centos7的安装步骤
# 其他系统请参考docker的官方文档  [https://docs.docker.com/install/]

# 安装 docker
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine \
&& yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 \
&& yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo \
&& yum install -y docker-ce \
&& systemctl enable docker \
&& systemctl start docker

# 安装 docker-compose
yum install epel-release \
    && yum install -y python-pip \
    && pip install docker-compose \
    && yum upgrade python*
```

## 拉取dockerfile

```
git clone https://github.com/ety001/dockerfile.git

# 切换到相关目录
cd dockerfile/bts-es
```

> 这是我自己用来存储常用的 `dockerfile` 的库

## 编译 Bitshares 内核

```
# 编译 3.1.0，如果编译其他版本，自行更换版本号即可
docker-compose build --build-arg TAG=3.1.0
```

> 编译速度取决于你的网速和机器配置。
> * 如果在国内，可以打开该目录下的 `Dockerfile`，把其中的替换 `sources.list` 的步骤取消注释，这样更新系统软件的时候，可以使用国内163的源。
> * 另外 `Dockerfile` 文件中也可以调整编译参数利用多核性能提高编译速度。

## 修改系统配置

向 `/etc/sysctl.conf` 中增加 `vm.max_map_count = 262144`。 `elasticsearch`要求 `max_map_count` 最低 262144。添加后，重新载入 `sysctl --system`

# 启动
启动前，需要修改`docker-compose.yml`中的 `Xms` 和 `Xmx`环境变量，代表 `es` 的最小内存和最大内存占用。我的文件默认配置的是 `6G`。

```
docker-compose up -d
```
> 需要在 `docker-compose.yml` 文件所在目录执行该命令。


# 停止
```
docker-compose down
```
> 需要在 `docker-compose.yml` 文件所在目录执行该命令。

# 验证es是否启动成功
```
curl http://127.0.0.1:9200/_cat/health
```

# 验证是否有数据
```
curl -X GET 'http://localhost:9200/bitshares-*/data/_count?pretty=true' -H 'Content-Type: application/json' -d '
{
        "query" : {
                "bool" : { "must" : [{"match_all": {}}] }
        }
}'
```

# 已知问题
* 默认用户密码未修改

# 相关链接
* [https://dev.bitshares.works/en/master/supports_dev/elastic_search_plugin.html](https://dev.bitshares.works/en/master/supports_dev/elastic_search_plugin.html)

---

# UPDATE
* 修改密码的话，只需要在 `docker-compose.yml` 的 `elasticsearch` 中增加 `ELASTIC_PASSWORD=123456` 环境变量，这样启动后，密码就是 `123456`。
