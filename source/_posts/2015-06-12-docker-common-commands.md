---
author: ety001
layout: post
title: docker常用基础命令
tags:
- Server&OS
---

### 1. 拉取docker hub上的已有镜像

    docker pull base/archlinux

### 2. 列出本地的镜像

    docker images

### 3. 搜索镜像

    docker search image_name

### 4. 列出容器

    # 显示所有的container
    docker ps -a

    # 显示最新的container
    docker ps -l

### 5. 从一个镜像启动容器并进入terminal

    docker run -ti IMAGE /bin/bash
    docker run -it --rm IMAGE /bin/bash #运行完删除容器, 建议调试时使用

### 6. 停止一个容器

    # CONTAINER为容器的名字，从 docker ps -a 中可以看到
    docker stop CONTAINER

### 7. 删除容器

    # CONTAINER为容器的名字，从 docker ps -a 中可以看到
    docker rm CONTAINER

### 8. 删除本地的镜像

    docker rmi IMAGE

### 9. 提交容器成为新的镜像

    docker commit -m "some log" <container_id> <some_name>

### 10. 进入一个正在运行的容器

    docker attach <容器id> #通过容器id进入, 不推荐该方法
    docker exec -i -t <容器id> /bin/bash  #通过容器id进入, 推荐该方法

### 11. 基于Dockerfile编译

    docker build -t <镜像名> .


另外附加一篇参考：<http://blog.chinaunix.net/uid-10915175-id-4443127.html>
