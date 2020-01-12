---
author: ety001
layout: post
title: 用 js 控制 manifest.json 的 chrome_url_overrides
tags:
- Chrome
- Javascript
---

[我的Chrome扩展](https://chrome.google.com/webstore/detail/review-bookmarks/oacajkekkegmjcnccaeijghfodogjnom)重构进度已经60%了，目前又遇到了新问题。

这个问题的缘由得慢慢说来。

我的扩展由于需要用自定义的页面替换新标签页。在我的早期版本的实现是[这样的](https://github.com/ety001/bookmark-extension/blob/5a384bd15b/js/background.js#L11):

```
chrome.tabs.onCreated.addListener(function(tab){
  if(Mini.get_status()=='off'&&(tab.url=="chrome://newtab/"||tab.url=="chrome://newtab")){
    chrome.tabs.update(tab.id, {url:chrome.runtime.getURL('show.html')});
  }
});
```

也就是新建标签页的时候，用我自己的页面 URL 替换掉 Chrome 默认页面。

后来，Chrome 在某个版本后，新建标签页后，地址栏是空的，也就是 `tab.url` 是没有值，这就导致我之前的代码就失效了。

查看文档，发现正确的方法是在 `manifest.json` 中增加 `chrome_url_overrides` 这个选项，具体可以[查看这里](https://developer.chrome.com/extensions/override)。

这就引入了新的问题。

我的扩展里原来是有一个开关的，这个开关可以控制新标签页是否显示我的自定义页面，也就是上面代码里的那个 `Mini.get_status() == 'off'`。

现在用了 `manifest.json` 直接替换掉了默认页，而 `manifest.json` 是无法在扩展里修改的，同时 Chrome 没有提供相关的 API，那么如何实现这个开关就很尴尬了。

这个 BUG 我一直放着没有处理。

这次重构进行到了自定义页面重构后，这个问题就必须要解决了。

最终的解决方案是，监听页面更新，如果 URL 符合 `chrome://newtab/`，那么就替换成访问 `chrome-search://local-ntp/local-ntp.html`，代码如下：

```
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (tab.url === 'chrome://newtab/') {
    if (store.getters.config.mini === false) {
      chrome.tabs.update(tabId, { url: 'chrome-search://local-ntp/local-ntp.html' });
    }
  }
});
```

之所以用 `chrome.tabs.onUpdated`，有两个原因：一个是因为 `onCreated` 拿不到 URL，一个是在当前标签页，如果点击主页按钮的时候，也会进入 `chrome://newtab/`。
