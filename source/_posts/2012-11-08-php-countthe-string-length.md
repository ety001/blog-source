---
author: ety001
comments: true
date: 2012-11-08 02:35:08+00:00
layout: post
slug: php-countthe-string-length
title: php判断字符长度
wordpress_id: 2211
tags:
- 编程语言
---

这个方法很多。 记录一个简单的。

mb_strlen($str, 'GBK');

缺点是要安装mb库。

不过这个还是有部分问题待解决。

GB码编码规则是这样的：每个汉字由两个字节构成，第一个字节的范围从0XA1－0XFE，共96种。第二个字节的范围分别为0XA1－0XFE，共96种。利用这两个字节共可定义出 96 * 96＝8836种汉字。实际共有6763个汉字。
BIG5码编码规则是这样的：每个汉字由两个字节构成，第一个字节的范围从0X81－0XFE，共126种。第二个字节的范围分别为 0X40－0X7E，0XA1－0XFE，共157种。也就是说，利用这两个字节共可定义出 126 * 157＝19782种汉字。这些汉字的一部分是我们常用到的，如一、丁，这些字我们称为常用字，其BIG5码的范围为0XA440－0XC671，共 5401个。较不常用的字，如滥、调，我们称为次常用字，范围为 0XC940－0XF9FE，共7652个，剩下的便是一些特殊字符。

安全点的方法。

function StrLenW($str)
{
$count = 0;
$len = strlen($str);
for($i=0; $i<$len; $i++,$count++)
if(ord($str[$i])>=128)
$i++;
return $count;
}

采自[八点半的阿布](http://www.830abu.com/)

