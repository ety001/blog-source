---
author: ety001
comments: true
date: 2011-03-10 16:41:30+00:00
layout: post
title: 关于if和else的一点心得及程序调试的方法
wordpress_id: 1148
tags:
- 编程语言
---

今天上C++的第一堂实验课，老师为了了解一下我们之前学的C语言怎么样，出了一到程序题，让我们编一下。题目很简单就是给定一元二次方程ax^2+bx+c=0的三个系数，然后给出结果，并能够循环执行，主函数只负责输入参数，要至少有一个函数，本人很快就理清思路开始编写，很快写完了，并且编译了，下面的就是我的第一遍源代码（VC编译环境）：

```
#include <stdio.h>
#include <math.h>
void charge(float a,float b,float c);            //判断过程
void runorstop();		//是否继续运行
int run = 1;		//继续运行的标志，1为继续运行，0为停止运行
void main()
{
	while(run == 1)
	{
		float a,b,c;
		printf("请输入a\n");
		scanf("%f",&a);
		printf("请输入b\n");
		scanf("%f",&b);
		printf("请输入c\n");
		scanf("%f",&c);
		charge(a,b,c);//进行运算
	}
}
void runorstop()
{
	printf("是否还要继续运行程序，“是”请输入“1”，“否”请输入“0”\n");
	scanf("%d",&run);
}
void charge(float a,float b,float c)
{
	float x1,x2;
	float d;		//daite
	if(a == 0)
	{
		if(b == 0)
		{
			if(c == 0)
			{
				printf("方程有无穷个解！\n\n");
				runorstop();
			}
			else
			{
				printf("a,b同时为0，方程错误！");
				runorstop();
			}
		}
		else
		{
			x1 = -c/b;
			printf("方程的解为 x = %f",x1);
			runorstop();
		}
	}
	else
	{
		d = b*b - 4*a*c;
		if(d>0)
		{
			x1 = (-b+sqrt(d))/(2*a);
			x2 = (-b-sqrt(d))/(2*a);
			printf("方程的两个根分别是：\n");
			printf("x1 = %f , x2 = %f\n",x1,x2);
			runorstop();
		}
		if(d=0)//  《《---这里就是错误的出现的地方
		{
			x1=-b/(2*a);
			printf("方程有两个相同的根：%f\n\n",x1);
			runorstop();
		}
		if(d<0)
		{
			printf("方程没有实数解！\n\n");
			runorstop();
		}
	}
}
```

但是在运行的时候，发现输入完a,b,c三个数据后，程序不停的出现 【是否还要继续运行程序，“是”请输入“1”，“否”请输入“0”】 这个提示信息，看来可能是while循环导致的不停的循环，先注释掉，然后再运行，输入完三个数后什么也没显示，程序就结束了。

我前前后后看了好几遍也没找到问题，第一次猜测是数据输入有些问题，于是在第16行之后加了一行printf输出一下a,b,c三个值，编译运行，成功输出，证明输入正确。于是又猜测可能是数据没有被带入到函数中去，于是又在28行后面插入输出语句进行测试（这里注意，一定要把printf放到后面，不能放到27或者28行前面，因为27，28行是声明的局部变量，局部变量的声明必须要放在这个函数的头部，这是老师说的）。测试结果正常，证明数据已经能进入函数。由于我输入测试的数据，应该进入68行的那个花括号，所以就在那附近检查，终于发现了问题，原来是一时打字疏忽，把62行的判断相等双等号打成了赋值单等号。这样一来，就成了把0赋值给d，而if(0)肯定不执行花括号里的内容，所以程序就跳过了所有的if，结果就是什么都不会显示。于是我想到了，如果当时使用了else的话，那么问题很快就能找到，因为一个判断不正确，他会跳转到else的花括号，这样就等于所以了检查范围。既然找到了问题，那么把之前注释掉的while循环改过来，然后把=加上，编译运行成功了。

附：由于机房使用的是VC，而我现在写这篇文章的时候是在我的本本的ubuntu系统下，于是又出现了点小插曲，就是sqar()函数在编译时，提示错误信息：

```
/tmp/ccszYPUG.o: In function `charge':
1.c:(.text+0x1a6): undefined reference to `sqrt'
1.c:(.text+0x1cc): undefined reference to `sqrt'
collect2: ld returned 1 exit status
```

我在网上搜索了一下，找到了下面的这个资料，先收了，以备后用：

```
-l参数和-L参数
-l参数就是用来指定程序要链接的库，-l参数紧接着就是库名，那么库名跟真正的库文件名有什么关系呢？就拿数学库来说，他的库名是m，他的库文件名是libm.so，很容易看出，把库文件名的头lib和尾.so去掉就是库名了
好了现在我们知道怎么得到库名，当我们自已要用到一个第三方提供的库名字libtest.so，那么我们只要把libtest.so拷贝到/usr/lib里，编译时加上-ltest参数，我们就能用上libtest.so库了（当然要用libtest.so库里的函数，我们还需要与libtest.so配套的头文件）
放在/lib和/usr/lib和/usr/local/lib里的库直接用-l参数就能链接了，但如果库文件没放在这三个目录里，而是放在其他目录里，这时我们只用-l参数的话，链接还是会出错，出错信息大概是：“/usr/bin/ld: cannot find -lxxx”，也就是链接程序ld在那3个目录里找不到libxxx.so，这时另外一个参数-L就派上用场了，比如常用的X11的库，它在/usr/X11R6/lib目录下，我们编译时就要用-L/usr/X11R6/lib -lX11参数，-L参数跟着的是库文件所在的目录名。再比如我们把libtest.so放在/aaa/bbb/ccc目录下，那链接参数就是-L/aaa/bbb/ccc -ltest
另外，大部分libxxxx.so只是一个链接，以RH9为例，比如libm.so它链接到/lib/libm.so.x，/lib/libm.so.6又链接到/lib/libm-2.3.2.so，
如果没有这样的链接，还是会出错，因为ld只会找libxxxx.so，所以如果你要用到xxxx库，而只有libxxxx.so.x或者libxxxx-x.x.x.so，做一个链接就可以了ln -s libxxxx-x.x.x.so libxxxx.so
手工来写链接参数总是很麻烦的，还好很多库开发包提供了生成链接参数的程序，名字一般叫xxxx-config，一般放在/usr/bin目录下，比如
gtk1.2的链接参数生成程序是gtk-config，执行gtk-config --libs就能得到以下输出"-L/usr/lib -L/usr/X11R6/lib -lgtk -lgdk -rdynamic
-lgmodule -lglib -ldl -lXi -lXext -lX11 -lm"，这就是编译一个gtk1.2程序所需的gtk链接参数，xxx-config除了--libs参数外还有一个参数是--cflags用来生成头文件包含目录的，也就是-I参数，在下面我们将会讲到。你可以试试执行gtk-config --libs --cflags，看看输出结果
现在的问题就是怎样用这些输出结果了，最笨的方法就是复制粘贴或者照抄，聪明的办法是在编译命令行里加入这个`xxxx-config --libs --cflags`，比如编译一个gtk程序：gcc gtktest.c `gtk-config --libs --cflags`这样就差不多了。注意`不是单引号，而是1键左边那个键。
```

最后还是找到了，需要加-lm参数，编译指令如下：

```
gcc 1.c -o a -lm
```

这样就编译生成名字为a的程序了，但是运行的时候全是乱码，这个问题好解决，因为在VC下编写的源代码文件都是GBK格式的，只需要在ubuntu下面用leafpad打开源文件并且另存为UTF-8再编译运行就可以了。
