---
author: ety001
comments: true
date: 2012-12-16 19:33:47+00:00
layout: post
slug: the-differences-between-session-and-cookie
title: session和cookie的区别
wordpress_id: 2250
tags:
- 理论
---

转自：[http://www.chinahtml.com/1007/128010707619425.html](http://www.chinahtml.com/1007/128010707619425.html)

session和cookie是[网站](http://www.chinahtml.com/)浏览中较为常见的两个概念，也是比较难以辨析的两个概念，但它们在点击流及基于用户浏览行为的[网站](http://www.chinahtml.com/)分析中却相当关键。基于网上一些文章和资料的参阅，及作者个人的应用体会，对这两个概念做一个简单的阐述和辨析，希望能与大家共同探讨下。

session和cookie的最大区别在于session是保存在服务端的内存里面，而cookie保存于浏览器或客户端文件里面；session是基于访问的进程，记录了一个访问的开始到结束，当浏览器或进程关闭之后，session也就“消失”了，而cookie更多地被用于标识用户，它可以是长久的，用于用户跟踪和识别唯一用户（Unique Visitor）。


### 关于session


session被用于表示一个持续的连接状态，在[网站](http://www.chinahtml.com/)访问中一般指代客户端浏览器的进程从开启到结束的过程。session其实就是[网站](http://www.chinahtml.com/)分析的访问（visits）度量，表示一个访问的过程。

![session](http://www.chinahtml.com/d/file/2010/07-26/d03bef2cf6c25bddc3787e4353b172db.png)<!-- more -->

session的常见实现形式是会话cookie（session cookie），即未设置过期时间的cookie，这个cookie的默认生命周期为浏览器会话期间，只要关闭浏览器窗口，cookie就消失了。实现机制是当用户发起一个请求的时候，[服务器](http://www.chinahtml.com/server)会检查该请求中是否包含sessionid，如果未包含，则系统会创造一个名为JSESSIONID的输出 cookie返回给浏览器(**只放入内存，并不存在硬盘中**)，并将其以HashTable的形式写到[服务器](http://www.chinahtml.com/server)的内存里面；当已经包含sessionid是，服务端会检查找到与该session相匹配的信息，如果存在则直接使用该sessionid，若不存在则重新生成新的 session。这里需要注意的是session始终是有服务端创建的，并非浏览器自己生成的。

但是浏览器的cookie被禁止后session就需要用get方法的URL重写的机制或使用POST方法提交隐藏表单的形式来实现。

这里有一个很关键性的注意点，即**session失效时间**的设置，这里要分两方面来看：浏览器端和服务端。对于浏览器端而言，session与访问进程直接相关，当浏览器被关闭时，session也随之消失；而[服务器](http://www.chinahtml.com/server)端的session失效时间一般是人为设置的，目的是能定期地释放内存空间，减小[服务器](http://www.chinahtml.com/server)压力，一般的设置为当会话处于**非活动状态**达20或30分钟时清除该 session，所以浏览器端和服务端的session并非同时消失的，session的中断也并不一定意味着用户一定离开了该[网站](http://www.chinahtml.com/)。目前Google Analytics和Omniture都定义当间隔30分钟没有动作时，算作一次访问结束，所以上图中session的最后一步不只是离开，也有可能是静止、休眠或者发呆的状态。

还有一点需要注意，就是现在的浏览器好像趋向于多进程的session共享，即通过多个标签或页面打开多个进程访问同一[网站](http://www.chinahtml.com/)时共享一个 session cookie，只有当浏览器被关闭时才会被清除，也就是你有可能在标签中关闭了该[网站](http://www.chinahtml.com/)，但只要浏览器未被关闭并且在[服务器](http://www.chinahtml.com/server)端的session未失效前重新开启该[网站](http://www.chinahtml.com/)，那么就还是使用原session进行浏览；而某些浏览器在打开多页面时也可能建立独立的session，IE8、Chrome默认都是共享 session的，在IE8中可以通过菜单栏中的文件->新建会话来建立独立session的浏览页面。


### 关于cookie


[![cookie](http://webdataanalysis.net/wp-content/uploads/2010/03/cookie.png)](http://webdataanalysis.net/wp-content/uploads/2010/03/cookie.png)

cookie 是一小段文本信息，伴随着用户请求和页面在Web[服务器](http://www.chinahtml.com/server)和浏览器之间传递。用户每次访问站点时，Web应用程序都可以读取cookie包含的信息。

session的实现机制里面已经介绍了常见的方法是使用会话cookie（session cookie）的方式，而平常所说的cookie主要指的是另一类cookie——持久cookie（persistent cookies）。持久cookie是指**存放于客户端硬盘中**的 cookie信息（设置了一定的有效期限），当用户访问某[网站](http://www.chinahtml.com/)时，浏览器就会在本地硬盘上查找与该[网站](http://www.chinahtml.com/)相关联的cookie。如果该cookie 存在，浏览器就将它与页面请求一起通过HTTP报头信息发送到您的站点，然后在系统会比对cookie中各属性和值是否与存放在[服务器](http://www.chinahtml.com/server)端的信息一致，并根据比对结果确定用户为“初访者”或者“老客户”。

持久cookie一般会保存用户的用户ID，该信息在用户注册或第一次登录的时候由[服务器](http://www.chinahtml.com/server)生成包含域名及相关信息的cookie发送并存放到客户端的硬盘文件上，并设置cookie的过期时间，以便于实现用户的自动登录和[网站](http://www.chinahtml.com/)内容自定义。

Apache自带的mod_usertrack模块可以在用户首次来到当前[网站](http://www.chinahtml.com/)的时候给用户种下一个唯一的cookie（较长时间过期），这个 cookie是用户首次来当前[网站](http://www.chinahtml.com/)的IP地址加上一个随机字符串组成的。同时在自定义WEB日志中在最后增加%{cookie}n字段可以实现 cookie在apache日志中的输出，用于数据统计与用户跟踪。
