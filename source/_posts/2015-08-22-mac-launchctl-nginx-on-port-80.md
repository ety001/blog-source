---
author: ety001
date: 2015-08-22
layout: post
title: Mac下Launchctl无法启动80端口的nginx解决方案
tags:
- Server&OS
---

使用 brew 安装完 nginx 后，想用 launchctl 来实现 nginx 的开机自启动。
但是由于 80 端口属于 1--1024 间的端口，需要 root 权限，于是执行下面两条命令，
即可让普通用户也可以建立80端口。该方法其实就是给 nginx 加上 s 操作权限。
让普通用户可以以 root 权限执行。

```bash
sudo chown root:wheel /usr/local/Cellar/nginx/1.2.6/sbin/nginx
sudo chmod u+s /usr/local/Cellar/nginx/1.2.6/sbin/nginx
```
