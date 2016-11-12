---
author: ety001
date: 2011-09-21 16:09:11+00:00
layout: post
title: jQuery入门教程笔记6
wordpress_id: 1657
tags:
- 编程语言
- 前端
---

这是《jQuery入门教程笔记》的第六篇，这一篇将会作为选择器这部分的一个综合案例。对于选择器，还有几类在之前的笔记中没有提到，这些大家可以百度下，都是能百度的到的。之前笔记略过的部分有：子元素过滤选择器，表单对象属性过滤选择器，表单选择器。

现在开始这一篇的内容，这个综合案例实现的是一个导航条，效果是，单击标题时，可以伸缩导航条的内容，同时，标题中的提示图片也随之改变，另外，单击“简化”链接时，隐藏指定的内容，并将“简化”字样改变成“更多”，单击“更多”链接时，返回初始状态，并改变指定显示元素的背景色。
<!-- more -->

以下是源代码：
```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>导航条在项目中的应用</title>
<script language="javascript" type="text/javascript" src="jquery-1.4.2.min.js"></script>
<style>
	body{
		font-size:13px;
	}
	#divFrame{
		border:solid 1px #666;
		width:301px;
		overflow:hidden;
	}
	#divFrame .clsHead h3{
		padding:0px;
		margin:0px;
		float:left;
	}
	#divFrame .clsHead span{
		float:right;
		margin-top:3px;
	}
	#divFrame .clsContent{
		padding:8px;
	}
	#divFrame .clsContent ul{
		list-style-type:none;
		margin:0px;
		padding:0px;
	}
	#divFrame .clsContent ul li{
		float:left;
		width:95px;
		height:23px;
		line-height:23px;
	}
	#divFrame .clsBot{
		float:right;
		padding-top:5px;
		padding-bottom:5px;
	}
	.GetFocus{
		background-color:#eee;
	}
</style>
<script type="text/javascript">
	$(function(){ //页面加载事件
		$(".clsHead").click(function(){ //图片单击事件
			if($(".clsContent").is(":visible")){ //如果内容可见
			   $(".clsHead span img")
			   .attr("src","Images/a1.gif"); //改变图片
			   //隐藏内容
			   $(".clsContent").css("display","none");
			}else{
			   $(".clsHead span img")
			   .attr("src","Images/a2.gif"); //改变图片
			   //显示内容
			   $(".clsContent").css("display","block");
			}
		});

		$(".clsBot > a").click(function(){ //热点链接单击事件
			//如果内容为“简化”字样
			if($(".clsBot > a").text() == "简化"){
				//隐藏index号大于4且不是最后一项的元素
				$("ul li:gt(4):not(:last)").hide();
				//将字符内容更改为“更多”
				$(".clsBot > a").text("更多");
			}else{
				$("ul li:gt(4):not(:last)")
				.show()
				.addClass("GetFocus");//显示所选元素且增加样式
				//将字符内容更改为“简化”
				$(".clsBot > a").text("简化");
			}
		});
	});
</script>
</head>
<body>
	<div id="divFrame">
    	<div class="clsHead">
        	<h3>图书分类</h3>
            <span><img src="Images/a2.gif" alt="" /></span>
        </div>
        <div class="clsContent">
        	<ul>
            	<li><a href="#">小说</a><i>(1110)</i></li>
                <li><a href="#">文艺</a><i>(230)</i></li>
                <li><a href="#">青春</a><i>(1430)</i></li>
                <li><a href="#">少儿</a><i>(1560)</i></li>
                <li><a href="#">生活</a><i>(870)</i></li>
                <li><a href="#">社科</a><i>(1460)</i></li>
                <li><a href="#">管理</a><i>(1450)</i></li>
                <li><a href="#">计算机</a><i>(1780)</i></li>
                <li><a href="#">教育</a><i>(930)</i></li>
                <li><a href="#">工具书</a><i>(3450)</i></li>
                <li><a href="#">引进版</a><i>(980)</i></li>
                <li><a href="#">其他类</a><i>(3230)</i></li>
            </ul>
            <div class="clsBot"><a href="#">简化</a>
            	<img src="Images/a5.gif" alt="" />
            </div>
        </div>
	</div>
</body>
</html>
```
