---
author: ety001
date: 2011-09-02 15:39:31
layout: post
title: jQuery入门教程笔记2
wordpress_id: 1523
tags:
- 编程语言
- 前端
---

这是《jQuery入门教程笔记》系列2，在第2篇里面将开始讲述jQuery很重要的一种东西，那就是选择器，这篇先从基本选择器讲起。

下面是基本选择器的语法表格：

<table cellpadding="0" cellspacing="0" >
   <tbody >
      <tr >
         选择器
         功能
         返回值
      </tr>
      <tr >

<td >#id
</td>

<td >根据给定的ID匹配一个元素
</td>

<td >单个元素
</td>
      </tr>
      <tr >

<td >element
</td>

<td >根据给定元素名匹配所有元素
</td>

<td >元素集合
</td>
      </tr>
      <tr >

<td >.class
</td>

<td >根据给定的类匹配元素
</td>

<td >元素集合
</td>
      </tr>
      <tr >

<td >*
</td>

<td >匹配所有元素
</td>

<td >元素集合
</td>
      </tr>
      <tr >

<td >selector1,selectorN
</td>

<td >将每一个选择器匹配到的元素合并后一起返回
</td>

<td >元素集合
</td>
      </tr>
   </tbody>
</table>
<!-- more -->
下面是基本选择器的示例，该示例我是在原书（[《jQuery权威指南》](http://item.tmall.com/item.htm?id=10862959121&prc=1&ali_trackid=2:mm_13275160_0_0:1314978130_3z4_1193337051)）的基础上修改的，为了更好的来理解没有方式的选择器是如何工作的，建议各位新手依次把下面代码中的所有选择器用法先注释掉，然后一条一条，一个一个的来实验，然后观察效果如何。

```
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

    <head>
    	<title>chap2-2</title>
    	<meta http-equiv="content-type" content="text/html;charset=utf-8" />
    	<meta name="generator" content="Geany 0.20" />
    	<script language="javascript" type="text/javascript" src="jquery-1.6.2.min.js"></script>
    	<style type="text/css">
    		body{
    			font-size:12px;
    			text-align:center;			
    		}
    		.clsFrame{
    			width:300px;
    			height:100px;
    			float:left;
    		}
    		.clsFrame div,span{
    			display:none;
    			float:left;
    			width:65px;
    			height:65px;
    			border:solid 1px #ccc;
    			margin:8px;
    		}
    		.clsOne{
    			background-color:#eee;
    		}
    	</style>
    	<script type="text/javascript">
    		$(function(){ //ID匹配元素
    			$("#divOne").css("display","block");
    			//$("#divOnei").css("display","block");
    		});
    		/*$(function(){ //元素名匹配元素
    			$("div span").css("display","block");
    		});
    		$(function(){ //类匹配元素
    			$(".clsFrame .clsOne").css("display","block");
    		});*/
    		$(function(){ //合并匹配元素
    			$("#divOne,span").css("display","block");
    		});
    	</script>
    </head>

    <body>
    	<div class="clsFrame">
    		<div id="divOne">ID</div>
    		<div class="clsOne">CLASS</div>
    		<span>SPAN</span>
    	</div>
    	<div class="clsFrame">
    		<div id="divOnei">ID</div>
    		<div class="clsOne">CLASS</div>
    		<span>SPAN</span>
    	</div>
    </body>
    </html>
```

