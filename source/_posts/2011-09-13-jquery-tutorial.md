---
author: ety001
date: 2011-09-13 03:51:16+00:00
layout: post
title: jQuery入门教程笔记5
wordpress_id: 1594
tags:
- 编程语言
---

这是《jQuery入门教程笔记》系列5，在第5篇里面将继续讲述jQuery的选择器，这篇讲述“内容过滤选择器”，“可见性过滤选择器”，“属性过滤选择器”。

下面是内容过滤选择器的语法表格：
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
选择器
功能
返回值
</tr>
<tr >

<td >:contains(text)
</td>

<td >获取包含给定文本的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:empty
</td>

<td >获取所有不包含子元素或文本的空元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:has(selector)
</td>

<td >获取含有选择器所匹配的元素的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:parent
</td>

<td >获取含有子元素或者文本的元素。
</td>

<td >元素集合
</td>
</tr>
</tbody>
</table>
<!-- more -->
下面是示例代码，请自己调整注释符的位置来体会各种不同的选择器的效果。

```
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

    <head>
        <title>chap2-5 使用jQuery内容过滤选择器</title>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />
        <meta name="generator" content="Geany 0.20" />
        <script language="javascript" type="text/javascript" src="jquery-1.6.2.min.js"></script>
        <style type="text/css">
            body{
                font-size:12px;
                text-align:center;      
            }
            div{
                float:left;
                display:none;
                width:65px;
                height:65px;
                margin:8px;
                border:solid 1px #ccc;
            }
            span{
                float:left;
                border:solid 1px #ccc;
                margin:8px;
                width:45px;
                height:45px;
                background-color:#eee;
            }
        </style>
        <script type="text/javascript">
            /*$(function(){ //显示包含给定文本的元素
                $("div:contains('A')").css("display","block");
            });
            $(function(){ //显示所有不包含子元素或者文本的空元素
                $("div:empty").css("display","block");
            });
            $(function(){ //显示含有选择器所匹配的元素
                $("div:has(span)").css("display","block");
            });*/
            /**/$(function(){ //显示含有子元素或者文本的元素
                $("div:parent").css("display","block");
            });
        </script>
    </head>

    <body>
        <div>ABCD</div>
        <div><span></span></div>
        <div>EFaH</div>
        <div></div>
    </body>
    </html>
```

下面是可见过滤选择器的语法表格：
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
选择器
功能
返回值
</tr>
<tr >

<td >:hidden
</td>

<td >获取所有不可见元素，或者type为hidden的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >:visible
</td>

<td >获取所有的可见元素
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
        <title>chap2-6 使用jQuery可见性过滤选择器</title>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />
        <meta name="generator" content="Geany 0.20" />
        <script language="javascript" type="text/javascript" src="jquery-1.6.2.min.js"></script>
        <style type="text/css">
            body{
                font-size:12px;
                text-align:center;      
            }
            div,span{
                float:left;
                width:65px;
                height:65px;
                margin:8px;
                border:solid 1px #ccc;
            }
            .GetFocus{
                border:solid 1px #666;
                background-color:#eee;
            }
        </style>
        <script type="text/javascript">
            $(function(){ //增加所有可见元素类别
                $("span:hidden").show();
                $("div:visible").addClass("GetFocus");
            });
            /*$(function(){ //增加所有不可见元素类别
                $("span:hidden").show().addClass("GetFocus");
            });*/
        </script>
    </head>

    <body>
        <span style="display:none;">Hidden</span>
        <div>Visible</div>
    </body>
    </html>
```

下面是属性过滤选择器的语法表格：
<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
选择器
功能
返回值
</tr>
<tr >

<td >[attribute]
</td>

<td >获取包含给定属性的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >[attribute=value]
</td>

<td >获取等于给定的属性是某个特定值的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >[attribute!=value]
</td>

<td >获取不等于给定的属性是某个特定值的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >[attribute^=value]
</td>

<td >获取给定的属性是以某些值开始的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >[attribute$=value]
</td>

<td >获取给定的属性是以某些值结尾的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >[attribute*=value]
</td>

<td >获取给定的属性是以包含某些值的元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >[selector1][selector2][selectorN]
</td>

<td >获取满足多个条件的复合属性的元素
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
        <title>chap2-7 使用jQuery属性过滤选择器</title>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />
        <meta name="generator" content="Geany 0.20" />
        <script language="javascript" type="text/javascript" src="jquery-1.6.2.min.js"></script>
        <style type="text/css">
            body{
                font-size:12px;
                text-align:center;      
            }
            div{
                float:left;
                width:65px;
                height:65px;
                margin:8px;
                display:none;
                border:solid 1px #ccc;
            }
        </style>
        <script type="text/javascript">
            $(function(){ //显示所有含有id属性的元素
                $("div[id]").show(3000);
            });
            $(function(){ //显示所有属性title的值是"A"的元素
                $("div[title='A']").show(3000);
            });
            $(function(){ //显示所有属性title的值不是"A"的元素
                $("div[title!='A']").show(3000);
            });
            $(function(){ //显示所有属性title的值以"A"开始的元素
                $("div[title^='A']").show(3000);
            });
            $(function(){ //显示所有属性title的值以"C"结束的元素
                $("div[title$='C']").show(3000);
            });
            $(function(){ //显示所有属性title的值中含有"B"的元素
                $("div[title*='B']").show(3000);
            });
            $(function(){ //显示所有属性title的值中含有"B"且属性id的值是"divAB"的元素
                $("div[id='divAB'][title*='B']").show(3000);
            });
        </script>
    </head>

    <body>
        <div id="divID">ID</div>
        <div title="A">Title A</div>
        <div id="divAB" title="AB">ID <br />Title AB</div>
        <div title="ABC">Title ABC</div>
    </body>
    </html>
```

