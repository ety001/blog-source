---
author: ety001
comments: true
date: 2011-10-08 13:46:37
layout: post
title: PHP读书笔记四
wordpress_id: 1704
tags:
- 编程语言
- 后端
---

1. 数组的声明规则：
（1）数组的名称由一个美元符号开始，第一个字符是字母或下划线，其后是任意数量的字幕，数字或下划线。
（2）在同一个程序中，标量变量和数组变量都不能重名。
（3）数组的名称区别大小写。

2. 通过标示符[]可以直接为数组元素复制，格式如下：
$array_name[key]=value;或者$array_name[]=value;

3. 应用array()函数创建数组，语法如下：
array array([mixed…])
参数mixed的语法为“key=>value”，多个参数mixed用逗号分开，分别定义了索引（key）和值（value）。应用array函数声明数组时，数组下标既可以是数值索引也可以是关联索引。

示例：

```
<?php
	$arr1=array('PHP'=>'php','JAVA'=>'java'); //以字符串作为数组索引，指定关键字，关联数组
	print_r($arr1);
	echo "\n".$arr1['JAVA']."\n";

	$arr2=array('PHP','Java');  //以数字作为数组索引，从0开始，没有指定关键字，数字索引数组
	print_r($arr2);
	echo "\n".$arr2['0']."\n";

	$arr3=array(0=>'PHP',1=>'Java',1=>'domyself.me'); //指定相同的索引，后一个将会覆盖之前的值
	print_r($arr3);
?>
```

```
运行结果：
Array
(
    [PHP] => php
    [JAVA] => java
)

java
Array
(
    [0] => PHP
    [1] => Java
)

PHP
Array
(
    [0] => PHP
    [1] => domyself.me
)
```

4. 遍历数组有三种方法：
（1）用foreach遍历数组
（2）用list()和each()遍历数组
示例：

```
<?php
	$arr=array(0=>'PHP',1=>'VB',2=>'Java',3=>'VC');
	while(list($key,$val)=each($arr)){
		echo "$key=$val\n";
	}
?>
```

**说明：each()返回数组中当前指针指向位置的键名和对应的值，然后移动指针到下一个位置，返回值就是4个元素的关联数组，通过list()语言结构赋给指定的值。**


（3）用for和count()来遍历数组
count($arr)的意思就是$arr的上界。

5. 输出数组两种方法，一种是直接使用print_f()，一种是使用echo语句。前者可以把数组全部输出，包括结构，后者只能输出指定的数组项，还需要借助循环才能全部输出数组。

6. 数组函数
（1）count()统计数组元素个数
（2）向数组添加元素，array_push()把数组当成一个栈，将传入的变量压入该数组的末尾。语法如下：
int array_push(array array,mixed var[,mixed…])
参数array为指定的数组，参数var是压入数组中的值。
建议：使用[]给数组添加元素。
（3）获取数组中最后一个元素，同样是把数组当作了栈，函数是：array_pop()。
（4）删除数组中重复元素，array_unique()
（5）获取数组中指定元素的键名，array_search()，语法如下：
mixed array_search(mixed needle,array haystack[,bool strict])
参数needle指定在数组中搜索的值，如果needle是字符串，则在搜索needle的值时是区分字符串的大小写的。参数haystack指定被搜索的数组。参数strict为可选参数，如果值为true，还将在haystack中检查needle的类型。（该函数区分大小写）
注意：使用array_search()函数查询数组中的指定元素时，如果查询的元素在数组中多次出现，那么该函数只返回第一个匹配的键名，如果想返回所有的，用array_keys()。


```
补充：
其他的创建数组的方法
array_combine()===以一个数组为关键字，另一个数组为值创建新数组
array_fill()===用值填充一个数组
array_pad()===用一个值把数组填充到指定长度
compact()===创建包含变量及其值的数组
range()===创建一个包含一定范围内的元素的数组
```
