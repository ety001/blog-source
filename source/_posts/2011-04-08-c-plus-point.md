---
author: ety001
comments: true
date: 2011-04-08 12:33:28+00:00
layout: post
title: c++中指针数组的研究
wordpress_id: 1255
tags:
- 编程语言
---

上次的C++实验课第二个题，我一直在调试，今天终于搞出来了。下面我把整个过程写一写。
题目：


【题目2】编写程序，输入十个国家名称用字符指针数组实现排序输出。

【要求】
    ① 程序的功能是实现字符串的排序输出，例如，输入10个国家的名字分别是"China","USA","Australia","Austria","Brazil","Japan","England","Canada","Italy","France"，则排序后输出的结果为
    "Australia","Austria","Brazil","Canada","China","England","France","Italy","Japan","USA"
    ② 设计一个独立的函数ccmp，实现相应的功能
    ③ 函数调用时，参数通过字符指针数组传递
    【提示】
    ① ccmp函数可按如下方式定义：
    void ccmp(char * a[]);;
    其中，字符指针数组a中的指针分别指向10个国家的名称字符串
    ② 程序可用中的 `strcmp(char *s1,char * s2)` 函数对两个字符串的先后顺序进行判定，当s1<s2时，返回值<0，当s1=s2时，返回值=0 当s1>s2时，返回值>0



我写的成品代码如下：

```
#include<iostream>
#include<string.h>
using namespace std;
void ccmp(char *a[]);
int main()
{
	int i=0;
	char* num[10]; //申请一个指针数组
	char a[][10]={"China","USA","Australia","Austria","Brazil","Japan","England","Canada","Italy","France"};//初始字符串

	for(i=0;i<10;i++)num[i]=a[i];//把字符串数组发给一个指针数组

	ccmp(num);

	for(i=0;i<10;i++)cout<<num[i]<<endl;//输出结果

	return 0;
}
void ccmp(char* a[])
{
	char *temp;
	for(int i=0;i<9;i++)
	{
		for(int j=0;j<9-i;j++)
		{
			if(strcmp(a[j],a[j+1])>0)
			{
				temp=a[j];
				a[j]=a[j+1];
				a[j+1]=temp;
			}
		}
	}
}
```

**出现的第一个问题是**，对于指针数组的理解刚开始有些模糊，不过现在已经算是明白了。先说一下什么是指针？指针就是一个存储地址的变量。比如说我们申请一个存储整型数据的空间来存储整数，那么这个空间的地址就是一个整型指针，申请方法如下：

```
//这里申请了一个整型指针，我习惯把*靠近int书写，这样更容易理解，这个下面会讲到
int* p;
int a=6;
p=&a;
```

上面这个小段程序，我们可以把变量a理解为一个小房子，这个小房子建设在内存里，而要找到这个房子需要有一个地址，这个地址就是平时我们所说的内存地址，而p也同样也是一个小房子，只是这个房子很特殊，只存储其他普通房子的地址，也就是变量a的地址。指针一直困惑人的地方就是*p和p到底是什么意思？其实*p在内存里面是没有空间的，也就是说*p根本不是房子，p才是房子，就好比一把打开房门的钥匙，只有*和p组合在一起成为*p，才能读取出p中存放地址所指向空间内的内容（这里就是数字6）。那为什么申请普通变量的时候是`int a;`而申请指针变量的时候是`int *p`呢？这里a的地位难道和*p不是一回事吗？很显然这不是一回事，但是就是这种书写导致了初学者的混淆，这也是为什么我习惯写成`int* p;`了，也就是说`int`和`int*`不是一回事，而`a`和`p`的地位是一样的，都是一个变量，只不过p只能用来存储地址。不知道我罗嗦这么多，大家是否看懂了，不过至少我现在明白了，嘿嘿～

那说完指针，就来看看指针数组。所谓的指针数组，就是一组变量每个变量都是用来并且只能用来存储地址的。在我写的那段程序中，用来存储全部字符串的数组`a[][]`，第一维维数其实就是字符串的个数，第二维的维数即是每个字符串的最大字符个数。我出现的第一个错误就是在这里出现的。依照上面的分析，那么a[0]的值就是第一个字符串“China”的首字符的地址，如果用cout输出a[0]的话，得到的输出结果就是“China”，因此程序写出来的第一遍中没有那个num指针数组。我在第13行直接写的是  ccmp(a[]);  然后就是一系列的错误，后来发现不能这样写，而是应该把这些字符串的首字母的地址给一个指针数组，然后用这个指针数组进行传值。于是就有了num指针数组。但是在使用num时，又出现了很多错误，但是错误的本质都是相同的，都是出错在赋值运算上。**也就是说从一个变量到另一个变量的赋值时出错，原因就是没有搞清楚你正在使用变量的类型，它里面存储的东西的类型，以及将要用来承接用的变量的类型和它能存储什么样的数据。前前后后调试了很多遍，把每一个变量的每种情形都搞明白了，这里的错误也就解决了。**

**第二个问题出在了strcmp()的使用上**。最开始第26行，我写的是if(strcmp(a[j],a[j+1]))，也就是没有那个">0"。依照题目的意思只要a[j]>a[j+1]，那么strcmp的返回值就是大于0的值，那么在if中就是真，但是运行的时候，排序就是不对。这里我插一句我是如何发现问题出现在这里的，下面的代码就是我的调试代码（只粘贴了ccmp函数），注意第8、11、12、13、17行的输出代码。

```
void ccmp(char* a[])
{
	char *temp;
	for(int i=0;i<9;i++)
	{
		for(int j=0;j<9-i;j++)
		{
			cout<<"wai:"<<strcmp(a[j],a[j+1])<<endl;
			if(strcmp(a[j],a[j+1])>0)
			{
				cout<<strcmp(a[j],a[j+1])<<endl;
				cout<<"a[j]"<<a[j]<<"::a[j+1]"<<a[j+1]<<endl;
				cout<<j<<endl;
				temp=a[j];
				a[j]=a[j+1];
				a[j+1]=temp;
				cout<<"a[j]"<<a[j]<<"::a[j+1]"<<a[j+1]<<endl;
			}
		}
	}
}
```

最初的时候，我只是添加了第12行的代码，输出了每次循环体中的a[j]和a[j+1]，观察结果发现i=0时的所有循环结果输出，“China”字符串一直在a[j]的位置，也就是说它一直都是被当作最大值的。为了验证想法，于是我又添加了第13和17行，又输出了一遍，我的判断被验证了，那么问题就出在了if的判断条件上了。我又添加第11行的代码，发现i=0时，这里输出的全是-1，然后我又添加了第9行代码，继续运行，结果使我很疑惑，因为我的概念搞混了。`我在写程序的时候，想成了大于0的数代表真，小于等于0的数代表假。直到我开始写这篇文章了，我才反应过来，非0值都是真，只有0才是假（我为我自己学的不牢固感到悲哀啊……=_=）。`问题找到，加上">0"就解决了。

以上即为我的整个实验过程，希望对各位正在学习C的看客有所帮助吧。有理解不到位的地方，还请高人指点一二，小弟不胜感激～
