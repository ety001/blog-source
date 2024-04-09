---
author: ety001
comments: true
date: 2013-10-30 08:08:39
layout: post
slug: mysql-read-only
title: MySQL --read-only
wordpress_id: 2521
tags:
- 后端
---

转自：[http://blog.csdn.net/cindy9902/article/details/5886355](http://blog.csdn.net/cindy9902/article/details/5886355)

以前在用MMM管理multi master 作failover是看到过MMM使用read-only选项来控制对其读写角色的分配，当时尝试过加上这个选项，然后对其进行update，insert操作，发现也是可以的。。所以觉得这个选项没有什么实际意义。。。现在想想当时是用管理员的帐户去执行的，肯定是有super权限的，所以才可以进行update和insert操作。



今天在测试过程中也遇到了read-only的问题，发现写操作因为read-only 这个选项的开启，而不能够成功执行。找了下资料，才了解read-only的真正含义和用法：

<!-- more -->

**  --read_only**         Make all non-temporary tables read-only, with the
exception for replication (slave) threads and users with
the SUPER privilege

**SUPER privilege** :

The [`SUPER` ](http://dev.mysql.com/doc/refman/5.0/en/privileges-provided.html#priv_super)privilege enables an account to use [`CHANGE MASTER TO` ](http://dev.mysql.com/doc/refman/5.0/en/change-master-to.html), [`KILL` ](http://dev.mysql.com/doc/refman/5.0/en/kill.html)or [**mysqladmin kill** ](http://dev.mysql.com/doc/refman/5.0/en/mysqladmin.html)to kill threads belonging to other accounts (you can always kill your own threads), [`PURGE BINARY LOGS` ](http://dev.mysql.com/doc/refman/5.0/en/purge-binary-logs.html), configuration changes using [`SET GLOBAL` ](http://dev.mysql.com/doc/refman/5.0/en/set-option.html)to modify global system variables, the [**mysqladmin debug** ](http://dev.mysql.com/doc/refman/5.0/en/mysqladmin.html)command, enabling or disabling logging, performing updates even if the [`read_only` ](http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_read_only)system variable is enabled, starting and stopping replication on slave servers, specification of any account in the `DEFINER` attribute of stored programs and views, and enables you to connect (once) even if the connection limit controlled by the [`max_connections`](http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_max_connections)system variable is reached.

To create or alter stored routines if binary logging is enabled, you may also need the [`SUPER` ](http://dev.mysql.com/doc/refman/5.0/en/privileges-provided.html#priv_super)privilege, as described in [Section 18.6, “Binary Logging of Stored Programs”](http://dev.mysql.com/doc/refman/5.0/en/stored-programs-logging.html) .



read-only选项：对所有的非临时表进行只读控制。但是有两种情况例外：

1. 对replication threads例外，以保证slave能够正常的进行replication。

2. 对于拥有super权限的用户，可以ignore这个选项。

SUPER 权限 ： 1. 可以有change master to, kill其他用户的线程的权限。

2. Purge binary logs 来删除binary log, set global来动态设置变量的权限。

3. 执行mysqladmin debug命令，开启或者关闭log，在read-only打开时执行update/insert操作。

4. 执行start slave, stop slave.

5. 当连接数已经达到max_connections的最大值时，也可以连接到server。

