---
author: ety001
comments: true
date: 2012-03-09 14:09:39+00:00
layout: post
slug: use-c-to-solve-the-problem-that-using-mv-to-replace-rm
title: 用C语言解决mv替换rm
wordpress_id: 2004
tags:
- 编程语言
---

昨天用shell脚本实现了（[http://www.domyself.me/archives/use-mv-replace-rm-without-params/](http://www.domyself.me/archives/use-mv-replace-rm-without-params/)），把rm替换为mv，今天我又尝试了下写个简单的C程序来实现，也顺便练习下vim写代码，gcc编译。直接贴代码，不废话~

```
#include <stdio.h>
#include <string.h>
#define LANG 1000
char *file_path = "/home/ety001/.trash/";
int main(int argc, char* argv[])
{
    int i;
    char str[LANG] = "mv ";
    for(i=1;i<argc;i++)
    {
        if(argv[i][0]!='-')
        {
            strcat(str,argv[i]);
            strcat(str," ");
        }
    }
    strcat(str,file_path);
    system(str);
    return 0;
}
```

另外需要注意的是strcat这个函数，之前，第八行一直写的是char* str = "mv "; 然后运行总是报错（段错误），原因就是因为这句如果写成这样，就已经把str指向的空间长度指定的了，这样strcat函数再向这个字符串后面加字符串的时候肯定就会溢出了。详细的说明看这里：[http://topic.csdn.net/t/20030525/20/1832507.html](http://topic.csdn.net/t/20030525/20/1832507.html)，所以说写这种跟指针打交道的代码还是要小心呀。
