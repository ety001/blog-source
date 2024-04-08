---
author: ety001
layout: post
title: 'Doctrine不支持在 ManyToMany 的 join table 上增加额外的字段'
tags:
- 经验
---

[SteemLightDB](https://github.com/ety001/steem-lightdb) 的用户表设计，
之前使用的是 Many To Many self-referencing 的方法来实现的用户关注关系的数据库实现。

昨天发现在关注数据中，还有一个 what 字段我给疏忽了，这个字段表明是“关注”还是“屏蔽”，
于是想要在 join table 中加一个字段。但是看了 Doctrine 的文档后，发现并没有相关的方法，
按照 Doctrine 的意思是，ManyToMany 的 join table 的目的是为了连接两个表，
因此只会存储两个被连接表的外键字段，如果想要增加 extra column，需要自己手动建立 join table，
实现 OneToMany <=> ManyToOne 的关系。

Over!