---
author: ety001
comments: true
date: 2015-01-16 05:58:00+00:00
layout: post
slug: auto-detect-height-by-css
title: 如何自适应高度
tags:
- 前端
---


今天在做前端页面的时候，想要做一个高度自适应的页面，在css中设置height为100%一直不成功，后来经过调试发现，
只需要在父容器中按照以下设置，则可以使用height为100%来动态自适应浏览器的大小变化。

```
body{
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
}
```

