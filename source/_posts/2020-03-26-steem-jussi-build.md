---
author: ety001
layout: post
title: Steem Jussi 搭建
tags:
  - 服务器
  - 经验
  - 配置
  - steem
  - steemit
---

# 前言

[jussi](https://github.com/steemit/jussi) 是全节点的最前端的缓存层，负责用 JSON 把后端数据源数据格式统一，且提供缓存功能，提高吞吐量。

这篇帖子就来简单说下如何搭建。

> 注意：需要提前安装 `docker-compose`

# 开始

## 1. 创建目录

新建一个目录，用于存储与 `jussi` 相关的东西

```
mkdir jussi
```

## 2. 创建配置文件

在 `jussi/` 目录下，新建 `config.json` 文件，内容如下

```
{
  "limits": {
    "blacklist_accounts": [
      "non-steemit"
    ]
  },
  "upstreams": [
    {
      "name": "steemd",
      "translate_to_appbase": true,
      "urls": [
        [
          "steemd",
         "http://172.20.0.10:8091"
        ]
      ],
      "ttls": [
        [
          "steemd",
          3
        ],
        [
          "steemd.login_api",
          -1
        ],
        [
          "steemd.network_broadcast_api",
          -1
        ],
        [
          "steemd.follow_api",
          10
        ],
        [
          "steemd.market_history_api",
          1
        ],
        [
          "steemd.database_api",
          3
        ],
        [
          "steemd.database_api.get_block",
          -2
        ],
        [
          "steemd.database_api.get_block_header",
          -2
        ],
        [
          "steemd.database_api.get_content",
          1
        ],
        [
          "steemd.database_api.get_state",
          1
        ],
        [
          "steemd.database_api.get_state.params=['/trending']",
          30
        ],
        [
          "steemd.database_api.get_state.params=['trending']",
          30
        ],
        [
          "steemd.database_api.get_state.params=['/hot']",
          30
        ],
        [
          "steemd.database_api.get_state.params=['/welcome']",
          30
        ],
        [
          "steemd.database_api.get_state.params=['/promoted']",
          30
        ],
        [
          "steemd.database_api.get_state.params=['/created']",
          10
        ],
        [
          "steemd.database_api.get_dynamic_global_properties",
          1
        ]
      ],
      "timeouts": [
        [
          "steemd",
          5
        ],
        [
          "steemd.network_broadcast_api",
          0
        ]
      ]
    },
    {
      "name": "appbase",
      "urls": [
        [
          "appbase",
          "http://172.20.0.10:8091"
        ]
      ],
      "ttls": [
        [
          "appbase",
          -2
        ],
        [
          "appbase.block_api",
          -2
        ],
        [
          "appbase.database_api",
          1
        ]
      ],
      "timeouts": [
        [
          "appbase",
          3
        ],
        [
          "appbase.chain_api.push_block",
          0
        ],
        [
          "appbase.chain_api.push_transaction",
          0
        ],
        [
          "appbase.network_broadcast_api",
          0
        ],
        [
          "appbase.condenser_api.broadcast_block",
          0
        ],
        [
          "appbase.condenser_api.broadcast_transaction",
          0
        ],
        [
          "appbase.condenser_api.broadcast_transaction_synchronous",
          0
        ],
        [
          "appbase.condenser_api.get_ops_in_block.params=[2889020,false]",
          20
        ]
      ]
    }
  ]
}
```

搜索 `http://172.20.0.10:8091` ，把里面出现两次的地方，都换成你自己的 `steemd` 的地址和端口。

> 注意：填写的IP是否可以在容器内被访问。比如你宿主机IP是1.1.1.1，你用1.1.1.1:8091可以访问 `steemd` ，那么在配置文件里就这样填写即可。

## 3. 创建 `docker-compose.yml`

在 `jussi/` 目录下创建 `docker-compose.yml`，内容如下：

```
version: "3.3"
services:
  jussi:
    restart: "always"
    image: "steemit/jussi:latest"
    ports:
      - "8080:8080"
    environment:
      JUSSI_UPSTREAM_CONFIG_FILE: /app/config.json
      JUSSI_REDIS_URL: redis://redis1:6379
    volumes:
      - ./config.json:/app/config.json
  redis1:
    restart: "always"
    image: "redis:latest"
    volumes:
      - ./redis1:/data
```

> 注意： 确认下你目前机器是否有程序占用 `8080` 端口，如果有占用，修改一下 `ports` 参数中冒号前面的端口号

## 4. 启动

进入 `jussi/` 目录后，执行

```
docker-compose up -d
```

即可启动。启动后，`8080` 端口即为 `jussi` 的服务端口。配合 `nginx` 进行反向代理，加上证书即可。

# 其他参考命令

以下命令需要在 `jussi/` 目录下执行

## 1. 停止并卸载容器和网络

```
docker-compose down
```

## 2. 查看相关运行容器

```
docker-compose ps
```

## 3. 查看log

```
# 查看log，并且截取最后100行，且持续输出。容器名不填就是全部容器
docker-compose logs -f --tail 100 [容器名]
```

# 参考

[https://github.com/steemit/jussi](https://github.com/steemit/jussi)

---
#### PS: [便宜的独立服务器推荐](https://billing.dacentec.com/hostbill/?affid=723)
