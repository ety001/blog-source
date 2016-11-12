---
author: ety001
date: 2011-09-24 02:44:22+00:00
layout: post
title: jQuery入门教程笔记8
wordpress_id: 1679
tags:
- 编程语言
- 前端
---

这是《jQuery入门教程笔记》的第八篇，这篇讲的是创建节点元素。

函数$()用于动态创建页面元素，其语法如下：


<blockquote>$(html)</blockquote>



其中，参数html表示用于动态创建DOM元素的HTML标记字符串，即如果要在页面中动态创建一个div标记，并设置其内容和属性，可以加入如下代码：


<blockquote>var $div=$("
>
> Domyself
>
> ");
$("body").append($div);</blockquote>


<!-- more -->
下面是Demo源代码：

```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>创建动态节点元素</title>
<script type="text/javascript" src="jquery.js"></script>
<style type="text/css">
	body{
		font-size:13px;
	}
	ul{
		padding:0px;
		list-style:none;
	}
	ul li{
		line-height:2.0em;
	}
	.divL{
		float:left;
		width:200px;
		background-color:#eee;
		border:solid 1px #666;
		margin:5px;
		padding:0px 8px;
	}
	.divR{
		float:left;
		width:200px;
		display:none;
		border:solid 1px #ccc;
		margin:5px;
		padding:0px 8px;
	}
	.txt{
		border:#666 1px solid;
		padding:3px;
		width:120px;
	}
	.btn{
		border:#666 1px solid;
		padding:2px;
		width:60px;
		filter:progid:DXImageTransform.Microsoft.
		Gradient(GradientType=0,
		StartColorStr=#ffffff,EndColorStr=#ece9d8);
	}
</style>
<script type="text/javascript">
	$(function(){
		$("#Button1").click(function(){
			/*获取参数*/
			var $str1=$("#select1").val();//获取元素名
			var $str2=$("#text1").val();//获取内容
			var $str3=$("#select2").val();//获取属性名
			var $str4=$("#text2").val();//获取属性
			var $div=$("<" + $str1 + " " + $str3 + "='" + $str4 + "'>" + $str2 + "</" + $str1 + ">");//创建DOM对象
			$(".divR").show().append($div);//插入节点
		});
	});
</script>
</head>

<body>
	<div class="divL"><p></p>
    	<ul>
        	<li>元素名：
            	<select id="select1">
                	<option value="p">p</option>
                    <option value="div">div</option>
                </select>
            </li>
            <li>内容为：
            	<input type="text" id="text1" class="txt" />
            </li>
            <li>属性名：
            	<select id="select2">
                	<option value="title">title</option>
                </select>
            </li>
            <li>属性值：
            	<input type="text" id="text2" class="txt" />
            </li>
            <li style="text-align:center; padding-top:5px;">
            	<input id="Button1" type="button" value="创建" class="btn" />
            </li>
        </ul>
    </div>
    <div class="divR"></div>
</body>
</html>
```
