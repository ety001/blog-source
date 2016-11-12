---
author: ety001
comments: true
date: 2012-02-15 05:20:02+00:00
layout: post
title: J2ME下的JSON包
wordpress_id: 1958
tags:
- 编程语言
- 理论
---

今天在开发一个j2me程序的时候，需要用到json数据的解析，从百度上搜了一圈都是各种教你怎么用的，但问题是没有一个说，这个包从哪里获得。。。从一个老外的blog找到一个jar包，还看到一个非jar包的。先说jar包的，转自：[http://per.liedman.net/2010/06/07/the-lack-of-a-json-parser-for-j2me/](http://per.liedman.net/2010/06/07/the-lack-of-a-json-parser-for-j2me/)

In a pet project I’m spending my nights working on (hopefully more about that in a later post), I found myself in need of a JSON parser, or deserializer, for J2ME/CLDC. A bit to my surprise, I found that such a thing was not easy to find, even with the whole of the internets at my disposal.

To summarize, it appears that there has been a JSON lib for J2ME up on [json.org at some point](http://www.google.se/search?aq=f&ie=UTF-8&q=org.json.me.zip), but at least I can’t find it any longer. Also, [some project on java.net](https://meapplicationdevelopers.dev.java.net/mobileajax.html) is popular to link to, but come on, no download link? No pre-compiled JAR-file?

Anyway, after [asking over at stackoverflow.com](http://stackoverflow.com/questions/2981296/json-parser-for-j2me) and getting surprisingly few answers, at least I found a link to some code that was easy enough to grab.

As some kind of attempt to give back to the community, I upload the compiled JAR from that source code here. So if you need to serialize, deserialize, marshal or unmarshal JSON from J2ME/CLDC, grab this JAR and go ahead:

  * Compiled JAR: [json-me.jar](http://per.liedman.net/wp-content/uploads/2010/06/json-me.jar)
  * <del>Source code: [json-me.tar.gz](http://per.liedman.net/wp-content/uploads/2010/06/json-me.tar.gz)</del> **Updated 2010-09-25:** the source is now [available on BitBucket](http://bitbucket.org/liedman/json-me)

The code is most likely a copy of the one that was previously posted on json.org, and is distributed under [the json.org license](http://www.json.org/license.html) according to the copyright notice in the source (most importantly: “The Software shall be used for Good, not Evil.”)

As a very tiny modification, I have added the methods _remove_ and _removeAll_ to the class _JSONArray_, since I really needed them. I hope you don’t mind too much.

非jar包：[https://github.com/upictec/org.json.me/](https://github.com/upictec/org.json.me/)
