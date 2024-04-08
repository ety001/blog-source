---
author: ety001
comments: true
date: 2013-09-06 01:46:15+00:00
layout: post
slug: how-to-converting-microsoft-access-mdb-into-csv-or-mysql-in-linux
title: How to converting Microsoft Access MDB into CSV or Mysql in linux
wordpress_id: 2451
tags:
- Server&OS
- 后端
---

安装一个工具，mdbtools，地址：http://mdbtools.sourceforge.net/，ubuntu应该可以直接安装，archlinux在aur中有。

具体使用方法：

To get the list of tables, you run the following command:


<blockquote>mdb-tables database.mdb</blockquote>


You can then get a CSV version for each table using:


<blockquote>mdb-export database.mdb table_name</blockquote>


You can also convert the mdb into a format required by MySQL. First you must get the put the table schema into the database using the following command:


<blockquote>mdb-schema database.mdb | mysql -u username -p database_name</blockquote>


You then import each table by running:


<blockquote>mdb-export -I database.mdb table_name | sed -e 's/)$/)\;/' | mysql -u username -p database_name</blockquote>

