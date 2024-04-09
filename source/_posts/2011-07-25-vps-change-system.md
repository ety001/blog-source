---
author: ety001
date: 2011-07-25 04:05:49
layout: post
title: 今天对自己的VPS进行了更换系统
wordpress_id: 1425
tags:
- 杂七杂八
- 网站日志
- Server&OS
---

由于之前一直都是想拿自己的VPS做记事狗QQ机器人的存放空间（这个机器人只能在win下运行），所以，最初安装VPS的操作系统的时候，选择的是win2003。经过这两个多月的使用，我实在是无法忍受win+apache这种不良的组合了，服务器软件总是出错，还是换回linux系统才是王道！

于是乎，今天早上9点，在VPS上的服务器软件又一次当掉的情况下，果断选择重装系统为Cent OS。经过两个半小时的折腾，终于是把一切都搞定了～现在服务器架设的环境是LNMP，终于用上了我一直梦想的ngix啦，哈哈～

下面总结一下：

    1、我使用的是“LNMP一键安装包”，详细的安装教程，**请看这里：[http://lnmp.org/install.html](http://lnmp.org/install.html)**，我就不再多做阐述。
    2、需要自己手动在nginx.conf中添加wordpress的rewrite规则。添加方法在这里：[http://bbs.vpser.net/viewthread.php?tid=2730&highlight=wordpress](http://bbs.vpser.net/viewthread.php?tid=2730&highlight=wordpress)。
    3、我选择的VPS服务商提供给我的VPS的硬盘空间不是一个整块硬盘，意思就是说我的硬盘空间是20G，而实际是由两块10G的硬盘拼起来的，而VPS用户面板的重装系统按钮只能在一块上安装，这就导致我的另一块10G空间没有用了。我联系客服后，客服给出了教程，教程地址如下：[http://forum.xensystem.com/thread-50-1-1.html](http://forum.xensystem.com/thread-50-1-1.html)。这个教程可以帮你把另外的空间扩充到现在的空间上。这个教程很简单，不要看着那么多的命令就发怵，其实一步一步来做就可以了，只不过一些具体的硬盘空间数据不同罢了（也可能有些硬盘的标示不同，这个我觉得应该不是问题），这里我就提醒一句话，注意命令的大小写（有一个命令的参数是大写的L，还有linux是大小写敏感的，所以硬盘标示之类的大小写也要注意下～）。

**最后，我再做个我的VPS的广告，我现在用的VPS是52元一个月的，就我现在使用的这三个月来看足够我个人使用了～如果你对于我的这款VPS感兴趣，可以来这里看看：[http://www.domyself.me/archives/1427.html](http://www.domyself.me/archives/1427.html)。**

