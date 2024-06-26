---
author: ety001
comments: true
date: 2013-09-01 16:35:15
layout: post
slug: flexible-array
title: 柔性数组
wordpress_id: 2440
tags:
- 理论
- 编程语言
---

转自：http://hi.baidu.com/piaoshi111/item/9ffdb6ddbe2ca24adcf9be38

也许你从来没有听说过柔性数组（flexible array）这个概念，但是它确实是存在的。
C99中，结构中的最后一个元素允许是未知大小的数组，这就叫做柔性数组成员，但结
构中的柔性数组成员前面必须至少一个其他成员。 柔性数组成员允许结构中包含一个大小可
变的数组。sizeof返回的这种结构大小不包括柔性数组的内存。包含柔性数组成员的结构用
malloc ()函数进行内存的动态分配，并且分配的内存应该大于结构的大小，以适应柔性数组
的预期大小。<!-- more -->
柔性数组到底如何使用呢？看下面例子：
typedef struct st_type
{
int i;
int a[0];
}type_a;
有些编译器会报错无法编译可以改成：
typedef struct st_type
{
int i;
int a[];
}type_a;
这样我们就可以定义一个可变长的结构体，用 sizeof(type_a)得到的只有 4，就是
sizeof(i)=sizeof(int)。那个 0 个元素的数组没有占用空间，而后我们可以进行变长操作了。通
过如下表达式给结构体分配内存：
type_a *p = (type_a*)malloc(sizeof(type_a)+100*sizeof(int));这样我们为结构体指针 p 分配了一块内存。用 p->item[n]就能简单地访问可变长元素。
但是这时候我们再用 sizeof（*p）测试结构体的大小，发现仍然为 4。是不是很诡异？我们
不是给这个数组分配了空间么？
别急，先回忆一下我们前面讲过的“模子” 。在定义这个结构体的时候，模子的大小就
已经确定不包含柔性数组的内存大小。柔性数组只是编外人员，不占结构体的编制。只是说
在使用柔性数组时需要把它当作结构体的一个成员，仅此而已。再说白点，柔性数组其实与
结构体没什么关系，只是“挂羊头卖狗肉”而已，算不得结构体的正式成员。
需要说明的是：C89不支持这种东西，C99把它作为一种特例加入了标准。但是，C99
所支持的是 incomplete type，而不是 zero array，形同 int item[0];这种形式是非法的，C99支
持的形式是形同 int item[];只不过有些编译器把 int item[0];作为非标准扩展来支持，而且在
C99发布之前已经有了这种非标准扩展了，C99发布之后，有些编译器把两者合而为一了。
当然，上面既然用 malloc函数分配了内存，肯定就需要用 free函数来释放内存：
free(p);
经过上面的讲解，相信你已经掌握了这个看起来似乎很神秘的东西。不过实在要是没
掌握也无所谓，这个东西实在很少用。

