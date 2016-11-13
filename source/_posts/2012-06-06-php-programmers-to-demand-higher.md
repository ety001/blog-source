---
author: ety001
comments: true
date: 2012-06-06 11:43:32+00:00
layout: post
slug: php-programmers-to-demand-higher
title: PHP对程序员的要求更高
wordpress_id: 2130
tags:
- 编程语言
---

转自[Laruence](http://www.laruence.com/)大神的博客：[http://www.laruence.com/2012/04/01/2571.html](http://www.laruence.com/2012/04/01/2571.html)

今天是愚人节, 但我这个文章标题可不是和大家开玩笑. ![:)](http://www.laruence.com/wp-includes/images/smilies/icon_smile.gif)

首先, 大家都知道, PHP也是一种编译型脚本语言, 和其他的预编译型语言不同, 它不是编译成中间代码, 然后发布.. 而是每次运行都需要编译..

为此, 也就有了一些Opcode Cache, 比如开源的APC, eacc. 还有商业的Zend O+等.

那么为什么PHP不把编译/执行分开呢?

PHP虽然是一种编译型脚本语言, 但是它的编译速度非常快, 它的编译不做任何语义优化, 就是简单的忠实的把你所写的代码翻译成对应的Opcodes. 而其他语言因为在编译器做很多的优化工作, 会造成编译比较重, 也一定程度上要求它们分离.

所以, 理论上来说, 通过编译执行分离, 想达到源码加密, 是不会有什么太大收效的, 因为它很容易被反向.

另外, 编译直接分离, 并不会带来特别大的收益, 反而会降低调试部署的效率(想想, 修改, 编译, 发布, 看效果), 并且APC等Opcode Cache工具, 已经很成熟了..

到这里, 请大家注意这句:”它的编译不做任何语义优化”….

这也就是我为什么说, PHP对程序员的要求更高, 不同于其他的编译型语言, PHP在编译的时候不会帮你做一些优化, 比如对于如下的代码:




  1. $j = "laruence";


  2. for ($i=0;$i<strlen($j);$i++) {


  3. }


如果是其他预编译语言, 它的编译器也许会帮你做优化, 把strlen提取到前面去, 只做一次就够了. 而对于PHP来说, 它在编译的时候不做任何优化, 也就是说, 你的strlen, 会忠实的被调用8次.

再比如:


  1. $table = "table";


  2. while($i++ < 1000) {


  3.   $sql = "select * from " . $table . " where id = " . $i;


  4. }


没错, “select * from ” . $table会被concat 1000次..

可见, PHP的程序员, 需要认真的想好, 你的代码会怎么被执行, 你怎么写代码, 最终的执行效率才最高. 而不像其他的语言, 程序员可以把一部分优化工作交给编译器.

这也就是我为什么说:”PHP对程序员的要求更高” 的原因. 当然, 这个是好是坏, 那就是见仁见智了.
