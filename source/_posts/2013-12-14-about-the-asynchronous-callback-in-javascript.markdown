---
author: ety001
comments: true
date: 2013-12-14 15:29:01+00:00
layout: post
slug: about-the-asynchronous-callback-in-javascript
title: 关于javascript中的异步回调函数
wordpress_id: 2539
tags:
- 前端
---

在参加一个48小时的创客活动时，做了一个应用，用到了html5中的canvas，其中有一个步骤是读取9张图片画在canvas上，我遇到的难题就是onload函数的异步回调问题。最初的部分代码如下：

```
function fillJPG(ctx, el , width , height , i){
  var img;
  for(var i=0;i<MAX;i++){
    img = new Image();
    img.onload = function(){
      ctx.drawImage(img,width*i,0,width,height);
      /* console.log(i); */
    }
    img.src = el[i];
  }
}
```

这个代码中ctx是画布，el是图片url的数组，width和height分别是单张图片的宽和高，同时也可以用于计算坐标和图片大小压缩。
问题出现就是本来应该横向并排出现的9张图片一张都没有出现。把MAX调整为1后，发现，图片显示出来了，就一张，但是位置却出现在了第二张图片应该出现的问题，经过一晚上的调试，发现问题出现在回调函数。回调函数的执行时间是发生在图片载入结束，而循环体的执行是一直的，也就是i是一直在累加的，可以发现的就是i的累加速度快于图片载入的速度，所以，第一张图片载入完成的时候，i已经是1了（在MAX为1的情况下，其实也就是i为MAX了），也就是说图片是出现在了第MAX+1的位置上面了。

尝试过了一些方法，都避免不了这个异步，最终使用递归的方法来实现了这个功能，代码如下：

```
function fillJPG(ctx, el , width , height , i){
  var img = new Image();
  img.onload = function(){
    ctx.drawImage(img,width*i,0,width,height);
    i++;
    if(i<MAX){
      fillJPG(ctx,el,width,height,i);
    } else {
      return;
    }
  }
  img.src = el[i];
}
```
