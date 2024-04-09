---
author: ety001
comments: true
date: 2012-08-31 15:41:57
layout: post
slug: bank-of-china-is-rubbish
title: 我的DELL 15R特别版安装了中国银行的安全控件后键盘失灵
wordpress_id: 2171
tags:
- 杂七杂八
---

这个题目是摘自百度知道的题目，我也是15R特别版，也是在win7  64位下安装完中银的控件，键盘就不管用了，点击桌面文件也成了多选，初步判定是ctrl键成为了一直被触发的状态了。。。捣鼓半天最后发现了百度知道里一个很有用的答案，就是删掉

    C:\windows\system32\drivers\ETD.SYS

然后重启就OK了，不过副作用就是触摸板不能用了。看来是控件跟触摸板驱动冲突了。

我只想说：Bank of China is rubbish！

百度知道：<a href="http://zhidao.baidu.com/question/454034960.html">http://zhidao.baidu.com/question/454034960.html</a>

