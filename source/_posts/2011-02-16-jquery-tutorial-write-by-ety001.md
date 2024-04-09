---
author: ety001
comments: true
date: 2011-02-16 14:16:02
layout: post
title: jQuery教程一  write by ETY001
wordpress_id: 1022
tags:
- 编程语言
---

今天开始正式学习jQuery，不过，在网上找了很长时间就没怎么找到一个适合我的教程。这让我想起了之前看过的一个老外写的关于“hello，world！”程序的重要性文章，而在jQuery的种种教程中就是缺乏这样的“hello，world！”

不过功夫不负有心人，我终于在官网http://docs.jquery.com/Tutorials:How_jQuery_Works找到了对我口味的教程，于是我就该文为基础，整合一下其他的资料写个教程吧。

“Hello，world！”这个程序之所以经典，是因为通过短短的几行代码就能让初学者体验到成功的喜悦，而这短短的几行代码的编写到调试又是手把手的教，所以这个程序示例是所有编程入门书籍的开篇。那我们就来看看我们怎么入手jQuery。

关于jQuery的介绍我就不多说了，还不知道的看看这里就可以了，http://baike.baidu.com/view/1020297.htm。那我们现在就开始我们的第一个例子。

首先，要运行js代码需要一个框架结构，下面这个就是最简单的结构：

```
<html>
  <head>
    <meta charset="utf-8">
    <title>Demo</title>
  </head>
  <body>
    <a href="http://www.domyself.me">jQuery</a>
    <script src="jquery.js"></script>
    <script>
       /*从这里写你的js代码*/
    </script>
  </body>
</html>
```

在你的网页编辑器里，新建一个html ，把上面的代码复制进去，不过其中有个地方需要根据你的情况进行修改，就是那个jquery.js 文件的位置，我的是调用的谷歌的，你也可以到这里下载http://docs.jquery.com/Downloading_jQuery。

然后我们把那句中文注释给删掉，加上下面的代码：

```
$(document).ready(function(){
  $("a").click(function(event){
    alert("Hello，world!");
  });
});
```

下面就让我们保存一下，然后打开网页，点击超链接，你就会看到一个弹出警告“Hello，world！”。这就是我们的第一个示例。

这里就需要解释一下这个示例里面用到的一些东西。

$(“a”)，它是一个jQuery选择器（selector），在这里的作用就是选择所有的<a>标签。$号是 jQuery “类”(jQuery "class")的一个别称，因此$()构造了一个新的jQuery 对象(jQuery object)。函数click()是这个jQuery对象的一个方法，它绑定了一个单击事件到所有选中的标签(这里是所有的a标签)，并在事件触发时执行了它所提供的alert方法。

关于$，这里就多说些，jQuery中使用 $ ，可以通过元素的id, css class或 tag name很容易的获取到相应的元素。

简单的获取元素

```
$("p") //获取所有的P元素
$("#pid") //通过 ID
$(".p") //通过css class name
```

它还可以钻取层次结构

```
$("table > tbody > tr") //获取Table的所有行
$("#t1 > tbody > tr") //获取t1 中所有行
$(".table > tbody > tr") // 获取css类名为.table的所有行
```

Jquery为了让开发人员更准确方便的选择到相应的元素，还给我们提供了强大的筛选器的功能

```
$(“p:first”)  //first
$(“p:last”)  //last
$(“table > tbody > tr:even”)  //even rows
$(“table > tbody > tr:odd”) //odd rows
$(“p:eq(1)”) //索引为1
$(“p:gt(2)”) //2以上的元素
$("p:lt(10)”) // 0-9
$(“p:empty”) //没有子孩子的p
$(“p:parent”) //为父的p
```

另外再说一下ready()，它的作用是极大地提高web应用程序的响应速度。通过使用这个方法，可以在DOM载入就绪能够读取并操纵时立即调用你所绑定的函数，而99.99%的JavaScript函数都需要在那一刻执行。

今天就先做到这里吧。

后记：第一次自己做细致的教程，里面如有错误还请高人指正，我也是边学边写，看不远。不过我挺喜欢外国人这种先运行代码，后解释代码的教学方法。

