---
author: ety001
layout: post
title: Google Analytics Api 使用
tags:
- Chrome
- Javascript
- Google Analytics
---

最近在做浏览器扩展《[温故知新](https://creatorsdaily.com/9999e88d-0b00-46dc-8ff1-e1d311695324?utm_source=vote)》的新版本。其中，最让我头疼的就是用 `Google Analytics` 统计信息了。

Google 官方提供的 `SDK` 使用的话，需要外部引入 `SDK`，并且配置 [CSP](https://developer.chrome.com/extensions/contentSecurityPolicy)，而 `Firefox` 浏览器不允许配置 `CSP`。

无奈，只能自己去写一个简单的封装了。

```
export class GA {
  constructor(ua, cid, debug = false) {
    this.ua = ua;
    this.cid = cid; // client id
    this.gaApi = debug ? 'https://www.google-analytics.com/debug/collect' : 'https://www.google-analytics.com/collect';
    this.version = '1';
  }
  ga(t, ...items) {
    let payload = `v=${this.version}&tid=${this.ua}&cid=${this.cid}`;
    let params = [];
    switch (t) {
      case 'pageview': // Pageview hit type
        // dh -- Document hostname
        // dp -- Page
        // dt -- Title
        params = ['dh', 'dp', 'dt'];
        break;
      case 'event':
        // ec -- Event Category. Required
        // ea -- Event Action. Required
        // el -- Event label.
        // ev -- Event value.
        params = ['ec', 'ea', 'el', 'ev'];
    }
    if (params === []) return;
    payload = `${payload}&t=${t}`;
    items.forEach((v, i) => {
      payload = `${payload}&${params[i]}=${encodeURIComponent(v)}`;
    });
    const request = new XMLHttpRequest();
    request.open('POST', this.gaApi, true);
    request.send(payload);
  }
}

const uid = 'xxxx-xxxx-xxx-xxx';
const debug = false;
const gaID = 'UA-xxxxxx-x';
const gaObj = new GA(gaID, uid, debug);
function sendEvent(eventCategory, eventAction, eventLabel = '', eventValue = 1) {
  if (store.getters.config.ga === false) return;
  gaObj.ga('event', eventCategory, eventAction, eventLabel, eventValue);
}
// dh -- Document hostname, dp -- Page, dt -- Title
function sendPageview(dp, dh = '', dt = '') {
  if (store.getters.config.ga === false) return;
  gaObj.ga('pageview', dh, dp, dt);
}
```

这就是我根据[官方文档](https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide)简单写的封装。

**这里面需要注意几个问题。**

一个是正式环境的地址是 `/collect` 而测试地址是 `/debug/collect`。这个在之前的时候，没有注意到还有测试地址，所以绕了弯路，也没有发现提交的参数错误。

另外一个就是在 `event` 类型中，`Event value` 必须是整型。

还有个小技巧，就是调试的时候，可以切换到“实时”选项卡，在那下面可以看到发送到 `/collect` 的实时数据。