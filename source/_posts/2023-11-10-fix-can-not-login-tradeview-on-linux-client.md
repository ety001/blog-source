---
author: ety001
date: 2023-11-10 13:25:31+00:00
layout: post
title: 解决 snapcraft 安装的 Tradingview 无法登陆的问题
tags:
- 经验
- Tradingview
- Snapcraft
---

在 Archlinux 下通过 snapcraft 安装了 Tradingview。但是登陆是通过浏览器网页登陆后，跳转回程序完成登陆。

而 Chrome 浏览器调用 xdg-open 打开 `tradingview://` 格式的 URI 时，提示找不到程序，无法打开。

解决方法就是在 `~/.config/mimeapps.list` 中，在 `[Default Applications]` 块里加入下面一行

```
x-scheme-handler/tradingview=tradingview_tradingview.desktop
```

保存退出后，可以执行下面的命令，查看是否添加成功

```
xdg-mime query default x-scheme-handler/tradingview
```

之后，再次登陆即可成功跳转到 Tradingview 程序。