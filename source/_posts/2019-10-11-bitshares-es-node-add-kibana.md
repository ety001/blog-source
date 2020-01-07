---
author: ety001
layout: post
title: 对之前的 Bitshares Elastic Search 增加 Kibana
tags:
- Server&OS
- Bitshares
- Docker
---

![](/upload/20191011/bsLKuXdNVZ5I3DiMSwWsWHrYE3z6ygCvtTua60Zw.jpeg)

继上篇文章[《重写了我的bitshares-elasticsearch的docker-compose》](https://steemit.com/cn/@ety001/bitshares-elasticsearch-docker-compose)之后，经过一天的调试，我又增加了 `Kibana` 的配置到 `docker-compose.yml` 文件中。

使用方法很简单，首先停止所有容器

```
docker-compose down
```

然后备份下你之前的密码，再更新代码仓库到最新。

之后，修改 `kibana.yml` 文件中的 `elasticsearch.password` 为你的 `elastic` 密码。

如果你想要直接暴露 `Kibana` 的管理端口，可以修改 `docker-compose.yml` 文件，

```
kibana:
    container_name: kibana
    image: docker.elastic.co/kibana/kibana:7.4.0
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml
    networks:
      esnet:
        ipv4_address: 172.22.0.5
    #ports:               # 去掉这里的注释即可直接暴露端口
    #  - 5601:5601        # 去掉这里的注释即可直接暴露端口
```

最后，启动所有容器即可，

```
docker-compose up -d
```

目前，我已经在我的节点上配置了开放用户，

> URL: [https://bts-es.liuye.tech/](https://bts-es.liuye.tech/)  
> Username: bts  
> Password: btsbts  


---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
