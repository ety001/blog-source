---
author: ety001
layout: post
title: Flutter 编译为 APK Release时无法联网
tags:
- 教程
- Flutter
---

今天完成了我第一个 Flutter App —— [网络剪切板](https://fir.im/yhu7)。
当我满怀激动的编译出 Release 版本后，发现程序并不能联网。

经过搜索发现，原来要想联网需要自己手动去 `AndroidManifest.xml` 里添加下面的权限
```
<uses-permission android:name="android.permission.INTERNET"/>
```

我觉得 Flutter 的这种方式，让人觉得很恶心，这些工作不应该是 Flutter 自身的工具集
来完成的事情吗？为什么需要用户再去手动配置权限？不可思议。

---
#### ET碎碎念，每周一，晚六点一刻更新，欢迎订阅
#### 也可以订阅号留言
![](/img/wechat-subscribe.jpg)
