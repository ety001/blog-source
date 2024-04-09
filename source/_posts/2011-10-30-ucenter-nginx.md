---
author: ety001
date: 2011-10-30 07:36:21
layout: post
title: ucenter在nginx下的应用通讯问题
wordpress_id: 1748
tags:
- 后端
---

今天大半天就在折腾这个了，直接复制帖子了，不多说了……

由于ucenter是用socket通讯，但是nginx下socket支持不好，会出现连接超时，整个网站死掉，出现症状：头像不能编辑，discuz登陆退出不了，uc里面通讯一直是“正在连接”。

好了，说正题了

很简单，iis、lighttpd、apache下ucenter 通讯正常，

ok  那就让ucenter跑在iis、lighttpd、apache下，

虚拟主机用户 需要两个虚拟主机，
一个iis或者lighttpd、apache环境，专门跑ucenter，域名用uc.xxx.com
一个nginx环境，专门跑discuz等等这些 高耗资源的程序

有独立主机、vps的 就可以建两个web服务器，这时候跑uc.xxx.com的web服务器就要另外指定端口了，比如88，访问ucenter就可以用uc.xxx.com:88
另一个那就是nginx咯

ok 布置完了，再去uc里面看  是不是发现 “正在连接”没了， 出现 久违的 连接成功 ！！！

