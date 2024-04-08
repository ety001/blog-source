---
author: ety001
layout: post
title: 解决Chrome扩展content script中的css冲突
tags:
- Chrome
- Javascript
---

这次重构[我的Chrome扩展](https://chrome.google.com/webstore/detail/review-bookmarks/oacajkekkegmjcnccaeijghfodogjnom)由于引入了很多新的东西，所以遇到的小问题还是挺多的。

比如在 `content script` 模式中，我的UI样式会被某些网站的 CSS 给影响到，以至于我的插件的 UI 显示不是预期。

在开发文档中，对于 `manifest.json` 中的 `content_scripts` 的 `CSS` 描述是： Optional. The list of CSS files to be injected into matching pages. These are injected in the order they appear in this array, **before any DOM is constructed or displayed for the page**.

这就是为啥 `Tab` 中网页可能会影响我的插件 UI 的原因。

因为我的插件的 `CSS` 早于 `Tab` 中网页的载入，这样 `Tab` 中网页里的 `CSS` 里面如果有重名的 `Class` 或者直接对 `HTML` 标签加样式，就会影响到我。

之前的版本，因为我是自己手写样式，且都用的 `div` 标签，所以很大程度上避免了冲突。

而这次重构引入了饿了么的 `UI`，所以增大了冲突的概率。我在 `content script` 中用的是 `notification` 这个组件，里面涉及到了 `<h2 />`，`<i />`这两个标签。有些网站是直接对这两个标签先进行样式全局设置的，这就导致在访问这些网站的时候，我的 `UI` 会受到影响。

目前我采用的解决方案是，把饿了么的 `UI` 库克隆到我的账号下，然后自己修改里面的代码，把 `<h2 />`，`<i />` 替换成别的标签，重新打包，引入我自己定义的库后，问题得到解决。
