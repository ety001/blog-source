---
author: ety001
comments: true
date: 2013-01-07 01:07:55+00:00
layout: post
slug: svn-server-share-the-same-authz-passwd-files
title: svn服务器多个库共用同一个用户验证文件
wordpress_id: 2265
tags:
- Server&OS
---

svnserve命令中有一个参数是config-file参数，可以用来设置svn服务启动的时候，指定一个全局config文件，这样每个库下面的conf文件夹的配置文件就不会再生效了。对于该参数，网上鲜有介绍，基本上svn配置的文章就那么几篇，还基本上都是互相copy的。。。大家比较常见的就是下面这条命令了：

    svnserve -d -r /home/svn

我们如果想用全局配置文件，那么就按下面的命令启动svn服务：

    svnserve -d -r /home/svn --config-file /home/svn/svnserve.conf

另外，我没有尝试成功把配置文件放到svn目录以外的地方，也就是说我的svn库目录是/home/svn，这个目录下有N个库目录，只有当我的全局配置文件svnserve.conf，passwd，authz放到/home/svn下才生效，我放到别的目录的时候，在客户端对库进行操作的时候是报错没有指定的用户（username cannot find）。包括在svnserve.conf中设置passwd和authz的位置为其他目录也失败了。

