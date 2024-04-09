---
author: ety001
comments: true
date: 2014-03-05 02:23:01
layout: post
slug: four-patterns-of-invocation-in-javascript
title: JavaScript函数调用模式
wordpress_id: 2582
tags:
- 前端
---

转自：[http://www.cnblogs.com/chanruida/archive/2011/04/19/invocation.html](http://www.cnblogs.com/chanruida/archive/2011/04/19/invocation.html)

调用一个函数将会挂起当前函数的执行，并传递控制权与参数给新的函数。 除了声明的参数，每个函数会接收到两个新的附加参数：this和arguments。 this是个很重要的参数，并且它的值是由调用模式决定的。

以下是JavaScript中很重要的4个调用模式：

a. 方法调用模式the method invocation pattern

b. 函数调用模式the function invocation pattern

c. 构造器调用模式the constructor invocation pattern

d. Apply调用模式the apply invocation pattern

<!-- more -->

1. 方法调用模式the method invocation method

当函数作为对象的方法的时候，我们就叫函数为方法。当一个方法被调用的时候，this绑定到调用的对象。

var myObj={

val:0,

increment:function(inc){ this.val+=typeof inc ==="number"?inc:1;},

get_val:function(){return this.val;}

}

myObj.increment();// 1

myObj["increment"](2);//3

小结：当用 .或者下标表达式 来使用一个函数的时候，就是方法调用模式，this对象绑定到前面的对象。

一个函数可以使用this来访问对象，所以它能检索对象的值或者更改对象的值。绑定this到对象发生在调用的时候。



2. 函数调用模式the function invocation pattern

当一个函数不是一个对象的属性，那么它就是作为函数来调用的。当一个函数作为函数调用模式来调用的时候，this绑定到全局对象。这是JavaScript设计时的错误并延续了下来。

function add(x,y){

    return x+y;

}

myObj.double=function(){

    var that=this;

    var helper=function(){

        that.val=add(that.value,that.value);

        /*错误的写法可能是这样，为什么错呢？因为函数作为内部函数调用的时候，this已经绑定到了错误的对象，全局对象并没有val属性，所以返回不正确的值。

        this.val = this.val+this.val;

        */

}

    helper();

}

myObj.double();//6



3. 构造器调用模式the constructor invocation pattern

JavaScript是一门基于原型继承的语言，这意味着对象可以直接继承属性从其它的对象，该语言是无类别的。

如果在一个函数前面带上new来调用，那么将得到一个隐藏连接到该函数的prototype成员的新对象，同时this也将会绑定到该新对象。

new前缀也会改变return语句的行为。这也不是推荐的编程方式。

var Foo = function(status){

    this.status = status;

}

Foo.prototype.get_status = function(){

    return this.status;

}

//构造一个Foo实例

var myFoo = new Foo("bar");

myFoo.get_status();//"bar"



4. Apply调用模式the apply invocation pattern

因为JavaScript是一个函数式的面向对象语言，所以函数可以拥有方法。

Apply方法拥有两个参数，第一个是将绑定到this的值，第二个是参数数组，也就是说Apply方法让我们构建一个数组并用其去调用函数，即允许我们选择this的值，也允许我们选择数组的值。

var array = [3,4];

var sum = add.apply(null,array); // 7

var statusObj = {status:"ABCDEFG"};

Foo.prototype.pro_get_status = function(prefix){

    return prefix +"-"+this.status;

}

var status = Foo.prototype.get_status.apply(statusObj);// "ABCDEFG"

var pro_status = Foo.prototype.get_status.apply(statusObj,["prefix"]);// "prefix -ABCDEFG"



最后的牢骚：

函数调用：foo();，这种情况下this永远为undefined，但由于js标准规定this必须是个有效对象，所以会被绑到window

方法调用：foo.bar();，这种情况下，.前面的是啥，this就是啥。

构造器：new foo();这种情况下，this就是new出来的对象。

apply：foo.apply(thisObject, [xxx]);，这种情况下，apply指定this为thisObject

