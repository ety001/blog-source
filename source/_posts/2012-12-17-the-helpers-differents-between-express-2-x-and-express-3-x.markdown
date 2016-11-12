---
author: ety001
comments: true
date: 2012-12-17 04:32:40+00:00
layout: post
slug: the-helpers-differents-between-express-2-x-and-express-3-x
title: express 2.x 与 express 3.x的视图助手的区别
wordpress_id: 2256
tags:
- 编程语言
- 理论
---

转自：[http://cnodejs.org/topic/501f5d8ff767cc9a51c98165](http://cnodejs.org/topic/501f5d8ff767cc9a51c98165)

**2.x:**


    <code>app.helpers({ config: config, title: config.title }); app.dynamicHelpers({ //防止csrf攻击 csrf: function(req,res) { return req.session ? req.session._csrf : ''; }, req: function(req,res) { return req; }, userInfo: function(req,res){ return req.session.user; } });</code>


**3.x**


    <code>//app.helpers() app.locals({ config: config, title: config.title }); //app.dynamicHelpers app.use(function(req, res, next){ res.locals.title = config['title'] res.locals.csrf = req.session ? req.session._csrf : ''; res.locals.req = req; res.locals.session = req.session; next(); }); app.use(app.router);</code>
