---
author: ety001
layout: post
title: Chrome扩展中使用Vuejs
tags:
- Chrome
- Javascript
---

![](/upload/20200107/Z6QxWQWDYgazq6lewQ9A7sVeCNBXbuMYQ8VvC9Ge.png)

我[开发的扩展](https://chrome.google.com/webstore/detail/review-bookmarks/oacajkekkegmjcnccaeijghfodogjnom)四年多了，这两天终于突破了500用户数。很早就想要再进行开发了，但是无奈由于之前代码写的比较乱，并且用的 `jQuery` 去操作，很多东西开发起来还是很费劲的。

现在用户数已经 500 个用户了，之前用户呼声很高的功能，得花点心思搞一下了，要不就对不起这些铁杆用户了！

考虑再三，还是要重构。

`jQuery` 在做一些交互少的功能的时候，还是很不错的选择。不过考虑到接下来要开发的功能的交互的复杂度，我觉得还是要引入 `Vuejs` 或者 `React`。鉴于熟练程度，我最终选择了 `Vuejs`。

由于我的 `Chrome` 扩展中将会使用 `Content Script`，`Popup Page`， `Tab Page`这三种形式，这就意味着，如果我要使用 `Vuejs` 的话，那么我需要用 `Webpack` 配置三个入口和三个文件。

不过让我修改 `Webpack` 配置还好，自己写，真的是太蛋疼了。于是，我找到了这个，[https://github.com/Kocal/vue-web-extension](https://github.com/Kocal/vue-web-extension) 。

这个 `Vue` 模板真的是太好用了，基本上把大部分的工作都做好了。

我们只需要按照 `Kocal/vue-web-extension` 库的文档操作，就可以完成基本的部署。

不过没有 `Content Script` 的支持，我们只需要自己在 `src` 目录下创建个新的目录，比如叫做 `content-script`。

然后创建一个入口文件 `content-script.js`，内容如下：

```
import Vue from 'vue';
import App from './App';
import store from '../store';

global.browser = require('webextension-polyfill');

Vue.prototype.$browser = global.browser;
Vue.use(ElementUI);

/* eslint-disable no-new */
new Vue({
  el: '#review-bookmark',
  store,
  render: h => h(App),
});
```

再创建一个 `App.vue` 文件，内容如下：

```
<template>
  <div>
    <button>测试一下</button>
  </div>
</template>

<script>
export default {
  data() {
    return {};
  },
};
</script>

<style lang="scss" scoped></style>
```

最后创建一个用于初始化的文件 `cs-init.js`，内容如下：

```
const reviewBookmarkDiv = document.createElement('div');
reviewBookmarkDiv.id = 'review-bookmark';
document.body.appendChild(reviewBookmarkDiv);
```

创建好这三个文件后，再打开 `webpack.config.js` 文件，修改 `entry` 项如下：

```
  entry: {
    background: './background.js',
    'popup/popup': './popup/popup.js',
    'tab/tab': './tab/tab.js',
    'content-script/content-script': './content-script/content-script.js',
  }
```

这样就设置好了多个编译入口，最后编译的时候就会在 `dist` 文件夹下生成四个编译好的 `js` 文件。

再修改 `webpack.config.js` 中 `plugins` 项中的 `CopyPlugin` 如下：

```
    new CopyPlugin([
      { from: 'icons', to: 'icons' },
      { from: '_locales', to: '_locales' },
      { from: 'content-script/cs-init.js', to: 'content-script/cs-init.js' },
      { from: 'popup/popup.html', to: 'popup/popup.html', transform: transformHtml },
      { from: 'tab/tab.html', to: 'tab/tab.html', transform: transformHtml },
      {
        from: 'manifest.json',
        to: 'manifest.json',
        transform: content => {
          const jsonContent = JSON.parse(content);
          jsonContent.version = version;

          if (config.mode === 'development') {
            jsonContent['content_security_policy'] = "script-src 'self' 'unsafe-eval'; object-src 'self'";
          }

          return JSON.stringify(jsonContent, null, 2);
        },
      },
    ])
```
这样我们就把扩展需要的必要文件都复制进了 `dist` 目录。尤其是 `cs-init.js`。这个文件在下面会讲。

现在打开 `manifest.json` 文件，调整如下：

```
{
  "name": "__MSG_appname__",
  "description": "__MSG_appdesc__",
  "version": null,
  "manifest_version": 2,
  "default_locale": "en",
  "author": "ETY001",
  "homepage_url": "https://bm.to0l.cn/",
  "chrome_url_overrides": {
    "newtab": "tab/tab.html"
  },
  "icons": {
    "16": "icons/icon-16.png",
    "19": "icons/icon-19.png",
    "38": "icons/icon-38.png",
    "48": "icons/icon-48.png",
    "128": "icons/icon-128.png"
  },
  "browser_action": {
    "default_title": "__MSG_appname__",
    "default_popup": "popup/popup.html"
  },
  "background": {
    "scripts": ["background.js"],
    "persistent": false
  },
  "content_scripts": [
    {
      "matches": ["*://*/*"],
      "css": ["content-script/content-script.css"],
      "js": ["content-script/cs-init.js", "content-script/content-script.js"],
      "run_at": "document_end"
    }
  ],
  "web_accessible_resources": ["tab/tab.html"],
  "permissions": ["activeTab", "notifications", "bookmarks", "tabs", "background", "https://www.google-analytics.com/", "storage"]
}
```

**好了所有的文件都准备好了，接一下原理。**

通过看 `manifest.json` 的 `content_scripts`，可以看到我们引入了 `cs-init.js` 和 `content-script.js`。其中 `cs-init.js` 文件的作用就是为了能在页面里面插入一个 `<div />` 作为模板的插入点，然后 `content-script.js` 就可以把相关的页面和逻辑就能插入进我们准备好的 `<div />` 中去了。

除了 `Content Scripts` 这个坑需要自己填以外，还有一个字体库的坑也需要自己填一下。

由于我还使用了 `Element UI` 库，但是在测试的时候，发现 `font icon` 的库一直引入不了。最后，我用的 `cdn` 上的字体资源。

具体方法在 《[在项目中改变 SCSS 变量](https://element.eleme.io/#/zh-CN/component/custom-theme#zai-xiang-mu-zhong-gai-bian-scss-bian-liang)》这个文档中可以看到，只需要修改 `font-path` 这个参数即可，如下：

```
/* 改变主题色变量 */
$--color-primary: teal;

/* 改变 icon 字体路径变量，必需 */
$--font-path: 'https://cdnjs.cloudflare.com/ajax/libs/element-ui/2.13.0/theme-chalk/fonts';

@import '~element-ui/packages/theme-chalk/src/index';
```

OK，花了两天的时间，把基础框架搭建好了！接下来就可以开始重构工作了，剩下的相对就简单了。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
