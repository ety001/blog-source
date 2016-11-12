---
author: ety001
comments: true
date: 2014-07-09 08:20:19+00:00
layout: post
slug: svn-usual-command
title: svn常用命令
wordpress_id: 2629
tags:
- 理论
---

1、

cl  ==  checklist

增加新的checklist

svn cl [list name] [file lists]

从checklist中删除

svn cl --remove [file name]

2、

列出某版本变动的文件列表

svn diff -r XX:YY --summarize

