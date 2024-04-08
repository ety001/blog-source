---
author: ety001
comments: true
date: 2015-01-16 15:02:58+00:00
layout: post
slug: full-screen-background-img
title: 背景图片拉伸
tags:
- 前端
---

需要做一个页面让背景图片能全屏平铺，对于现代浏览器来说很简单，使用下面的代码即可：

```
body{
    background:url(../../img/user/user_bg_2.jpg) no-repeat center center fixed;
    -webkit-background-size: cover;
    -moz-background-size: cover;
    -c-background-size: cover;
    background-size: cover;
}
```

这个方式可以兼容的浏览器有

    * Safari 3+
    * Chrome
    * IE 9+
    * Opera 10+ (Opera 9.5 支持background-size属性 但是不支持cover)
    * Firefox 3.6+

但是蛋疼的IE浏览器，就是不给你面子，当你的背景图片宽度小于当前的浏览器宽度的时候，就会有留白，
那么就需要再加上两句，如下

```
body{
    background:url(../../img/user/user_bg_2.jpg) no-repeat center center fixed;
    -webkit-background-size: cover;
    -moz-background-size: cover;
    -c-background-size: cover;
    background-size: cover;

    filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='/res/img/user/user_bg_2.jpg', sizingMethod='scale');
    -ms-filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='/res/img/user/user_bg_2.jpg', sizingMethod='scale')";
}
```

需要注意的是，需要使用绝对路径。用滤镜硬拉伸，可能需要图片做点高斯模糊，要不然效果会很糟糕。

另外还有用img标签来实现的，可以参照[这篇文章](http://huilang.me/perfect-full-page-background-image/)。

