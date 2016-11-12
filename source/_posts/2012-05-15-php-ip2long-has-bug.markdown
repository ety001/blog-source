---
author: ety001
comments: true
date: 2012-05-15 16:26:25+00:00
layout: post
slug: php-ip2long-has-bug
title: PHP的ip2long有bug，请慎用
wordpress_id: 2116
tags:
- 编程语言
---

转自：http://www.php100.com/html/webkaifa/PHP/PHPyingyong/2009/0927/3349.html

先看看下边这段PHP代码。这段使用ip2long函数，对同一个IP进行转换。当然，也有人认为58.99.011.1和058.99.011.1算不上合法的

IP，那就Return，此文对你没有帮助。

为什么要使用带前导零的ip：为了在数据库中查询，这个可以在IP库中定位到ip所对应的位置信息。虽然没有整型的IP查询效率高，但毕竟直观啊。

```
echo ip2long('58.99.11.1'),"<br/>";   //输出是 979569409  
echo ip2long('58.99.011.1'),"<br/>";  //输出是 979568897  
echo ip2long('058.99.11.1'),"<br/>";  //输出是空  

echo ip2long('58.99.11.1'),"<br/>";   //输出是 979569409
echo ip2long('58.99.011.1'),"<br/>";  //输出是 979568897
echo ip2long('058.99.11.1'),"<br/>";  //输出是空
```

在PHP 4.x,5.x中, 有前导零的ip转换的结果都不正确。

解决办法，使用写自己的函数：
```
function myip2long($ip){  
   $ip_arr = split('\.',$ip);  
   $iplong = (16777216 * intval($ip_arr[0])) + (65536 * intval($ip_arr[1])) + (256 * intval($ip_arr[2])) + intval($ip_arr[3]);  
   return $iplong;  
}
```
