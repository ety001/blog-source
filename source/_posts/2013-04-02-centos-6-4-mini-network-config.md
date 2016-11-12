---
author: ety001
comments: true
date: 2013-04-02 01:52:37+00:00
layout: post
slug: centos-6-4-mini-network-config
title: centos 6.4 mini 网络配置
wordpress_id: 2343
tags:
- Server&OS
---

1、这里可以修改基本的网络信息，IP，netmask

```
vi /etc/sysconfig/network-scrip/ifcfg-eth0
```

2、修改网关在这里

```
vi /etc/sysconfig/network
加入gateway=192.168.1.1
```

3、修改DNS

```
vi /etc/resolve.conf
```

另外，配置好网络后需要用yum安装下wget和vim

开发工具包

```
yum groupinstall "Development Libraries" "Development Tools"
```

