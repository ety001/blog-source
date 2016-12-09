---
title: 修复Archlinux下Google Chrome的Flash插件不是最新版本的问题
date: 2016-12-09 12:22:30
keywords: ['archlinux', 'google', 'chrome', 'flash', 'out of date', 'internal-not-yet-present']
tags:
- 配置
- Server&OS
---
最近重新把我的Dell本换回了 *Archlinux*，不过安装了 *chrome* 后发现 *flash* 插件不能正常使用。
使用 *chrome://plugins* 看到 *flash* 的 *location* 是 *internal-not-yet-present*，
这应该是没有安装的样子。从 *google* 上搜索了下，发现 *chrome* 不再自带 *flash* 插件了，
需要自己安装。。。

找了下方法，首先需要翻越 *GFW*，方法可以是 *VPN*，也可以 *shadowsocks*。使用代理的话，
在命令行里执行下面的命令：

```
$ google-chrome-stable --proxy-server="127.0.0.1:8888"
```

默认使用 *http代理*。打开 *chrome* 后，访问 *chrome://components*，
点击 *Flash* 下面的检查更新，之后就可以安装成功了。
