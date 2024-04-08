---
author: ety001
layout: post
title: 优雅的终止Docker容器
tags:
- 教程
---
之前在文章中提到过通过[PHP捕获信号](https://steemit.com/cn-dev/@ety001/php)，以优雅的关闭程序，保证程序能够完成数据写入后才关闭。由于目前程序是通过 Docker 进行部署的，因此需要看下 Docker 容器的关闭方式。

目前 Docker 容器关闭可以通过两条命令，一条是 `docker stop` 一条是 `docker kill`。

先看 `docker stop`。

```
~/ > docker stop -h
Flag shorthand -h has been deprecated, please use --help

Usage:	docker stop [OPTIONS] CONTAINER [CONTAINER...]

Stop one or more running containers

Options:
  -t, --time int   Seconds to wait for stop before killing it (default 10)
```

`docker stop` 命令执行的时候，会先向容器中PID为1的进程发送系统信号SIGTERM，然后等待容器中的应用程序终止执行，如果等待时间达到设定的超时时间，或者默认的10秒，会继续发送SIGKILL的系统信号强行kill掉进程。在容器中的应用程序，可以选择忽略和不处理SIGTERM信号，不过一旦达到超时时间，程序就会被系统强行kill掉，因为SIGKILL信号是直接发往系统内核的，应用程序没有机会去处理它。在使用docker stop命令的时候，我们唯一能控制的是超时时间。

目前 [SteemLightDB](https://github.com/ety001/steem-lightdb) 使用 `docker stop -t 60 lightdb-transfer` 来停止程序，60秒的超时时间足够了。

另外一个就是 `docker kill`。

```
~/ > docker kill -h
Flag shorthand -h has been deprecated, please use --help

Usage:	docker kill [OPTIONS] CONTAINER [CONTAINER...]

Kill one or more running containers

Options:
  -s, --signal string   Signal to send to the container (default "KILL")
```

`docker kill` 的好处就是可以使用自定义的信号。默认信号是 `SIGKILL`，我们可以通过使用 `-s` 参数，使用指定信号。比如在我的程序中，我有对 `SIGINT` 信号进行处理，因此使用 `docker kill -s SIGINT lightdb-transfer` 也可以优雅的停止容器。

Over!!!