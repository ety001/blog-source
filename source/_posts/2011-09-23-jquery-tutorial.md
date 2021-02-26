---
author: ety001
date: 2011-09-23 06:28:34+00:00
layout: post
title: jQuery入门教程笔记7
wordpress_id: 1672
tags:
- 编程语言
- 前端
---

这是《jQuery入门教程笔记》的第七篇，这一篇将开始新的一章，操作DOM。

对于DOM的解释：当我们创建一个页面并加载到Web浏览器时，DOM模型则根据该页面的内容创建了一个文档文件；单词Object即对象，是指具有独立特性的一组数据集合，例如，我们把新创建的页面文档称之为文档对象，与对象相关联的特征称之为对象属性，访问对象的函数称之为对象方法；单词“Model”即模型，在页面文档中，通过树状模型展示页面的元素和内容，其展示的方式则是通过节点（node）来实现的。让我们来看个例子：

```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
	<title>DOM演示</title>
	<style type="text/css">
		body{
			font-size:13px;
		}
		table,div,p,ul{
			width:280px;
			border:solid 1px #666;
			margin:10px 0px;
			padding:0px;
			background-color:#eee;
		}
	</style>
</head>

<body>
	<table>
		<tr>
			<td>Td1</td>
		</tr>
		<tr>
			<td>Td2</td>
		</tr>
	</table>
	<div>Div</div>
	<p>P</p>
	<div>
		<span>Span</span>
	</div>
	<ul>
		<li>Li1</li>
		<li>Li2</li>
	</ul>
</body>
</html>
```

根据上面的代码创建的DOM树结构如下图：
[![](http://www.domyself.me/wp-content/uploads/2011/09/pp-400x233.png)]()


**一、访问元素**
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
<td>
叙述
</td>
<td>
方法
</td>
<td>
语法
</td>
</tr>
<tr >

<td >元素属性操作
</td>

<td >
获取和设置元素属性：attr()

删除某一属性：removeAttr()

</td>

<td >
获取：attr(name)

例如：$("img").attr("src")//获取img标签的src属性值

设置：attr(key,value)//key表示属性的名称,value表示属性的值，当value是函数的时候，函数的返回值将作为value值

attr(key0:value0,key1:value1)//可以一次设置多组

例如：$("img").attr("title","domyself")

$("img").attr(title:"domyself",src:"/images/1.jpg")

删除:removeAttr(name)

例如：$("img").removeAttr("src");

</td>
</tr>
<tr >

<td >元素内容操作
</td>

<td >html()和text()
</td>

<td >
1、html()，用于获取元素的HTML内容

2、html(val)，用于设置元素的HTML内容

3、text()，用于获取元素的文本内容

4、text(val)，用于设置元素的文本内容

说明：html()方法仅支持XHTML的文档，不能用于XML文档，而text()则既支持HTML文档，也支持XML文档。

</td>
</tr>
<tr >

<td >获取或设置元素值
</td>

<td >
val(val)

val().join(",")

</td>

<td >
获取：val()，相当于attr("value")的作用

使用val().join(",")可以获取一组值，并用“,”隔开，分隔符可以更换

赋值：val(val),val可以为数组

</td>
</tr>
<tr >

<td >元素样式操作
</td>

<td >
css(name,value)

addClass(class)

toggleClass(class)

removeClass([class])

</td>

<td >
css(name,value)，直接修改某项css的值

addClass(class)，添加一个class类别，可以用英文逗号隔开添加多个

toggleClass(class)，当元素中含有名称为class的CSS类别时，删除该类别，否则增加一个该名称的CSS类别

removeClass([class])，如果不给参数则是清空所有class，可以添加多个class，需要用逗号隔开


</td>
</tr>
</tbody>
</table>

