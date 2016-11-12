---
author: ety001
layout: post
title: 解决百度爬虫无法爬取github page问题 2
tags:
- 网站日志
- Server&OS
---
继上次我按照[《解决百度爬虫无法爬取github page问题》]({% post_url 2015-12-08-fix-baidu-spider-cannot-reads-github-page %})中的方案实施后，我自己博客的搜索量在逐步的恢复中，如下图：

![索引量在恢复]({{ site.url }}/assets/upload/20151223/index-quote.png)

今天调整了我的vps上更新的方式。把之前的 jekyll 服务器关掉了，直接把 nginx 指向了 `_site` 目录，然后使用 github 的 webhook ，实现了本地 push 代码到远端的时候，可以让 vps 上的 jekyll 重新 build 新的静态文件。

这样就可以减少一个端口的开放和服务的运行了。
