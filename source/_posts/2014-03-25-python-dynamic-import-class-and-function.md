---
author: ety001
comments: true
date: 2014-03-25 08:52:15+00:00
layout: post
slug: python-dynamic-import-class-and-function
title: python动态加载类和方法
wordpress_id: 2592
tags:
- 编程语言
---

```
    def _importCls(self,model,action,params):
        obj = __import__(model)
        entrance = getattr(obj,action)
        if params == '':
            entrance()
        else:
            entrance(params)
```

