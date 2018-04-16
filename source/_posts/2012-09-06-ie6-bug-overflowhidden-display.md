---
author: ety001
comments: true
date: 2012-09-06 06:16:09+00:00
layout: post
slug: ie6-bug-overflowhidden-display
title: IE6 Bug overflow:hidden失效
wordpress_id: 2180
tags:
- 前端
---

当父元素的直接子元素或者下级子元素的样式拥有position:relative属性时，父元素的overflow:hidden属性就会失效。

解决方案：在父元素中也添加position:relative属性即可。

