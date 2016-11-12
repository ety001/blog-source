---
author: ety001
layout: post
title: 鼠标滚轮控制页面切换
tags:
- 前端
---
最近项目需要做一个欢迎页，效果差不多就是有点PPT的样子，然后用鼠标滚轮可以控制页面切换。

在实施过程中，遇到的问题就是jquery的 mousewheel 事件触发的机制让人太纠结了。

由于我们一般滚动了 x° 的圆心角才认为是滚动了一次，而计算机在滚动 x° 的过程中，只要有度数的变化，
就会触发一次事件。这个在回调事件的第二个参数即可看出来，第二个参数叫做 delta，即变化量。
也就是说这个变量其实是存储的从开始滚动到当前滚动位置，滚动过的一个类似圆心角的值。

那么我们就需要在这个回调函数里面去做文章，让我们意识中的滚动一次能实现出来。

具体的方法是，加入一个全局变量，来记录每一次的滚动开始，并且每次开始后的一秒内，
不再执行回调函数，直到1秒钟的时候重置这个全局变量。之所以设置一秒是因为我们平时的习惯，
差不多就是1秒钟滚动一次滚轮。代码差不多就是下面的这个样子：

    window.is_wheel = false;
    $('body').bind('mousewheel', function(event, delta) {
      if(window.is_wheel==true)return;
      window.is_wheel = true;
      setTimeout(function(){
        window.is_wheel = false;
      }, 1000);

      if(delta > 0){
        next_page();
      } else {
        prev_page();
      }
      return false;
    });

这样，频繁触发的问题就解决了。<b style="color:red;">另外需要注意的是</b>，如果翻页是个动画效果，那么请把翻页动画效果的时间设置在一秒内，
因为可以保证每次滚动滚轮只执行了一次翻页操作，即翻页动画的回调函数也会按照预期顺序执行。
