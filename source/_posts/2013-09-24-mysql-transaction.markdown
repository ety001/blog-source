---
author: ety001
comments: true
date: 2013-09-24 16:11:38+00:00
layout: post
slug: mysql-transaction
title: MYSQL–事务处理
wordpress_id: 2470
tags:
- 理论
---

转自：[http://levi.cg.am/?p=3023](http://levi.cg.am/?p=3023)

事务处理在各种管理系统中都有着广泛的应用，比如人员管理系统，很多同步数据库操作大都需要用到事务处理。**比如说，在人员管理系统中，你删除一个人员，你即需要删除人员的基本资料，也要删除和该人员相关的信息，如信箱，文章等等**，这样，这些数据库操作语句就构成一个事务！
删除的SQL语句


    delete from userinfo where ~~~
    delete from mail where ~~
    delete from article where~~
    ~~


如果没有事务处理，在你删除的过程中，假设出错了，只执行了第一句，那么其后果是难以想象的！
但用事务处理。如果删除出错，你只要rollback就可以取消删除操作（其实是只要你没有commit你就没有确实的执行该删除操作）

一般来说，在商务级的应用中，都必须考虑事务处理的！<!-- more -->


## 查看inodb信息








<table cellpadding="0" cellspacing="0" border="0" >
<tbody >
<tr >

<td >


1




2

</td>

<td >





`shell> ``/usr/local/mysql` `-u root -p`




`mysql> show variables like ``"have_%"`




</td>
</tr>
</tbody>
</table>






**系统会提示：**






<table cellpadding="0" cellspacing="0" border="0" >
<tbody >
<tr >

<td >


1




2




3




4




5




6




7




8




9




10




11




12




13

</td>

<td >





`+-------------------+--------+`




`| Variable_name     | Value |`




`+-------------------+--------+`




`| have_bdb          | YES    |`




`| have_crypt        | YES    |`




`| have_innodb       | YES    |`




`| have_isam         | YES    |`




`| have_raid         | YES    |`




`| have_symlink      | YES    |`




`| have_openssl      | NO     |`




`| have_query_cache  | YES    |`




`+-------------------+--------+`




`8 rows ``in` `set` `(0.05 sec)`




</td>
</tr>
</tbody>
</table>






如果是这样的，那么我们就可以创建一张支持事务处理的表来试试了。


## MYSQL的事务处理功能！


一直以来我都以为MYSQL不支持事务处理，所以在处理多个数据表的数据时，一直都很麻烦（我是不得不将其写入文本文件，在系统重新加载得时候才写入数据库以防出错）～今天发现MYSQL数据库从4.1就开始支持事务功能，5.0引入了存储过程^_^

先简单介绍一下事务吧！事务是DBMS得执行单位。它由有限得数据库操作序列组成得。但不是任意得数据库操作序列都能成为事务。

**一般来说，事务是必须满足4个条件（ACID）：**




  1. 原子性（Autmic）：事务在执行性，要做到“要么不做，要么全做！”，就是说不允许事务部分得执行。即使因为故障而使事务不能完成，在rollback时也要消除对数据库得影响！


  2. 一致性（Consistency）：事务得操作应该使使数据库从一个一致状态转变倒另一个一致得状态！就拿网上购物来说吧，你只有即让商品出库，又让商品进入顾客得购物篮才能构成事务！


  3. 隔离性（Isolation）：如果多个事务并发执行，应象各个事务独立执行一样！


  4. 持久性（Durability）：一个成功执行得事务对数据库得作用是持久得，即使数据库应故障出错，也应该能够恢复！


**MYSQL的事务处理主要有两种方法：**




  1. 用begin, rollback, commit来实现：


    * begin 开始一个事务


    * rollback 事务回滚


    * commit  事务确认





  2. 直接用set来改变mysql的自动提交模式：
MYSQL默认是自动提交的，也就是你提交一个QUERY，它就直接执行！我们可以通过


    * set autocommit=0   禁止自动提交


    * set autocommit=1 开启自动提交







<blockquote>但注意当你用 set autocommit=0 的时候，你以后所有的SQL都将做为事务处理，直到你用commit确认或rollback结束，注意当你结束这个事务的同时也开启了个新的事务！按第一种方法只将当前的作为一个事务！
**个人推荐使用第一种方法！**
MYSQL中只有INNODB和BDB类型的数据表才能支持事务处理！其他的类型是不支持的！（切记！）</blockquote>




## 测试：


**SQL代码：**






<table cellpadding="0" cellspacing="0" border="0" >
<tbody >
<tr >

<td >


1




2




3




4




5




6




7




8




9




10




11




12




13




14




15




16




17




18




19




20




21




22




23




24




25




26




27




28




29




30




31




32




33




34




35




36




37




38




39




40




41




42




43




44




45




46




47




48




49




50




51

</td>

<td >





`mysql> use ``test``;`




`Database changed`







`mysql> CREATE TABLE `dbtest`(`




`    ``-> ``id` `int(4)`




`    ``-> ) TYPE=INNODB;`




`Query OK, 0 rows affected, 1 warning (0.05 sec)`







`mysql> SELECT * FROM `dbtest`;`




`Empty ``set` `(0.01 sec)`







`mysql> begin;`




`Query OK, 0 rows affected (0.00 sec)`







`mysql> INSERT INTO `dbtest` VALUES(5);`




`Query OK, 1 row affected (0.00 sec)`







`mysql> INSERT INTO `dbtest` VALUES(6);`




`Query OK, 1 row affected (0.00 sec)`







`mysql> commit;`




`Query OK, 0 rows affected (0.00 sec)`







`mysql> ``select` `* from dbtest;`




`+------+`




`| ``id`   `|`




`+------+`




`|  5   |`




`|  6   |`




`+------+`




`2 rows ``in` `set` `(0.00 sec)`







`mysql> begin;`




`Query OK, 0 rows affected (0.00 sec)`







`mysql> INSERT INTO `dbtest` VALUES(7);`




`Query OK, 1 row affected (0.00 sec)`







`mysql> rollback;`




`Query OK, 0 rows affected (0.00 sec)`







`mysql> ``select` `* from dbtest;`




`+------+`




`| ``id`   `|`




`+------+`




`|  5   |`




`|  6   |`




`+------+`




`2 rows ``in` `set` `(0.00 sec)`







`mysql>`




</td>
</tr>
</tbody>
</table>






**php函数：**






<table cellpadding="0" cellspacing="0" border="0" >
<tbody >
<tr >

<td >


1




2




3




4




5




6




7




8




9




10




11




12




13




14




15




16




17




18




19




20




21




22




23

</td>

<td >





`function` `Tran (``$sql``)`




`{`




`    ``$judge` `= 1;`




`    ``mysql_query(``'begin'``);`




`    ``foreach` `(``$sql` `as` `$v``)`




`    ``{`




`        ``if` `(!mysql_query(``$v``))`




`        ``{`




`            ``$judge` `= 0;`




`        ``}`




`    ``}`







`    ``if` `(``$judge` `== 0)`




`    ``{`




`        ``mysql_query(``'rollback'``);`




`        ``return` `false;`




`    ``}`




`    ``elseif` `(``$judge` `== 1)`




`    ``{`




`        ``mysql_query(``'commit'``);`




`        ``return` `true;`




`    ``}`




`}`




</td>
</tr>
</tbody>
</table>






**PHP：回滚**






<table cellpadding="0" cellspacing="0" border="0" >
<tbody >
<tr >

<td >


1




2




3




4




5




6




7




8




9




10




11




12




13




14




15




16




17




18




19

</td>

<td >





`<?php`




`$handler` `= mysql_connect(``'localhost'``, ``'root'``, ``''``);`




`mysql_select_db(``'task'``);`




`mysql_query(``'SET AUTOCOMMIT=0'``);    ``//设置为不自动提交，因为MYSQL默认立即执行`




`mysql_query(``'BEGIN'``);               ``//开始事务定义`







`if``(!mysql_query(``'INSERT INTO `trans` (`id`) VALUES (2);'``))`




`{`




`    ``mysql_query(``'ROOLBACK'``);        ``//判断当执行失败时回滚`




`}`







`if``(!mysql_query(``'INSERT INTO `trans` (`id`) VALUES (4);'``))`




`{`




`    ``mysql_query(``'ROOLBACK'``);        ``//判断执行失败回滚`




`}`







`mysql_query(``'COMMIT'``);              ``//执行事务`




`mysql_close(``$handler``);`




`?>`




</td>
</tr>
</tbody>
</table>






下次有空说下MYSQL的数据表的锁定和解锁！
