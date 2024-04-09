---
author: ety001
comments: true
date: 2011-09-10 06:28:29
layout: post
slug: '1579'
title: jQuery入门教程笔记4
wordpress_id: 1579
tags:
- 编程语言
---

这是《jQuery入门教程笔记》系列4，在第4篇里面将继续讲述jQuery的选择器，这篇讲述“基本过滤选择器”。




下面是简单过滤选择器的语法表格：


<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
选择器
功能
返回值
</tr>
<tr >

<td >first()或者:first
</td>

<td >获取第一个元素
</td>

<td >单个元素
</td>
</tr>
<tr >

<td >last()或:last
</td>

<td >获取最后一个元素
</td>

<td >单个元素
</td>
</tr>
<tr >

<td >:not(selector)
</td>

<td >获取除给定选择器外的所有元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:even
</td>

<td >获取所有索引值为偶数的元素，索引号从0开始
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:odd
</td>

<td >获取所有索引值为奇数的元素，索引号从0开始
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:eq(index)
</td>

<td >获取指定索引值的元素，索引号从0开始
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:gt(index)
</td>

<td >获取所有大于给定索引值的元素，索引号从0开始
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:lt(index)
</td>

<td >获取所有小于给定索引值的元素，索引号从0开始
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:header
</td>

<td >获取所有类型的元素，如h1,h2……
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:animated
</td>

<td >获取正在执行动画效果的元素
</td>

<td >元素集合
</td>
</tr>
</tbody>
</table>


下面是示例代码，请自己调整注释符的位置来体会各种不同的选择器的效果。

```
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

    <head>
        <title>chap2-4 使用jQuery基本过滤选择器</title>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />
        <meta name="generator" content="Geany 0.20" />
        <script language="javascript" type="text/javascript" src="jquery-1.6.2.min.js"></script>
        <style type="text/css">
            body{
                font-size:12px;
                text-align:center;      
            }
            div{
                width:241px;
                height:83px;
                border:solid 1px #eee;
            }
            h1{
                font-size:13px;
            }
            ul{
                list-style-type:none;
                padding:0px;
            }
            .DefClass,.NotClass{
                height:23px;
                width:60px;
                line-height:23px;
                float:left;
                border-top:solid 1px #eee;
                border-botton:solid 1px #eee;
            }
            .GetFocus{
                width:58px;border:solid 1px #666;
                background-color:#eee;
            }
            #spanMove{
                width:238px;
                height:23px;
                line-height:23px;
            }
            .clsFraA{
                width:65px;
                height:65px;
            }
            .clsFraP{
                width:45px;
                height:45px;
                background-color:#eee;
            }
            .clsFraC{
                width:25px;
                height:25px;
                background-color:#ddd;
            }
        </style>
        <script type="text/javascript">
            /**/$(function(){ //增加第一个元素的类别
                $("li:first").addClass("GetFocus");
            });
            /*$(function(){ //增加最后一个元素的类别
                $("li:last").addClass("GetFocus");
            });
            $(function(){ //增加去除所有与给定选择器匹配的元素类别
                $("li:not(.NotClass)").addClass("GetFocus");
            });
            $(function(){ //增加所有索引值为偶数的元素类别，从0开始计数
                $("li:even").addClass("GetFocus");
            });
            $(function(){ //增加所有索引值为奇数的元素类别，从0开始计数
                $("li:odd").addClass("GetFocus");
            });
            $(function(){ //增加一个给定索引值的元素类别，从0开始计数
                $("li:eq(1)").addClass("GetFocus");
            });
            $(function(){ //增加所有大于给定索引值的元素类别，从0开始计数
                $("li:gt(1)").addClass("GetFocus");
            });
            $(function(){ //增加所有小于给定索引值的元素类别，从0开始计数
                $("li:lt(4)").addClass("GetFocus");
            });
            $(function(){ //增加标题类元素类别
                $("div h1").css("width","238");
                $(":header").addClass("GetFocus");
            });
            $(function(){
                animateIt();//增加动画效果元素类别
                $("#spanMove:animated").addClass("GetFocus");
            });*/
            function animateIt() { //动画效果
                $("#spanMove").slideToggle("slow",animateIt);
            }
        </script>
    </head>

    <body>
        <div>
            <h1>基本过滤选择器</h1>
            <ul>
                <li class="DefClass">Item 0</li>
                <li class="DefClass">Item 1</li>
                <li class="NotClass">Item 2</li>
                <li class="DefClass">Item 3</li>
            </ul>
            <span id="spanMove">Span Move</span>
        </div>
    </body>
    </html>
```

