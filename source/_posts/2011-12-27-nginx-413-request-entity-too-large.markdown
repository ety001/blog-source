---
author: ety001
date: 2011-12-27 17:22:37+00:00
layout: post
title: 处理Nginx出现的413 Request Entity Too Large错误
wordpress_id: 1832
tags:
- Server&OS
---

处理Nginx出现的413 Request Entity Too Large错误
这个错误一般在上传文件的时候出现，打开nginx主配置文件nginx.conf，找到http{}段，添加


`client_max_body_size 8m;`


要是跑php的话这个大小client_max_body_size要和php.ini中的如下值的最大值一致或者稍大，这样就不会因为提交数据大小不一致出现的错误。


`post_max_size = 8M
upload_max_filesize = 2M`
