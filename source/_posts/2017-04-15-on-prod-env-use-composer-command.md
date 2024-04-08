---
author: ety001
date: 2017-04-15 08:24:49+00:00
layout: post
title: 生产环境以非root使用composer
tags: Server&OS
---

在服务器端部署代码的时候，新版本的 *composer* 不再支持 *root* 用户来运行。因为会带来潜在的安全问题，
这导致 *composer update* 之后，不会再执行 *scripts* 里的脚本命令。

但是一般服务器上的web服务都是运行在 *www* 之类的用户下面的，且这些用户是不允许登陆的，那么我们该咋整？

经过搜索和实验后，发现 *runuser* 不好使，可以使用 *sudo*，具体命令如下：

```shell
sudo -u www /usr/local/bin/composer update
```

###### *注意要执行的命令需要完整路径。*
