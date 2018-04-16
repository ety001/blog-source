---
author: ety001
comments: true
date: 2013-09-29 14:05:44+00:00
layout: post
slug: php-php_eol
title: php PHP_EOL
wordpress_id: 2476
tags:
- Server&OS
- 后端
---

换行符
unix系列用 \n
windows系列用 \r\n
mac用 \r
PHP中可以用PHP_EOL来替代，以提高代码的源代码级可移植性

如：
<?php
echoPHP_EOL;
//windows平台相当于    echo "\r\n";
//unix\linux平台相当于    echo "\n";
//mac平台相当于    echo "\r";
?>
类似常用的还有
DIRECTORY_SEPARATOR

可以用函数get_defined_constants()来获取所有PHP常量



转： http://www.cnblogs.com/codefor/archive/2011/06/18/2084300.html

