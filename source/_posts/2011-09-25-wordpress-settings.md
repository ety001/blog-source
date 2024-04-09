---
author: ety001
date: 2011-09-25 03:08:49
layout: post
title: WordPress设置文章页面的动态关键字和描述
wordpress_id: 1681
tags:
- 后端
---

用wordpress有段时间了，总结了一点小经验，要想网站被多收录的话，确实需要下一番功夫，推广是必不可少的，但是从我们自身网站结构来说，也有一定的技巧吧，观察了几个网站，在关键字设置上，发现一点：每个文章页面的关键字和描述都是不同的。很值得借鉴，怎么不同呢？首页的关键字和描述是固定的，但是文章页面的关键字是当前文章的标签、描述则是是文章的前100字（可以设置长度）。这样的话，更利于搜索引擎搜索了。


于是乎，这篇文章就诞生啦！

其实很简单，如果你设置了网站关键字的话（手动添加），我已经把代码整理好了

**步骤1** ：打直接修改源文件（header.php）也好，或者登录后台修改：外观-编辑-选择修改（顶部）header.php文件。

找到代码：（作用：设置关键字）


<blockquote><meta name="keywords" content="这里是你网站首页的关键字..." /></blockquote>


替换为：


<blockquote><meta name="keywords" content="<?php if (is_single()){ $keywords = "";$tags = wp_get_post_tags($post->ID);foreach ($tags as $tag ) {$keywords = $keywords . $tag->name . ", ";}echo $keywords;}else{echo ("这里是你网站首页的关键字...");} ?>" /></blockquote>


找到代码：（作用：设置描述）


<blockquote><meta name="description" content="这里是你网站首页的描述..." /></blockquote>


替换为：


<blockquote><meta name="description" content="<?php if (is_single()){ echo mb_strimwidth(strip_tags(apply_filters('the_content', $post->post_content)), 0, 180,"");} else{echo ("这里是你网站首页的描述...");}?>" /></blockquote>


**步骤2** ：点击“更新文件”保存设置。

这样就OK啦！打开一个文章页面，鼠标右键，查看源文件，看看效果吧！应该会对对收录有好处。


来源：浮云站[www.fuyunz.com](http://www.fuyunz.com/) 原创教程转载注明出处！

