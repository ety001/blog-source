---
author: ety001
comments: true
date: 2012-07-05 03:22:31+00:00
layout: post
slug: mysql-source-mysqldump
title: mysql source、mysqldump导入导出数据（转）
wordpress_id: 2137
tags:
- 理论
- 后端
---

转自：[http://www.cnblogs.com/zhuyue/archive/2012/07/04/2576971.html](http://www.cnblogs.com/zhuyue/archive/2012/07/04/2576971.html)

一、导入数据

1、确定 数据库默认编码，比如编码 为gbk,将读入途径编码同样设为gbk，命令为：
set names gbk;
2、source d:/20080613.sql 导入数据。验证 数据库 中的数据是否存在乱码。

3、如果仍然存在乱码问题，这时候就要考虑改变导入文件的编码，试着 导入，直至没有乱码出现。

网页数据存入乱码问题依照以上方法同样可以解决。可将网页编码改为与 数据库 相同的编码。问题自 然解决。

4、查看字符集

mysql>   show   variables   like   "%char%";

<!-- more -->

二、导出数据

mysqldump -u root -p --default-character-set=数据编码 数据库名称> file.sql

定义编码导出
mysqldump -u root -p --default-character-set=utf8 discuss_chi> dis.sql

定义编码导入
mysql -u root -p --default-character-set=utf8 -f discuss_chi<dis.sql
如还是乱码使用二进导入
mysql -u root -p --default-character-set=binary -f discuss_chi<dis.sql


还是不行，导出和导入都使用二进方式
导出
mysqldump -u root -p --default-character-set=binary discuss_chi> dis.sql
导入
mysql -u root -p --default-character-set=binary -f discuss_chi<dis.sql

