---
author: ety001
date: 2011-10-07 10:29:16
layout: post
title: jQuery入门教程笔记9
wordpress_id: 1696
tags:
- 编程语言
- 前端
---

这是《jQuery入门教程笔记》的第九篇，这篇继续讲关于节点的内容，并且将会在这篇中结束jQuery操作DOM这部分内容。 一、插入节点 插入节点分为内部插入节点方法和外部插入节点方法。内部插入节点的意思就是说在元素的内部插入一个新的元素，那么显然外部插入节点方法就是在元素的外部插入一个新的元素。详细见下面两个表格：

先来看看内部插入节点

<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
语法格式
参数说明
功能描述
</tr>
<tr >

<td >append(content)
</td>

<td >content表示追加到目标中的内容
</td>

<td >向所选择的元素内部插入内容
</td>
</tr>
<tr >

<td >append(function(index,html))
</td>

<td >通过function函数返回追加到目标中的内容
</td>

<td >向所选择的元素内部插入function函数所返回的内容
</td>
</tr>
<tr >

<td >appendTo(content)
</td>

<td >content表示被追加的内容
</td>

<td >把所选择的元素追加到另一个指定的元素集合中
</td>
</tr>
<tr >

<td >prepend(content)
</td>

<td >content表示插入目标元素内部前面的内容
</td>

<td >向每个所选择的内容内部前置内容
</td>
</tr>
<tr >

<td >prepend(function(index,content))
</td>

<td >通过function函数返回插入目标元素内部前面的内容
</td>

<td >向所选择的元素内部插入function函数所返回的内容
</td>
</tr>
<tr >

<td >prependTo(content)
</td>

<td >content表示用于选择元素的jQuery表达式
</td>

<td >将所选择的元素前置到另一个指定的元素集合中
</td>
</tr>
</tbody>
</table>
这里补充一个我的总结：


<blockquote>x.append(y) 在x中插入y y.appendTo(x) 把y插入到x中</blockquote>


接下来是外部插入节点before(content)content表示插入目标元素外部前面的内容向所选择的元素外部后面插入内容insertAfter(content)content表示插入目标元素外部后面的内容将所选择的元素插入另一个指定的元素外部后面
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
语法格式
参数说明
功能描述
</tr>
<tr >

<td >after(content)
</td>

<td >content表示插入目标元素外部后面的内容
</td>

<td >向所选择的元素外部后面插入内容
</td>
</tr>
</tbody>
</table>


<blockquote>备注：表中的三个方法都支持function做参数，即用function来代替content。</blockquote>


二、复制节点 在页面中，有时需要将某个元素节点复制到另外一个节点后，如购物网站中购物车的设计。在传统的javascript中，学要写较为复杂的代码，而用jQuery，可以通过clone()轻松实现。 clone()有两种用法，一种是不加参数，一种是加true参数。区别在于：clone()复制匹配的DOM元素并且选中复制成功的元素，该方法仅是复制元素本身，被复制后的新元素不具有任何元素行为。如果想把元素的全部行为都复制，则需要使用clone(true)实现。 示例：

```
$(function(){
	$("img").click(function(){
		$(this).clone(true).appendTo("span");
	})；
})；
```

<blockquote>备注：该句代码的意思就是当单击img元素的时候，复制该元素并加入到span中去。</blockquote>


三、替换节点 有两种方法: 1、replaceWith(content)，该方法的功能是将所有选择的元素替换成指定的HTML或DOM元素，其中参数content为被所选择元素替换的内容。 2、replaceAll(selector)，该方法的功能是将所有选择的元素替换成指定selector的元素，其中参数selector为需要替换的元素。 示例：

```
$(function(){
	$("#Span1").replaceWith("<span>domyself.me</span>");
	$("<span>domyself.me</span>").replaceAll("#Span2");
})；
```

<blockquote>备注：#Span1和#Span2是被替换的元素，请注意替换顺序，另外请注意一旦完成替换，被替换元素中的全部时间都将消失。</blockquote>


四、包裹节点 在jQuery中，不仅可以通过方法替换元素节点，还可以根据需求包裹某个指定的节点，对节点的包裹也是DOM对象操作中很重要的一项，其与包裹节点相关的全部方法如下表：
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
语法格式
参数说明
功能描述
</tr>
<tr >

<td >wrap(html)
</td>

<td >html参数为字符串代码，用于生成元素并包裹所选元素
</td>

<td >把所有选择的元素用其他字符串代码包裹起来
</td>
</tr>
<tr >

<td >wrap(elem)
</td>

<td >elem参数用于包装所选元素的DOM元素
</td>

<td >把所有选择的元素用其他DOM元素包装起来
</td>
</tr>
<tr >

<td >wrap(fn)
</td>

<td >fn参数为包裹结构的一个函数
</td>

<td >把所有选择的元素用function函数返回的代码包裹起来
</td>
</tr>
<tr >

<td >unwrap()
</td>

<td >无参数
</td>

<td >移除所选元素的父元素或包裹标记
</td>
</tr>
<tr >

<td >wrapAll(html)
</td>

<td >html参数为字符串代码，用于生成元素并包裹所选元素
</td>

<td >把所有选择的元素用单个元素包裹起来
</td>
</tr>
<tr >

<td >wrapAll(elem)
</td>

<td >elem参数用于包装所选元素的DOM元素
</td>

<td >把所有选择的元素用单个DOM元素包裹起来
</td>
</tr>
<tr >

<td >wrapInner(html)
</td>

<td >html参数为字符串代码，用于生成元素并包裹所选元素
</td>

<td >把所有选择的元素的子内容（包括文本节点）用字符串代码包裹起来
</td>
</tr>
<tr >

<td >wrapInner(elem)
</td>

<td >elem参数用于包装所选元素的DOM元素
</td>

<td >把所有选择的元素的子内容（包括文本节点）用DOM元素包裹起来
</td>
</tr>
<tr >

<td >wrapInner(fn)
</td>

<td >fn参数为包裹结构的一个函数
</td>

<td >把所有选择的元素的子内容（包括文本节点）用function函数返回的代码包裹起来
</td>
</tr>
</tbody>
</table>
示例：

```
$(function(){
	$("p").wrap("<strong></strong>");//所有段落标记字体加粗
	$("span").wrapInner("<em></em>");//所有段落中的span标记斜体
});
```

<blockquote>备注：该代码的执行效果是在<p>domyself.me</p>的外面加上<b></b>，即查看源代码时显示的是<b><p>domyself.me</p></b>，另一句代码的执行效果则是在<span>domyself.me</span>的内部加入<i></i>，即执行后的效果为，<span><i>domyself.me</i></span>。</blockquote>


五、遍历元素
在DOM元素操作中，有时需要对同一标记的全部元素进行同一操作。在传统的javascript中，先获取元素的总长度，然后，以for循环依次访问其中的某个元素，代码相对复杂，而在jQuery中，可以直接使用each()方法实现元素的遍历，语法如下：


<blockquote>each(callback)</blockquote>


参数callback是一个function函数，该函数还可以接受一个形参index，此形参为遍历元素的序号（从0开始）；如果需要访问元素中的属性，可以借助形参index，配合this关键字来实现元素属性的设置或获取。 示例：

```
$("img").each(function(index){
	//根据形参index设置元素的title属性
	this.title = index;
});
```

六、删除元素
两种方法：
remove()，语法格式为remove([expr])，其中参数expr为可选项，如果接受参数，则该参数为筛选元素的jQuery表达式，通过该表达式获取指定的元素，并进行删除。
empty()，其功能为清空所选择的页面元素或所有的后代元素。

