---
author: ety001
layout: post
title: Steem Hivemind 搭建
tags:
  - 服务器
  - 经验
  - 配置
  - steem
  - steemit
---
# 前言

[hivemind](https://github.com/steemit/hivemind) 其实就是为了解决 `steemd` 的 `API` 压力过大而设计的数据库，主要是把文章数据，关注数据等等一系列细碎但是访问频度高的数据整理出来。

# 准备

* docker-compose

# 开始

## 1) 新建目录

```
mkdir hivemind
```
接下来的东西都将放在这个目录里面。

## 2) 新建 `docker-compose.yml`

在 `hivemind/` 目录下创建 `docker-compose.yml` 文件，内容如下：

```
version: '3'
services:
  db:
    image: postgres
    environment:
      POSTGRES_USER: steem
      POSTGRES_PASSWORD: steem
      POSTGRES_DB: hivedb
    volumes:
      - ./data:/var/lib/postgresql/data
    restart: always
  hive:
    depends_on:
      - db
    image: ety001/hivemind
    environment:
      DATABASE_URL: postgresql://steem:steem@db:5432/hivedb
      LOG_LEVEL: INFO
      STEEMD_URL: http://172.20.0.10:8091
      SYNC_SERVICE: 1
    ports:
      - 8888:8080
    links:
      - db:db
    restart: always
```

这里注意，需要修改 `STEEMD_URL` 为你的 `steemd` 的 `webserver` 地址。
另外，检查 `8888` 端口是否占用，如果已被占用，换之。

## 3) 启动

```
docker-compose up -d
```

可以通过下面的命令查看容器名
```
docker-compose ps
```

假设容器名是 `hivemind_hive_1`，可以通过下面的命令查看Log

```
docker logs -f --tail 1000 hivemind_hive_1
```

可以通过下面的命令查看同步进度

```
docker exec -it hivemind_hive_1 hive status
```

![](/upload/202003/hivemind.png)

## 4) 配置 `jussi`

如果是按照之前的教程 [https://steemit.com/cn/@ety001/jussi](https://steemit.com/cn/@ety001/jussi) 搭建的，切换到 `jussi` 目录下，下载针对 `hivemind` 的配置文件。

```
wget -c https://raw.githubusercontent.com/steemit/jussi/master/EXAMPLE_hivemind_upstream_config.json
```

改一下名

```
mv  EXAMPLE_hivemind_upstream_config.json  hive_config.json
```

打开这个配置文件，把里面所有标有 `steemd` 的 `URL` 换成你的 `steemd` 地址，所有标有 `hivemind` 的 `URL` 换成你的 `hivemind` 的地址。

例如，你宿主机IP是 `1.1.1.1`， `steemd` 是 `http://1.1.1.1:8091`，`hivemind` 是 `http://1.1.1.1:8888`，那么把 `https://your.account.history.steemd.url` 换成 `http://1.1.1.1:8091`，把 `https://your.hivemind.url` 换成 `http://1.1.1.1:8888`。

修改好以后，再打开 `jussi` 的 `docker-compose.yml`，把其中的配置文件映射修改为

```
volumes:
      - ./hive_config.json:/app/config.json
```

保存后，重启 `jussi` 完成配置

```
docker-compose down && docker-compose up -d
```

剩下的就等 `hivemind` 完成同步。

# 其他

## 1) 关于编译

本例中使用了我编译好的 `hivemind` 镜像，你可以选择自己编译，步骤是：

先下载代码

```
git clone https://github.com/steemit/hivemind.git
```

编译
```
cd hivemind
docker build -t hivemind .
```

## 2) 关于 `PostgreSQL` 优化

如果你想优化 `PostgreSQL`，可以参考下面的步骤：

先进入到 `hivemind/` 目录下，然后导出容器里的默认配置文件

```
docker run -i --rm postgres cat /usr/share/postgresql/postgresql.conf.sample > my-postgres.conf
```

把你想修改的参数在 `my-postgres.conf` 中修改好。官方给了一份 16G 内存 SSD 硬盘的优化方案作为参考：

```
effective_cache_size = 12GB # 50-75% of avail memory
maintenance_work_mem = 2GB
random_page_cost = 1.0      # assuming SSD storage
shared_buffers = 4GB        # 25% of memory
work_mem = 512MB
synchronous_commit = off
checkpoint_completion_target = 0.9
checkpoint_timeout = 30min
max_wal_size = 4GB
```

修改好以后，打开 `docker-compose.yml` 文件，增加配置文件映射，

```
volumes:
      - ./data:/var/lib/postgresql/data
      - ./my-postgres.conf:/etc/postgresql/postgresql.conf
```

最后一行就是我们新增的配置。

保存后，重启

```
docker-compose down && docker-compose up -d
```

## 3) 关于容器端口映射

由于 `docker` 的默认策略优先级在 `iptables` 中比 `ufw` 和 `firewalld` 高，所以所有把容器端口映射出来的操作，端口在公网是可被访问的。

由于我的 `nginx` 是通过容器运行的，所以我没有对端口映射，而是直接把相关容器额外加入到 `nginx` 容器所在网络下，并指定好固定IP，这样各个容器直接可以互访。



---
#### PS: [便宜的独立服务器推荐](https://billing.dacentec.com/hostbill/?affid=723)
