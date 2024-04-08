---
author: ety001
comments: true
date: 2013-07-02 00:22:15+00:00
layout: post
slug: js-load-order
title: js載入順序問題
wordpress_id: 2415
tags:
- 前端
---

最近遇到一個bug,調試了很久了,沒找到原因,現象就是一個input框綁定了change事件,但是事件在IE9下面不觸發,不過如果用F12的工具逐行執行,卻又能觸發.後來因為無意中調出一個報警,報警內容如下:



    SCRIPT5007: 无法获取未定义或 null 引用的属性“b”



才想到可能是js載入早於input框的載入，導致的事件綁定失敗，調整載入順序后，問題解決。

