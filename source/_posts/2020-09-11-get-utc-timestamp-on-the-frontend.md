---
author: ety001
layout: post
title: 在前端获取UTC时间戳的方法
tags:
  - 前端
  - 经验
---

```
function getUtcTimestamp() {
    const now = new Date();
    const utcTimestamp = Date.UTC(
        now.getUTCFullYear(),
        now.getUTCMonth(),
        now.getUTCDate(),
        now.getUTCHours(),
        now.getUTCMinutes(),
        now.getUTCSeconds(),
        now.getUTCMilliseconds()
    );
    return `${parseInt(utcTimestamp / 1000, 10)}`;
}
```
