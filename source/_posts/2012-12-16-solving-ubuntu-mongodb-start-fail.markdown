---
author: ety001
comments: true
date: 2012-12-16 21:58:58+00:00
layout: post
slug: solving-ubuntu-mongodb-start-fail
title: ubuntu下mongodb启动失败解决
wordpress_id: 2253
tags:
- Server&OS
---

用sudo apt-get install mongodb安装了mongodb后，总是启动失败，查看log日志，发现了以下错误：
```
***** SERVER RESTARTED *****

/usr/bin/mongod: symbol lookup error: /usr/bin/mongod: undefined symbol: _ZN7pcrecpp2RE4InitEPKcPKNS_10RE_OptionsE
```

从搜索引擎上找不到，最后，在MongoDB官网上找到一个方法又重新装了一遍就可以用了，是用的10gen编译的deb包安装的，不过貌似官方推荐源码编译安装。

具体安装10gen的方法如下：

```
The Ubuntu package management tool (i.e. dpkg and apt) ensure package consistency and authenticity by requiring that distributors sign packages with GPG keys. Issue the following command to import the 10gen public GPG Key:

**sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10**

Create a **/etc/apt/sources.list.d/10gen.list** file and include the following line for the 10gen repository.
**deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen**

Now issue the following command to reload your repository:
sudo apt-get update

Install Packages
Issue the following command to install the latest stable version of MongoDB:
**sudo apt-get install mongodb-10gen**
```
