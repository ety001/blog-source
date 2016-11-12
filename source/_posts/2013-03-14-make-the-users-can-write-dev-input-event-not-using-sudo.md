---
author: ety001
comments: true
date: 2013-03-14 07:40:10+00:00
layout: post
slug: make-the-users-can-write-dev-input-event-not-using-sudo
title: 如何让普通用户不用sudo就可以写入/dev/input/event
wordpress_id: 2335
tags:
- Server&OS
- 编程语言
---

最近在做的一个项目中，有一个细节是需要用C实现模拟键盘输入，发现每次执行程序的时候，都需要用sudo，因为默认情况下/dev/input/下的event都是root属主和属组，并且权限是640。如果要实现普通用户直接可以写的话，可以去做一个udev的规则，比如用root用户创建一个如下位置的规则文件：

    /etc/udev/rules.d/99-input.rules:

内容如下：

    KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="input"

重启机器后，就会发现那些event都是input组的了，现在需要去创建个input的用户组，并把想要允许能写event的用户加入input组即可。

