---
author: ety001
comments: true
date: 2013-06-18 12:07:10+00:00
layout: post
slug: rewrite-rule
title: rewrite rule
wordpress_id: 2404
tags:
- Server&OS
---

之前总是懒得记，每次用都得查，这次记录下：

```
RewriteCond %{REQUEST_FILENAME} !-f
如果文件存在，就直接访问文件，不进行下面的RewriteRule.

RewriteCond %{REQUEST_FILENAME} !-d
如果目录存在就直接访问目录不进行RewriteRule

RewriteCond %{REQUEST_URI} !^.*(\.css|\.js|\.gif|\.png|\.jpg|\.jpeg)$
如果是这些后缀的文件，就直接访问文件，不进行Rewrite
```

