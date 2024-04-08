---
title: JS中的时区问题
date: 2017-02-11 12:22:30
keywords: ['javascript', 'timezone', 'gettime', 'js']
tags:
- 前端
---
昨天项目中的一个js的时间间隔计算的bug，真的是被搞的焦头烂额。
最终无奈，只能把js计算过程中的每一步都 *console.log* 出来，
然后才发现，原来是同事的机器本地时间涉及到冬令时和夏令时。

源代码大致是这样：

```
var start_date = '2017/02/10';
var end_date = '2017/05/20';
var tmp = new Date(start_date);
start_time = tmp.getTime();
tmp = new Date(end_date);
end_time = tmp.getTime();
//时间戳相减求间隔的代码就不写了。。。
```

由于存在夏令时和冬令时的缘故，两次的 *tmp* 对象的时区其实是不一样的，
这就导致最终的时间戳做差就会少一天。

最终的解决方案是，把时间都统一到 *UTC* 后，然后再计算。

具体的获取时间戳的方法是：

```
var timestamp = Date.UTC(year, month-1, day);
```

**一定要注意的是 js 中的 month 是从 0 开始的！！！**
