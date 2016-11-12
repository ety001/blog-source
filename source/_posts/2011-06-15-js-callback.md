---
author: ety001
date: 2011-06-15 08:05:16+00:00
layout: post
title: 浅谈JavaScript的回调函数，附实例
wordpress_id: 1390
tags:
- 编程语言
- 前端
---

1、背景
Javascript中的回调函数，相信大家都不陌生，最明显的例子是做Ajax请求时，提供的回调函数，
实际上DOM节点的事件处理方法（onclick,ondblclick等）也是回调函数。

在使用DWR的时候，回调函数可以作为第一个或者最后一个参数出现，如：

function callBack(result){
}
myDwrService.doSomething(param1,param2,callBack);//DWR的推荐方式
//或者
myDwrService.doSomething(callBack,param1,param2);


2、问题描述
最近在使用Dojo+Dwr的时候，碰到一个问题：
如果回调函数是属于某个对象（记为obj1）的方法，等到DWR执行该回调函数的时候，
上下文却不是obj1。
表现的现象就是在回调函数中访问obj1的任何属性都是undefined。

版本：Dojo1.3.1和dwr2

3、模拟问题的代码
下面的测试代码可以模拟这个问题：

```
<html>
<head>
<script>
var context="全局";
var testObj={
context:"初始",
callback:function (str){//回调函数
alert("callback:我所处的上下文中，context="+this.context+"，我被回调的方式："+str);
}
};//创建一个对象，作为测试回调函数的上下文
testObj.context="已设置";

function testCall(){
callMethod(testObj.callback);
callObjMethod(testObj,testObj.callback);
}
function callObjMethod(obj,method){
method.call(obj,"指定显式对象上下文回调");
}
function callMethod(method){
method("通过默认上下文回调");
}
</script>
</head>
<body>
<a href="javascript:void(0)" onclick="testCall()">调用测试</a>
</body>
</html>
```

在testCall方法中，我用了两种方式回调“testObj.callback"方法：
第一种方式：method("通过默认上下文回调");
没有指定上下文，我们发现回调函数内部访问context的值是全局变量的值，
这说明，执行该方法的默认上下文是全局上下文。

第二种方式：method.call(obj,"指定显式对象上下文回调");
指定obj为method执行的上下文，就能够访问到对象内部的context。


4、研究DWR
因为06年使用DOJO+DWR(1.0)的时候，已经遇到过这个问题，当时没做太多功课，直接改了dwr的源代码。

现在用dwr2，于是想先看看DWR是不是对这个问题有新的处理方式，
将dwr.jar中的engine.js拿出来，查看了有关回调的相关代码（`_remoteHandleCallback`和`_execute`)，
发现对回调的处理方式似乎比1.0更简单，没办法将对象和方法一起传过去。

5、做进一步的研究
因为这次DWR在项目中的使用太广泛，而且我相信这样的需求应该是可以满足的，于是没有立刻修改源码，

首先，在Google上搜Dojo+dwr，没有查到什么结论，可能Dojo的用户不是太多。

于是又搜”javascript callback object context“，得到一篇文章专门介绍java回调函数的文章：
http://bitstructures.com/2007/11/javascript-method-callbacks
最重要的一句话：

    When a function is called as a method on an object (obj.alertVal()),
    "this" is bound to the object that it is called on (obj).
    And when a function is called without an object (func()),
    "this" is bound to the JavaScript global object (window in web browsers.)

这篇文章也提供了解决方案，就是使用Closure和匿名方法，
javascript中，在function内部创建一个function的时候，会自动创建一个closure，
而这个closure就能记住对应的function创建时的上下文。

所以，如果这样：

```
var closureFunc=function(){
testObj.callback();
}
```

那么无论在什么地方，直接调用closureFunc()和调用testObj.callback()是等价的。

详情参见上面提到的文章：http://bitstructures.com/2007/11/javascript-method-callbacks。

6、改进模拟代码
在模拟代码中，我们再增加一种回调方式：

```
<html>
<head>
<script>
var context="全局";
var testObj={
context:"初始",
callback:function (str){//回调函数
alert("callback:我所处的上下文中，context="+this.context+"，我被回调的方式："+str);
}
};//创建一个对象，作为测试回调函数的上下文
testObj.context="已设置";

function testCall(){
callMethod(testObj.callback);
callWithClosure(function(param){testObj.callback(param);});
callObjMethod(testObj,testObj.callback);
}
function callObjMethod(obj,method){
method.call(obj,"指定显式对象上下文回调");
}
function callMethod(method){
method("通过默认上下文回调");
}
function callWithClosure(method){
method("通过Closure保持上下文回调");
}
</script>
</head>
<body>
<a href="javascript:void(0)" onclick="testCall()">调用测试</a>
</body>
</html>
```

测试以上代码，我们可以发现，通过Closure和通过显示指定对象得到的效果一致。

