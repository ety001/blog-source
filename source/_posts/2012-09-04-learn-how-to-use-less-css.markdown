---
author: ety001
comments: true
date: 2012-09-04 04:41:03+00:00
layout: post
slug: learn-how-to-use-less-css
title: 学会如何使用LESS来征服CSS
wordpress_id: 2178
tags:
- 前端
---

转自：[http://www.qianduanzu.com/2012042438.html](http://www.qianduanzu.com/2012042438.html)

今天很有雄心壮志，决定将SeaJS、Coffee、LESS都搞定。回到家后在电脑前面做了一个下午加一个晚上，悲催的发现，只解决了LESS。呃，先将LESS总结一遍。

LESS的目标是简写CSS。用编程的观点去看待CSS，以OO的思想看待CSS，将常量、函数、命名空间等概念引入，使很松散的页面样式形成一个个对象，方便开发和维护。当然在写的时候要注意技巧，不然生成的CSS将会有大量的冗余代码。所以只建议CSS高手进阶用，初级CSSer最好还是先把CSS写熟了再说吧！

[![CSS LESS](http://www.qianduanzu.com/wp-content/uploads/2012/04/11-300x180.jpg)](http://www.qianduanzu.com/wp-content/uploads/2012/04/11.jpg)



**变量和常量（Variables）**

以@开始即可，只能定义属性值。注意变量覆盖以及作用域的问题。例如：
@blue: #5b83ad; //常量
@light_blue: @nice-blue + #222; //经过计算的常量
@highlight: “blue”; #header { color: @@highlight;}//常量名为常量

**<!-- more -->函数**

将每个类都看成一个函数，即可以让别的函数调用和传参。并且能在函数中定义子函数。








[源代码](http://www.qianduanzu.com/2012042438.html#)[复制](http://www.qianduanzu.com/2012042438.html#)[打印](http://www.qianduanzu.com/2012042438.html#)[?](http://www.qianduanzu.com/2012042438.html#)









  1. .border{border: 2px solid #ccc; border-radius: 4px;}


  2. .header {.border;}


  3.

  4. //调用时一定要传参数


  5. .border(@width, @color, @radius){border: @width solid @color; border-radius: @radius;}


  6. .header{.border(2px, #ccc, 4px);}


  7.

  8. //带默认参数


  9. .border(@width:2px, @color:#ccc, @radius: 4px){


  10. border: @width solid @color; border-radius: @radius;


  11. }


  12. .header {.border(4px, #f00, 2px);}


  13.

  14. //@arguments 指所有参数


  15. .border (@width:1px, @style:solid, @color:#ccc){border: @arguments;}


  16.

  17. #header{


  18. height:100px;


  19. &:hover {color:red;} //=== #header:hover, &代表同级


  20. &.top {margin-top:12px;} // === #header.top


  21. h1 {font-size:24px;}  // === #header h1


  22. }


  23. #content {


  24. h1{#header h1;} //调用#header h1。这时候#header就相当于命名空间的概念


  25. }





**注释（Comments）**

和js一样，单行“//”和多行“/* */”。编译时会删除“//”保留“/* */”。

**运算**

LESS的运算能力比较强大，主要有两个方面，一个是常规四则运算（Operations）,一个是颜色计算。
四则运算遵循常规的优先级，特色是可以对颜色、数字、变量进行运算，而且对带单位的数值有很强的容错能力。例子：
@base: 5%; @filler: @base*2; //变量运算
color: #888 / 4; //颜色运算，result === #222
@var 1px + 5; // result === 6
颜色计算主要是LESS提供了以下函数：

lighten(@color, 10%); //return lighten color
darken(@color, 10%); //return darken color
saturate(@color, 10%); //return more saturated
desaturate(@color, 10%); //return less saturated
fadein(@color, 10%); //return less transparent
fadeout(@color, 10%); //return more transparent
spin(@color, -10|10); //return smaller or larger than @color

提取颜色值：
hue(@color); //returns the hue channel of color
saturation(@color); //returns the saturation channel of @color
lightness(@color); //returns the lightness channel of @color
alpha(@color) //return alpha channel of @color(hsl模式里面的透明通道)
hsl(h,s,l),hsla(h,s,l,a),rgb(r,g,b),rgba(r,g,b,a) //这些更不用说，某些浏览器都支持了。

**安装**

LESS和Coffee一样，其实都提供了两种安装模式。一种是解释模式，也就是js。通过js就能对less文件进行编译成正常的CSS，嵌入html页面中。这里的过程应该可以通过js进行配置，有空再谈。而另一种就是编译模式，安装LESS编译器，需要node（其实重点是npm）环境支持，进入cmd 输入 npm install less -g 即可。解释模式适用于开发，而编译模式适用于发布上线。二者结合无懈可击。coffee的安装也类似。
