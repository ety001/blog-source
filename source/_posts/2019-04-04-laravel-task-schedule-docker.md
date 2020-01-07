---
author: ety001
layout: post
title: "Laravel Task Schedule 在 Docker 环境下的实践"
tags:
- Server&OS
- Docker
- Laravel
---

# 起因

最近一个项目用到了 **Laravel** 框架的 **Task Schedule** 功能。

这个功能其实就是把 **Laravel** 的一个 **Command** 加到 **Crontab** 中，即

```
* * * * *  php /path-to-your-project/artisan schedule:run >> /dev/null 2>&1
```

然后你可以在 **Laravel** 中配置更多的详细的计划任务。

# 问题

由于当前生产环境，我使用的是 **Docker** 来部署的。

我的 **Docker** 部署方案思路是用 **Docker** 的容器来作为运行环境，所有的网站代码通过挂载的方式，让容器读取到。具体的配置方案可以参考我之前的一篇文章 《[命令行版的docker化lnmp搭建](/2018/11/10/docker-lnmp.html)》。

这样的生产环境部署 **Crontab** 就有些棘手了。因为容器最好是只跑一个进程，如果用 **docker exec** 在 **PHP** 容器里执行 ` php /path-to-your-project/artisan schedule:run >> /dev/null 2>&1`，那就违背了这个最佳实践。而在宿主机部署计划任务，宿主机又没有 **PHP** 执行环境。

# 解决

最终我想到的方案是，按照当前 **PHP** 容器的配置参数，再启动一个临时容器来执行 ` php /path-to-your-project/artisan schedule:run >> /dev/null 2>&1`。

比如说当前我的 **PHP** 容器的启动命令是：

```
docker run -itd --name php7 \
-v /etc/php7:/etc/php7 \
-v /data/wwwroot:/data/wwwroot \
-v /tmp:/tmp \
-v /data/logs/php7:/var/log/php7 \
--restart always \
--network lnmp \
--ip "172.20.0.4" \
ety001/php:7.2.14
```

那么我在宿主机创建一个脚本 `schedule.sh`，内容如下：

```
docker run -i \
--user 65534:65534 \
--rm \
-v /etc/php7:/etc/php7 \
-v /data/wwwroot:/data/wwwroot \
-v /tmp:/tmp \
-v /data/logs/php7:/var/log/php7 \
--network lnmp \
ety001/php:7.2.14 \
php /data/wwwroot/xiaoyugan-server/artisan schedule:run
```

然后在宿主机的计划任务中添加

```
* * * * * /your-project-path/schedule.sh
```

> 这里需要注意的是，去掉了 `-t` 参数，否则把 `schedule.sh` 加入到计划任务后，会执行失败，报 `The input device is not a TTY`。
> 另外需要增加 `--user` 参数来指定你的计划任务的执行用户。**这个配置很重要！！！**由于我的网站运行在 **nobody** 用户下，如果不增加这个配置，那么计划任务里的写日志操作，很可能在每天0点的时候触发，进而导致日志文件的属主是 **root** 用户，进而网站再有写日志操作就会没有权限写入了，很尴尬！
> `--rm` 参数可以使容器里的主进程执行结束后，自动删除该容器

# 总结

目前看，这个方案应该是优雅的吧。不过配置起来还是很复杂，且很多点有时候想不到。就像这个 `--user` 参数，也是在偶然的跨天测试中发现的。像这种跨天的bug真的是很坑。。。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
