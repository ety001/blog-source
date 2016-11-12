---
author: ety001
date: 2010-10-12 08:30:57+00:00
layout: post
title: 关于CSS中的兼容性一句话小结
wordpress_id: 221
tags:
- 前端

---

很多时候可能是IE与FireFox对于同一个元素的初定义不同造成的成兼容性问题。

解决方案：把元素的margin和padding都设为0。

到目前为止，我所发现出现这种问题的元素有：ul、标题元素（h1、h2等）。
