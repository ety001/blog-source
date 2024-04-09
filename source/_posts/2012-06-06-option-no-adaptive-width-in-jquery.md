---
author: ety001
comments: true
date: 2012-06-06 02:55:46
layout: post
slug: option-no-adaptive-width-in-jquery
title: select使用append进option无法自适应宽度
wordpress_id: 2128
tags:
- 前端
---

转自：[http://www.smuwcwt.com/archives/673](http://www.smuwcwt.com/archives/673)


select备受鄙视，前端中会碰到各式各样的问题，例如：

1，弹出层无法阻挡select
2，宽度，高度受系统影响，甚至连系统主题都影响select的宽高
等等。

今天碰到这样一个问题，后台系统再做3级联动的时候，用jquery的append向select中推拼合好的option，在IE6/7下居然无法自适应宽度。找到的唯一理由是，低版本浏览器无法重绘界面，导致宽度无法自适应，使用的解决方案：

对select先隐藏，后再显示。例如：


$("#SelectID").hide().show();


另外一种可能的解决方案是:


使用原生js的options.add向select中添加。

