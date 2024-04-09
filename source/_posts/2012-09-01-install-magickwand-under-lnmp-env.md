---
author: ety001
comments: true
date: 2012-09-01 08:58:15
layout: post
slug: install-magickwand-under-lnmp-env
title: 一键LNMP包安装MagickWand
wordpress_id: 2174
tags:
- Server&OS
---

由于项目开发需要，里面用到的一个图片缩放处理的PHP类库使用了MagickWand扩展，所以我需要在本地开发环境中配置一下。我本地的开发环境是LinuxDeepin + LNMP的一键安装包，默认是不带MagickWand的。

首先是用LNMP文件夹下的脚本先安装ImageMagick，这个很简单，一会就搞定了，然后去MagickWand的官网下载MagickWand包，下载回来后，按照网上说的编译成扩展形式，但是编译出错了，忘记是提示什么了，在百度上搜索了下，说要先安装libmagickwand-dev，于是先sudo apt-get install libmagickwand-dev，如果你找不到这个包就apt-cache search magickwand下看看。

安装好后，重新编译，编译成功得到magickwand.so文件了，我的在/usr/local/php/lib/php/extensions/no-debug-none-zts-20060613/下面，然后去php.ini中加入extension = magickwand.so，重启php-fpm，提示错误：

undefined symbol zif_magicksetimageend

我了个去，各种搜索，最后只有在google上用zif_magicksetimageend搜出5条一模一样的问题，但还不是我要找的。。。。

昨天折腾了一天，换了magickwand 1.0.9在官网上的3种形式的压缩包，他们svn库的我也编译过了，错误依旧，今天索性换上个版本的试试，结果可以了。。。shit。。。。

另外编译MagickWand的时候，不要忘记 --enabled-share这个参数。

