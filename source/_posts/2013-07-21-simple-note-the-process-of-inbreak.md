---
author: ety001
comments: true
date: 2013-07-21 04:30:50
layout: post
slug: simple-note-the-process-of-inbreak
title: 简单记录下入侵过程
wordpress_id: 2425
tags:
- Hacker
---

很久没有入侵过服务器了。这次入侵的起因是学校社团的服务器页面遭到挂马了，但是有意思的是，挂马的iframe代码时有时无，在服务器上查看源代码也没有问题。于是排除了直接改源文件的可能和DNS遭到劫持的可能。

看了下挂马的地址是跟自己服务器同C段的，因此猜测可能是遭到了ARP欺骗攻击，但是不确定是有人故意攻击我的服务器还是属于批量攻击。于是目标就先锁定这台挂马的服务器。

扫描了端口，开了不少，21,80,3389一些常见的端口都开着，3389了下，看到是win2003。百度了下IP，么有有用信息，google了下，发下了这个IP上绑定了的域名，对该域名进行whois，发现了很多信息，逐步的又发现了很多关于这个域名注册者的信息，有gmail邮箱，居住地信息，在网络上的活动痕迹，可能还有工作地点信息和生日年份，简单的尝试猜解gmail邮箱失败。换个思路，访问下IP看看下面是什么站，由于运营商封掉了直接访问IP，因此我用我自己的域名绑定了下这个IP，访问发现是个N点虚拟主机管理系统，果断搜索引擎看看默认后台和账号，然后运气很好的就进入了N点的后台。

接下来就是建立个虚拟主机，配置他支持.net，这样果断上一个webshell，然后就是一通提权尝试。。。经过了6个小时的尝试失败了，常用的提权的路都试过了，由于很久没有搞过了，手头也没有能用的本地溢出，已是凌晨两点多，睡觉先。。

一觉醒来，回到N点看了下，发现貌似我可以配置应用池，果断配置成本地，然后再去webshell里执行添加用户的命令，成功，拿到administrator权限了。

剩下的事情就是简单清理下战场，然后上3389，下载360急救箱进行查毒（尼玛，100多个病毒啊。。还是两个用户的，看来至少进来过两个人了。。），自己写个C程，替换掉粘滞键那个程序，修改N点的默认密码，添加了个N点的隐藏管理员，收工，貌似清完病毒后，我的网站没有再出现过挂马代码，再观察段时间吧，到QQ安全管家网站申诉下网址安全了。

最后总结下：

1、尽量避免用windows主机吧，虽然配置下也挺安全，但是真正下工夫配置的有几个呢，很多人都是保持默认的，相比在默认情况下，linux可能会相对安全些。

2、即使买了服务器空间不用，或者只是买了测试，也不要保持默认的密码好吧，你这是对于自己邻居的危害啊！

3、这次不是个针对我的网站的定向的攻击，因为在尝试提权的6个小时里，我看过netstat和进程，发现这台机器还在尝试批量攻击别的服务器，所以应该是病毒行为。

4、没有了，就是不要再遇到这种蛋疼的事情了，大好的周末又泡汤了。。。看书去。。。。

