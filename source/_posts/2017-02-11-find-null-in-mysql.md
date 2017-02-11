---
title: MySQL中如何检索值为null的记录
date: 2017-02-11 12:22:30
keywords: ['mysql', 'null']
tags:
- 后端
---
起因，在代码上线过程中发现了一个bug，列表中缺失的值为 *NULL* 的记录。
于是检查 *SQL* 语句，自己感觉没有什么问题。就是列表中不要显示值为 *sample* 的记录。

原有的SQL大致是这么写的

```
select * from tableA where key != 'sample';
```

其中还有很多 *key* 为 *NULL* 的记录没有检索出来。

经过搜索引擎的查找，发现原来普通的运算符不能用在 *NULL* 上。。。

真是惭愧。。居然不知道这个。。。

改为下面的语句后就可以了

```
select * from tableA where key != 'sample' or key is null;
```
