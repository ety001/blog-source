---
author: ety001
layout: post
title: 在Chrome扩展的Content Scripts中使用@font-face
tags:
- Chrome
- Javascript
---
在 [《Chrome扩展中使用Vuejs》](/2020/01/07/chrome-extension-vuejs.html) 文章中，我们提到过 `@font-face` 我是用的 `CDN` 的方式来搞定的。但是用 `CDN` 的缺点就是网络不畅的时候，扩展中使用 `@font-face` 的地方显示就是个方块了。

为了解决这个问题，我搜索了下，找到了解决方案。

这里面有几个要点，一个是字体文件可以在任意页面访问到，一个是如何获取到扩展ID。

正常情况下，扩展的资源文件是与所有网页隔离开的，扩展相当于是在一个沙盒里面运行，如果想要在 `Content Scripts` 模式下，让 `JS` 或者 `CSS` 文件访问到扩展中的资源文件，那么就需要在 `manifest.json` 中增加配置项 `web_accessible_resources`。

```
"web_accessible_resources": ["fonts/*"]
```

就像上面这样增加配置后，我们就可以在 `Content Scripts` 模式下访问到 `fonts/` 目录下的所有资源文件了。

再来说下第二个问题。

我们知道扩展的地址结构是 `chrome://[扩展ID]`，那么我们的 `CSS` 文件中的 `@font-face` 的路径中的扩展ID该怎么获取呢？

通过看文档，找到了预设值 `__MSG_@@extension_id__`，这是出处：[https://developer.chrome.com/extensions/i18n#overview-predefined](https://developer.chrome.com/extensions/i18n#overview-predefined)

那么我们去修改下 `element-variables.scss` 中的 `font-path` 像这样：
```
$--font-path: 'chrome-extension://__MSG_@@extension_id__/fonts';
```

这样，最关键的两个问题就解决了，最后只要在 `webpack.config.js` 中需要复制的操作里，增加复制字体文件的操作即可，就像这样：

```
new CopyPlugin([
  ......
  { from: '../node_modules/element-ui/lib/theme-chalk/fonts', to: 'fonts' },
  ......
]),
```

通过这样设置后，我们通过扩展插入到网页中的 `CSS` 文件就能直接访问到扩展中的资源文件了。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
