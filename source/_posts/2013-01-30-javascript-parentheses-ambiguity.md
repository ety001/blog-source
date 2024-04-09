---
author: ety001
comments: true
date: 2013-01-30 05:17:40
layout: post
slug: javascript-parentheses-ambiguity
title: Javascript小括号“()”的多义性
wordpress_id: 2300
tags:
- 前端
---

今天研究了下匿名函数的自执行，对于匿名函数为什么要用括号括起来，甚是不解，于是做了下实验，如下：

    function(){
        alert(1);
    }
    ();

另一组：

    var a = function() {
        alert(1);
    }
    a();

第一组在执行的时候是会报错的，而对匿名函数加上小括号，或者是赋给一个变量后，再调用就不会再有错误，这就可以看出来，在匿名函数自执行的时候，匿名函数外的小括号的作用其实是进行了一次运算。另外function是一个表达式，这一点在犀牛书的第五章一开始有说到。

关于括号的运算的意义在这篇博文里面的第五点也有提到：[http://www.cnblogs.com/snandy/archive/2011/03/08/1977112.html](http://www.cnblogs.com/snandy/archive/2011/03/08/1977112.html)。

