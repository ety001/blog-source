---
author: ety001
comments: true
date: 2012-03-08 11:45:51+00:00
layout: post
slug: use-mv-replace-rm-without-params
title: 用mv代替rm并且不带参数
wordpress_id: 2002
tags:
- Server&OS
---

由于单位的服务器是多人使用的，每次都会有人误删除文件，所以说就想到写个shell脚本用mv命令替换rm，但是随之问题就是，写出来的rm命名的shell脚本在使用的时候，大家还是按照原来的习惯，在删除文件夹的时候，使用rm -rf 这样的形式，而mv是没有-rf参数的，所以就会导致报错，为了解决这个问题，又完善了下shell脚本代码。

```
#! /bin/bash
dst = "/home/ety001/test_trash/"
for src_file in $@;
do
    if echo $src_file | grep -v '^-'
    then
        mv $src_file $dst
    fi
done
```

