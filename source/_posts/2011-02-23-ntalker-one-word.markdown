---
author: ety001
comments: true
date: 2011-02-23 06:16:44+00:00
layout: post
title: ntalker开发中的一句话的事儿
wordpress_id: 1066
tags:
- 后端
- 编程语言
---

由于刚开始学习PHP，里面有很多函数或者细节不了解，遂用这篇日志记录一下，随时保持更新。

**"@"在php中起什么作用？**
$a=@(57/0)
@在任何表达式之前使用
这个列子里面如果没有 @ 这行代码将出现除0的警告 使用这个代码 警告就被抑制住了

**PHP中explode的作用？**
explode — 使用一个字符串分割另一个字符串   这个有点像ASP中的 split()

**$_SERVER['PHP_SELF']的意思？**
在 URL 地址为 http://www.domyself.me/test.php/foo.bar 的脚本中使用 $_SERVER['PHP_SELF'] 将会得到 /test.php/foo.bar 这个结果。__FILE__ 常量包含当前（例如包含）文件的绝对路径和文件名。

**ntalker用户验证失败的可能原因之一？**
你的im_connectIM函数的使用可能有问题，检查一下最后有没有加一个空字符串，如下：

[code lang="php"]im_connectIM('<?php echo($im_siteid); ?>','<?php echo($Example_uid); ?>', '<?php echo($Example_username); ?>', '<?php echo($Example_uid); ?>','');[/code]

**microtime — 返回当前 Unix 时间戳和微秒数**
microtime() 当前 Unix 时间戳以及微秒数。本函数仅在支持 gettimeofday() 系统调用的操作系统下可用。
如果调用时不带可选参数，本函数以 "msec sec" 的格式返回一个字符串，其中 sec 是自 Unix 纪元（0:00:00 January 1, 1970 GMT）起到现在的秒数，msec 是微秒部分。字符串的两部分都是以秒为单位返回的。
如果给出了 get_as_float 参数并且其值等价于 TRUE，microtime() 将返回一个浮点数。

**PHP error_reporting() 函数**
error_reporting() 设置 PHP 的报错级别并返回当前级别。具体看这里：[http://www.w3school.com.cn/php/func_error_reporting.asp](http://www.w3school.com.cn/php/func_error_reporting.asp)

**PHP ini_set() 函数**
ini_set — Sets the value of a configuration option （设置一个配置选项的值）
具体看这里：[http://cn.php.net/manual/zh/function.ini-set.php](http://cn.php.net/manual/zh/function.ini-set.php)

**mysql_pconnect() 和 mysql_connect() 非常相似，但有两个主要区别：**
当连接的时候本函数将先尝试寻找一个在同一个主机上用同样的用户名和密码已经打开的（持久）连接，如果找到，则返回此连接标识而不打开新连接。
其次，当脚本执行完毕后到 SQL 服务器的连接不会被关闭，此连接将保持打开以备以后使用（mysql_close() 不会关闭由 mysql_pconnect() 建立的连接）。
