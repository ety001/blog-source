---
author: ety001
title: 利用 Docker Context + Buildx 实现远程构建
date: 2026-05-10 23:30:00
layout: post
tags:
- 经验
- 服务器
- Docker
---

# 背景

日常开发中，本地工作机的磁盘空间和 CPU 资源往往比较紧张，尤其是在编译大型 Docker 镜像时，构建缓存和中间层会占用大量磁盘空间。与此同时，家里可能有一台配置更强的服务器，磁盘充裕但平时处于闲置状态。

有没有一种优雅的方式，能让本地开发机把 Docker 构建任务分发到远程服务器上执行，同时又不影响本地开发体验？

答案是 **Docker Context + Buildx Remote Builder**。

# 原理

Docker CLI 原生支持通过 SSH 连接远程的 Docker daemon。配合 `buildx`，可以创建一个远程 builder，所有 `docker buildx build` 命令会自动通过 SSH 把构建任务发送到远程机器上执行。

```
本地工作机                         远程服务器
┌──────────────┐     SSH 隧道      ┌──────────────┐
│  docker CLI  │ ─────────────────▶│  Docker D    │
│  buildx      │    ssh://remote   │  BuildKit    │
│  源码目录    │                   │  构建缓存    │
└──────────────┘                   └──────────────┘
      │                                  ▲
      │  docker buildx build ────────────┘
      │  (自动通过 SSH 发送构建指令)
```

整个过程中，源码通过 SSH 上下文传递给远程 BuildKit，构建在远程服务器上执行，构建缓存也累积在远程机器上。本地工作机只负责发送构建指令和接收构建日志。

# 具体步骤

## 1. 创建 Docker Context

```bash
docker context create remote --docker "host=ssh://user@remote-server"
```

这样 `docker -c remote ps` 就等价于 `ssh user@remote-server docker ps`，Docker CLI 自动走 SSH 隧道。

> 如果已经在 `~/.ssh/config` 中配置了主机别名（比如 `Host remote`），直接写 `ssh://remote` 即可。

## 2. 创建远程 buildx builder

```bash
docker buildx create --name remote-builder remote --use
```

这会在远程服务器上启动一个 BuildKit 容器，所有 `docker buildx build` 都会走这个 builder。

首次创建时需要拉取 `moby/buildkit` 镜像，取决于网络情况可能需要一些时间。

## 3. 使用方式

在项目目录下执行：

```bash
# 构建镜像（镜像存在远程服务器上）
docker buildx build -t myapp:latest -f Dockerfile .

# 构建并推送到 registry
docker buildx build -t myapp:latest -f Dockerfile --push .

# 构建后拉回本地（镜像通过 SSH 传回工作机）
docker buildx build -t myapp:latest -f Dockerfile --load .
```

## 4. 切换回本地构建

```bash
docker buildx use default
```

# 注意事项

## 镜像位置

默认情况下，`docker buildx build` 构建出来的镜像存在于远程服务器上，本地工作机的 `docker images` 是看不到的。

如果需要在本地运行该镜像，需要加 `--load` 参数，但这会把镜像通过 SSH 拉回本地，占用本地磁盘空间。更推荐的做法是加 `--push` 直接推送到 registry。

## 首次 bootstrap 较慢

首次创建 builder 时，远程服务器需要拉取 `moby/buildkit` 镜像。如果通过跳板机连接，网络延迟较高，拉取可能需要几分钟。耐心等一下就好。

## 构建缓存

远程 builder 有自己的 BuildKit 缓存，同一个项目第二次构建时会命中缓存，速度明显更快。不同项目的缓存互相隔离，不会互相干扰。

## 不侵入现有流程

这个方案不需要修改 Dockerfile，不需要改 CI/CD 配置。只需要在构建时指定用哪个 builder，其他一切照旧。

# 总结

通过 Docker Context + Buildx，可以零成本地把重型构建任务卸载到闲置的远程服务器上，释放本地工作机的磁盘和 CPU 资源。对于本地磁盘紧张但又需要频繁构建大型镜像的场景，这是一个非常优雅的解决方案。
