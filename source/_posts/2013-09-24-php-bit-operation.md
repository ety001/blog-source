---
author: ety001
comments: true
date: 2013-09-24 16:21:09+00:00
layout: post
slug: php-bit-operation
title: PHP位运算详细说明
wordpress_id: 2472
tags:
- 编程语言
- 理论
---

转自：<a href="http://www.oschina.net/code/snippet_856191_23751">http://www.oschina.net/code/snippet_856191_23751</a>

在实际应用中可以做用户权限的应用
我这里说到的权限管理办法是一个普遍采用的方法，主要是使用到”位运行符”操作，& 位与运算符、| 位或运行符。参与运算的如果是10进制数，则会被转换至2进制数参与运算，然后计算结果会再转换为10进制数输出。
它的权限值是这样的

```
2^0=1，相应2进数为”0001″(在这里^我表示成”次方”，即：2的0次方，下同)
2^1=2，相应2进数为”0010″
2^2=4，相应2进数为”0100″
2^3=8，相应2进数为”1000″
```

要判断一个数在某些数范围内就可以使用 & 运算符(数值从上面的表中得来)
如：7=4|2|1　(你也可以简单理解成7=4+2+1)
用 & 来操作，可以知道7&4、7&2、7&1都是真的，而如果7&8则是假的
&、|　不熟悉的就要去查查手册，看看是怎么用的了
下面来看例子吧：

```
// 赋予权限值-->删除：8、上传：4、写入：2、只读：1
define(“mDELETE”,8);
define(“mUPLOAD”,4);
define(“mWRITE”,2);
define(“mREAD”,1);
//vvvvvvvvvvvvv使用说明vvvvvvvvvvvvv
//部门经理的权限为(假设它拥有此部门的所有权限)，| 是位或运行符，不熟悉的就查查资料
echo mDELETE|mUPLOAD|mWRITE|mREAD ,'';// 相当于是把上面的权限值加起来：8+4+2+1=15
// 设我只有 upload 和 read 权限，则
echo mUPLOAD|mREAD ,'';//相当于是把上传、只读的权限值分别相加：4+1=5
/*
*赋予它多个权限就分别取得权限值相加，又比如某位员工拥有除了删除外的权限其余都拥有，那它的权限值是多少?
*应该是：4+2+1＝7
*明白了怎么赋值给权限吧?
*/
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//判断某人的权限可用，设权限值在$key中
/*
*判断权限用&位与符，
*/
$key = 13;//13＝8+4+1
if($key & mDELETE) echo '有删除权限'; //8
if($key & mUPLOAD) echo '有上传权限'; //4
$a=$key & mWRITE; echo '有写权限'.$a; //无此权限
if($key & mREAD) echo '有读权限'; //1
?>
```

　　OK，权限分值的这其中一个算法就是这样的，可以说是简单高效。也不知大家明白没有，不明白也没关系，记住例子就行了。前提就是做好权限值的分布，即那个1、2、4、8、16….(这里还有个顺序问题，越高级的权限就要越高的权限值，比如上面的例子所演示的删除权限)。有了权限分布表就可以确定给某个人什么权限了，你简单的理解成要哪个权限就加上相应的权限值吧。
　　这个方法很好用的，缺点就是如果权限分布得细的话，那么权限值会越来越大，你自己想想，2的几次方、如果所有的权限都要则是全部相加。不过对于一般的权限来说这个已经足够了。

下面是些简单应用举例

(1) 判断int型变量a是奇数还是偶数

a&1 = 0 偶数

a&1 = 1 奇数

(2) 取int型变量a的第k位 (k=0,1,2……sizeof(int))，即a>>k&1

(3) 将int型变量a的第k位清0，即a=a&~(1<

<>

(4) 将int型变量a的第k位置1， 即a=a|(1<

<>

(5) int型变量循环左移k次，即a=a<>16-k (设sizeof(int)=16)

(6) int型变量a循环右移k次，即a=a>>k|a<<16-k (设sizeof(int)=16)

(7)整数的平均值

对于两个整数x,y，如果用 (x+y)/2 求平均值，会产生溢出，因为 x+y 可能会大于INT_MAX，但是我们知道它们的平均值是肯定不会溢出的，我们用如下算法：

int average(int x, int y) //返回X,Y 的平均值

{

return (x&y)+((x^y)>>1);

}

(8)判断一个整数是不是2的幂,对于一个数 x >= 0，判断他是不是2的幂

boolean power2(int x)

{

return ((x&(x-1))==0)&&(x!=0)；

}

(9)不用temp交换两个整数

void swap(int x , int y)

{

x ^= y;

y ^= x;

x ^= y;

}

(10)计算绝对值

int abs( int x )

{

int y ;

y = x >> 31 ;

return (x^y)-y ; //or: (x+y)^y

}

(11)取模运算转化成位运算 (在不产生溢出的情况下)

a % (2^n) 等价于 a & (2^n – 1)

(12)乘法运算转化成位运算 (在不产生溢出的情况下)

a * (2^n) 等价于 a<< n

(13)除法运算转化成位运算 (在不产生溢出的情况下)

a / (2^n) 等价于 a>> n

例: 12/8 == 12>>3

(14) a % 2 等价于 a & 1

(15) if (x == a) x= b;

　　 else x= a;

　　 等价于 x= a ^ b ^ x;

(16) x 的 相反数 表示为 (~x+1)

在32位系统上不要右移超过32位,不要在结果可能超过 32 位的情况下左移
