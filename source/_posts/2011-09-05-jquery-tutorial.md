---
author: ety001
date: 2011-09-05 08:13:14
layout: post
title: jQuery入门教程笔记3
wordpress_id: 1551
tags:
- 编程语言
- 前端
---

这是《jQuery入门教程笔记》系列3，在第3篇里面将继续讲述jQuery的选择器，这篇讲述“层次选择器”。




下面是基本选择器的语法表格：


<table cellpadding="0" cellspacing="0" >
<tbody >
<tr >
选择器
功能
返回值
</tr>
<tr >

<td >ancestor descendant
</td>

<td >根据祖先元素匹配所有的后代元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >parent>child
</td>

<td >根据父元素匹配所有子元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >prev + next
</td>

<td >匹配所有紧接在prev元素后的相邻元素
</td>

<td >元素集合
</td>
</tr>
<tr >

<td >prev ~ siblings
</td>

<td >匹配prev元素之后的所有兄弟元素
</td>

<td >元素集合
</td>
</tr>
</tbody>
</table>


<!-- more -->  

**说明：**ancestor descendant 与 parent>child 所选择的元素集合是不同的，这一点在下面的示例里面是很显然就能看出来的，ancestor descendant匹配的descendant是ancestor里的所有匹配descendant元素（也就是说可以向下匹配好几层），而parent>child只匹配parent元素的子元素（即只能匹配一层）；另外，prev + next可以使用.next()代替，而prev ~ siblings可以用.nextAll()来代替。




下面是示例代码，请自己调整注释符的位置来体会各种不同的选择器的效果。  

```
    &lt;!DOCTYPE html PUBLIC &quot;-//W3C//DTD XHTML 1.0 Strict//EN&quot;<br />
        &quot;http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd&quot;&gt;<br />
    &lt;html xmlns=&quot;http://www.w3.org/1999/xhtml&quot; xml:lang=&quot;en&quot; lang=&quot;en&quot;&gt;</p>
    <p>&lt;head&gt;<br />
        &lt;title&gt;chap2-3 使用jQuery层次选择器&lt;/title&gt;<br />
        &lt;meta http-equiv=&quot;content-type&quot; content=&quot;text/html;charset=utf-8&quot; /&gt;<br />
        &lt;meta name=&quot;generator&quot; content=&quot;Geany 0.20&quot; /&gt;<br />
        &lt;script language=&quot;javascript&quot; type=&quot;text/javascript&quot; src=&quot;jquery-1.6.2.min.js&quot;&gt;&lt;/script&gt;<br />
        &lt;style type=&quot;text/css&quot;&gt;<br />
            body{<br />
                font-size:12px;<br />
                text-align:center;<br />
            }<br />
            div,span{<br />
                float:left;<br />
                border:solid 1px #ccc;<br />
                margin:8px;<br />
                display:none;<br />
            }<br />
            .clsFraA{<br />
                width:65px;<br />
                height:65px;<br />
            }<br />
            .clsFraP{<br />
                width:45px;<br />
                height:45px;<br />
                background-color:#eee;<br />
            }<br />
            .clsFraC{<br />
                width:25px;<br />
                height:25px;<br />
                background-color:#ddd;<br />
            }<br />
        &lt;/style&gt;<br />
        &lt;script type=&quot;text/javascript&quot;&gt;<br />
            /*$(function(){ //匹配后代元素<br />
                $(&quot;#divMid&quot;).css(&quot;display&quot;,&quot;block&quot;);<br />
                $(&quot;div span&quot;).css(&quot;display&quot;,&quot;block&quot;);<br />
            });<br />
            $(function(){ //匹配子元素<br />
                $(&quot;#divMid&quot;).css(&quot;display&quot;,&quot;block&quot;);<br />
                $(&quot;div&gt;span&quot;).css(&quot;display&quot;,&quot;block&quot;);<br />
            });*/<br />
            $(function(){ //匹配后面元素<br />
                $(&quot;#divMid + div&quot;).css(&quot;display&quot;,&quot;block&quot;);<br />
                //$(&quot;#divMid&quot;).next().css(&quot;display&quot;,&quot;block&quot;);<br />
            });<br />
            /*$(function(){ //合并所有后面元素<br />
                $(&quot;#divMid ~ div&quot;).css(&quot;display&quot;,&quot;block&quot;);<br />
                //$(&quot;#divMid&quot;).nextAll().css(&quot;display&quot;,&quot;block&quot;);<br />
            });<br />
            $(function(){ //匹配所有相邻的元素<br />
                $(&quot;#divMid&quot;).siblings(&quot;div&quot;)<br />
                .css(&quot;display&quot;,&quot;block&quot;);<br />
            });*/<br />
        &lt;/script&gt;<br />
    &lt;/head&gt;</p>
    <p>&lt;body&gt;<br />
        &lt;div class=&quot;clsFraA&quot;&gt;Left&lt;/div&gt;<br />
        &lt;div class=&quot;clsFraA&quot; id=&quot;divMid&quot;&gt;<br />
            &lt;span class=&quot;clsFraP&quot; id=&quot;Span1&quot;&gt;<br />
                &lt;span class=&quot;clsFraC&quot; id=&quot;Span2&quot;&gt;&lt;/span&gt;<br />
            &lt;/span&gt;<br />
        &lt;/div&gt;<br />
        &lt;div class=&quot;clsFraA&quot;&gt;Right_1&lt;/div&gt;<br />
        &lt;div class=&quot;clsFraA&quot;&gt;Right_2&lt;/div&gt;<br />
    &lt;/body&gt;<br />
    &lt;/html&gt;<br />
```

