---
author: ety001
title: 零碎脚本执行利器 -- 青龙面板
date: 2024-11-20 17:21:15
layout: post
tags:
- 经验
- 服务器
- 配置
---

今天发现了一个有意思的工具 —— [青龙面板](https://github.com/whyour/qinglong)。

平时经常会有一些零零碎碎的脚本需要运行，放在宿主机运行，就要安装 nodejs 的环境，如果放在 docker 里运行，就要写 Dockerfile ，太繁琐。

使用这个青龙面板，相当于直接拥有一个容器空间，自带 python, nodejs 环境。可以理解为是云服务商的那种 server less 服务。

# 有这些特性很方便

### 1.按计划拉取指定的 repo 的指定分支。

![image.png](/img/2024/DQmNzrSTk6u7KoeXAE3rY5FQB2HAGinfGwnhfi47sAZSxHQ.png)

这样我们可以把零碎的脚本放在一个独立的代码库里面，进行版本管理。

当然，如果你想要立即执行拉取任务，也提供了单独的运行按钮可以立即执行。

### 2.共享依赖。

![06bbe3ec9a2257829a8383ed4c432d88.jpg](/img/2024/06bbe3ec9a2257829a8383ed4c432d88.jpg)

独立的依赖管理面板，可以只需要安装一次依赖，就可以所有脚本都使用。

### 3.在线编辑/调试代码。

![image.png](/img/2024/DQmZePRPW5aA5yk8id71c89p7xGJ7zKoXaQEW9kLZDJPSB2.png)

这是拉取下来的代码，可以在线编辑。

![image.png](/img/2024/DQmTCHbnWLgY7tKR68ULCvcEpJxhVyG1bMxSCFFut4UvCuF.png)


这是调试界面，可以实时调试。

### 4.核心功能——计划任务

![image.png](/img/2024/DQmTSVxe7zhGK79ah7hxYmiYZmveKnJ1KBWuY6YipGnteQv.png)

编辑好的脚本，可以在这里设置计划任务，让脚本按计划运行。
