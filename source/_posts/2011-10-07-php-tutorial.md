---
author: ety001
comments: true
date: 2011-10-07 16:37:53
layout: post
title: PHP读书笔记二
wordpress_id: 1699
tags:
- 编程语言
- 后端
---

由于已经有了一定的基础，所以我现在写的这个php笔记会跳过很多我已经很熟练的东西，只记录我不熟悉的东西。

1. foreach循环（擅长处理数组，是遍历数组的一种简单方法）
语法：

```
foreach(array_expression as $value)
	statement
或
foreach(array_expression as $key=>$value)
	statement
说明：foreach语句将遍历数组array_expression，每次循环时，将当前数组中的值赋给$value（或$key和$value），同时数组指针向后移动，直到遍历结束。
```

**说明：除非数组是被引用，否则foreach所操作的是指定数组的一个拷贝，而不是该数组本身。因此数组指针不会被each()结构改变，对返回的数组单元的修改也不会影响原数组。不过原数组的内部指针的确在处理数组的过程中向前移动了。假定foreach循环运行到结束，原数组的内部指针将指向数组的结尾。另外foreach不支持用“@”来禁止错误信息。**

2. break语句跳出循环体，可以终止当前的循环，即还没有循环到的地方不会再执行（包括while，do…while，for，foreach和switch），另外break还可以跳出几重循环，给是为“break n;”。
示例：

```
<?php
while(1){
	for(;;){
		for($i=1;$i<=4;$i++){
			echo $i."\t";
			if($i==3){
				echo "<p>变量\$i等于3，跳出第一重循环<p>";
				break 1;
			}
		}
		for($j=1;$j<5;$j++){
			echo $j."\t";
			if($j==4){
				echo "<p>变量\$j等于4，跳出最外重循环<p>";
				break 3;
			}
		}
	}
}
?>
```

**示例说明：当i=3时，跳出一重循环，当j=4时跳出3重循环，即跳出所有的循环。**

continue语句跳出本次循环，即本次循环体不执行，但是不跳出当前循环，不会影响下次循环的执行。

3. 函数名称不区分大小写（常量和变量区分大小写）。如果误定义了两个不同大小写的重名函数，那么程序将中止运行。
还有一些函数命名有通用规则，如获取数值用get开头，然后跟上要获取的对象名字；设置数则用set开头，然后跟上要设置的对象的名字。
关于return：因为return()是语言结构而不是函数，所以仅在参数包含表达式时才需要用括号括起来。当返回一个变量时通常不用括号，也不建议用，这样可以减少php的负担。
**当用引用返回值时，永远不要使用括号。只能通过引用返回变量，而不是语句的结果。如果使用“return($a);”，其返回的不是一个变量，而是表达式($a)的值，当然，此时该值也正是$a的值。（暂时不懂……）**

4. 变量函数不能用于语言结构，例如，each()，print()，unset()，isset()，empty()，include()，require()以及类似的语句，它需要使用自己的外壳函数来将这些结构用作变量函数。

5. 转义和还原字符串：addslashes()和stripslashes()。
addslashes()可以给字符串加入斜线“\”，然后对指定字符串中的字符进行转义。它可以转义的字符包括单引号“'”、双引号“"”、反斜线”\“，NULL字符”0“。常用的地方就是在生成SQL语句时，对SQL语句中的部分字符进行转义。
注意：所有数据在插入数据库之前，有必要应用addslashes()进行转义，以免特殊字符在插入数据库的时候出现错误。
addcslashes()和stripcslashes()函数可以对指定范围内的字符串进行转义和还原。语法如下：
string addcslashes(string str,string charlist)
string stripcslashes(string str)

6. substr()函数从字符串中按照指定位置截取一定长度的字符。如果使用一个正数作为子串起点，来调用这个函数，将得到从起点到字符串结束的这个字符串；如果使用一个负数作为起点，将得到一个原字符串尾部的一个子串，字符个数等于给定负数的绝对值。语法如下：
string substr(string str,int start[,int length])
str为指定字符串，start开始截取的位置，length指定了截取字符的个数，若为负数，则表示取到倒数第length个字符。

例子，现在有$str='abcde'，遂有以下的值：

```
substr($str,0,3)=='abc'
substr($str,-3,3)=='cde'//从倒数第3个字符往后取3个字符
substr($str,0,-3)=='ab'//从第0个字符开始往后取，一直取到倒数第3个字符前一个字符为止。
substr($str,1,3)=='bcd'
```

7. strlen()获取字符串长度。

8. explode()用来分割字符串，语法：
array explode(string separator,string str[,int limit])
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
参数
说明
</tr>
<tr >

<td >separator
</td>

<td >必要参数，用于指定分隔符。如果separator为空字符串""，explode()函数将返回false。如果separator所包含的值在str中找不到，那么explode()函数将返回包含str单个元素的数组
</td>
</tr>
<tr >

<td >str
</td>

<td >必要参数，指定将要被分割的字符串
</td>
</tr>
<tr >

<td >limit
</td>

<td >可选参数，如果设置了limit参数，则返回的数组中最多包含limit个元素，而最后的元素将包含string的剩余部分。如果limit参数是负数，则返回除了最后的-limit个元素外的所有元素
</td>
</tr>
</tbody>
</table>

implode()可以用来将数组中的元素合并成字符串，语法如下：
string implode(string glue,array pieces)
glue是字符串类型，用于指定分隔符，pieces是数组类型，即要被合并的数组。
