---
author: ety001
layout: post
title: file_get_content抓取数据为false，但浏览器可以访问
tags:
- 编程语言

---

这两天在写第三方登录的SDK，其中遇到了一个有意思的问题，就是用file_get_content去读取github的接口的时候，
发现一直是false，而浏览器访问则没有问题。经过搜索，发现需要设置下user-agent，只要在php.ini中打开user-agent，
即可正常返回数据了。

