---
author: ety001
comments: true
date: 2011-04-19 14:14:43+00:00
layout: post
title: 关于cin.getline和回文检测程序
wordpress_id: 1291
tags:
- 编程语言
---

今天接触了一些以前没有看到的一些东西，一个是关于cin.getline，另一个是回文检测程序的算法。
先说一下cin.getline吧，以下内容来自百度百科（这个百科真是好东西）。
此函数是按行读取,其语法为:cin.getline(字符指针,字符个数N,结束符);
功能是：一次读取多个字符(包括空白字符），直到读满N-1个，或者遇到指定的结束符为止(默认的是以'\n'结束)。
例:

```
#include <iostream>
using namespace std;
void main()
{
　　char a[10];
　　cin.getline(a,10);
　　for(int i=0;i<10;i++)
　　cout<<a[i]<<" ";
}
```

输入:1234567890123

输出:1 2 3 4 5 6 7 8 9 _ （第10位存放字符串结束符'\0'）

第二个就是来说说回文检测程序吧，只贴程序代码吧，很经典的。

```
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#define MAXN 5000+10
char buf[MAXN],s[MAXN];
int p[MAXN];

int main()
{
	int n,m=0,max=0,x,y;
	int i,j;
	fgets(buf,sizeof(s),stdin);
	n=strlen(buf);
	for(i=0;i<n;i++)
		if(isalpha(buf[i]))
		{
			p[m]=i;
			s[m++]=toupper(buf[i]);
		}
	for(i=0;i<m;i++)
	{
		for(j=0;i-j>=0 && i+j<m; j++)
		{
			if(s[i-j]!=s[i+j])break;
			if(j*2+1>max){max=j*2+1;x=p[i-j];y=p[i+j];}
		}
		for(j=0;i-j>=0 && i+j+1<m;j++)
		{
			if(s[i-j]!=s[i+j+1])break;
			if(j*2+2>max){max=j*2+2;x=p[i-j];y=p[i+j+1];}
		}
	}
	for(i=x;i<=y;i++)
		printf("%c",buf[i]);
	printf("\n");			
	return 0;
}
```

最后，我要推荐一本书《算法竞赛入门教程》，这本书今下午大体翻过后，接着就上网买下来了，值得程序员收藏。
<table cellpadding="0" bgcolor="#FFFFFF" style="width:290px;border: 1px solid #E6E6E6;" cellspacing="0" ><tr >
<td align="center" rowspan="2" >

[![](http://image.taobao.com/bao/uploaded/http://img07.taobaocdn.com/bao/uploaded/i7/T1VwloXlNCXXaht4s8_070634.jpg_sum.jpg)](http://s.click.taobao.com/t_8?e=7HZ6jHSTZTcsuN3f%2Fycx4x%2FzX7fNAKa1MnukujfkcdF%2B&p=mm_13275160_0_0)

</td>
<td colspan="2" >[算法竞赛入门经典](http://s.click.taobao.com/t_8?e=7HZ6jHSTZTcsuN3f%2Fycx4x%2FzX7fNAKa1MnukujfkcdF%2B&p=mm_13275160_0_0)
</td></tr><tr >
<td nowrap="nowrap" > 19.4元 
</td>
<td width="100px" nowrap="nowrap" >[![](http://img.alimama.cn/images/tbk/cps/fgetccode_btn.gif)](http://s.click.taobao.com/t_8?e=7HZ6jHSTZTcsuN3f%2Fycx4x%2FzX7fNAKa1MnukujfkcdF%2B&p=mm_13275160_0_0)
</td></tr></table>

