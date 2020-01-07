---
author: ety001
layout: post
title: Cordova项目中的www和platforms目录
tags:
- cordova
---
最近新开了一个钱包的App项目，直接把之前的代码从 **Github** 上拖回来，但是执行 `cordova prepare -d` 一直不成功，显示 `current working directory is not a cordova-based project.`。

经过查看源码，发现在 [https://github.com/apache/cordova-lib/blob/master/src/cordova/util.js#L102](https://github.com/apache/cordova-lib/blob/master/src/cordova/util.js#L102) 这个地方的代码有问题。

正常情况下，这个函数返回 `2` 就可以了，由于我的 `.gitignore` 中把 `www` 和 `platforms` 两个目录都给忽略了，这就导致了一直返回 `0`，进而导致另外一个位置获取到的项目目录一直是 `/`，这显示不是项目根目录。。。

于是手动创建了 `www` 和 `platforms` 两个空目录后，一切就正常了。。。。。坑爹。。。。。。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
