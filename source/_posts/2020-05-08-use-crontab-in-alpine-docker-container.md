---
author: ety001
layout: post
title: 在 alpine 容器中使用
tags:
  - 服务器
  - 配置
  - Server&OS
  - Docker
  - 经验
---

今天在开发 [Steem Watcher](/2020/05/08/steem-watcher.html) 过程中，由于需要跑计划任务，所以研究了一下如何在容器环境下使用 `crond`。

在此之前，我曾经使用宿主机的 `crond` 来启动一个临时容器跑任务，但这个思路很糟糕，并不方便快速移植。于是考虑还是要基于容器内部进行计划任务才是终极方案。

由于我的 [Steem Watcher](https://github.com/ety001/steem-watcher) 使用的[镜像](https://hub.docker.com/r/ety001/steem-python)是我自己基于 `alpine` 编译的，而 `alpine` 中已经带有 `crond` 程序，所以要在容器里实施计划任务还是比较轻松。

我们可以先看下 `crond` 的参数说明

```
/app # crond -h
crond: unrecognized option: h
BusyBox v1.27.2 (2018-06-06 09:08:44 UTC) multi-call binary.

Usage: crond -fbS -l N -d N -L LOGFILE -c DIR

        -f      Foreground
        -b      Background (default)
        -S      Log to syslog (default)
        -l N    Set log level. Most verbose 0, default 8
        -d N    Set log level, log to stderr
        -L FILE Log to FILE
        -c DIR  Cron dir. Default:/var/spool/cron/crontabs
```

介于容器执行命令不能立即返回，所以我们需要使用 `-f` 参数让 `crond` 在前台运行，这样可以保持容器一直运行。

然后查了下手册，发现 `crond` 的配置文件在 `/etc/crontabs/` 目录下面。这里需要注意，由于每个用户的 `crontab` 是独立的，如果你是 `root` 用户启动，那么其配置文件为 `/etc/crontabs/root`。

弄明白这些之后，我们想要搞计划任务的话，只需要创建个容器，让其 `command` 命令是 `crond -f`，然后把一个配置好的文件 `mount` 到容器里的 `/etc/crontabs/root`，再把需要执行的程序 `mount` 进去，最后启动即可了。

具体可以参考 [https://github.com/ety001/steem-watcher/blob/master/docker-compose.yml#L28](https://github.com/ety001/steem-watcher/blob/master/docker-compose.yml#L28) 这里了解。

> 除此之外还需要 **额外注意的事情** 就是，如果通过挂载的方式覆盖 `/etc/crontabs/root`，那么在宿主机上的配置文件，需要配置为 `755` 权限，并且用户和用户组需要设置为 `root`。


---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
