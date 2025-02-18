---
author: ety001
title: 使用 createRoot 方法，报 React is not defined 错误
date: 2024-08-29 17:21:15
layout: post
tags:
- 经验
- 前端
- react
---

由于 faucet 项目全部是手动搭建的环境，所以在把 react15 升级到 react18 后，

```
import { createRoot } from 'react-dom/client';

const appElement = document.getElementById('app');
const root = createRoot(appElement);
root.render(<h1>Hello, world</h1>);
```

使用上面的代码测试环境是否搭建成功的时候，报 `React is not defined` 错误。

原因是：在 React 18 中，虽然可以使用 `createRoot` 来渲染组件，
但仍然需要显式地导入 React 以支持 JSX 语法。

在 JSX 中，`<h1>Hello, world</h1>` 会被编译成 `React.createElement('h1', null, 'Hello, world')`。
因此，即使你没有直接使用 React，它仍然需要被导入。

由于 `babel` 我也升级到最新了，在 7.9 版本后，可以使用 `@babel/preset-react` 来自动引入 JSX 转换。
而不用去显式的导入 React 了。

具体方法就是在 `babel.config.js` 中对 `@babel/preset-react` 增加配置如下：

```
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": "defaults"
      }
    ],
    [
      "@babel/preset-react",
      {
        "runtime": "automatic"  // 使用自动引入模式
      }
    ]
  ]
}
```

如此设置后，再次编译执行，报错就没有了。

---

**ET碎碎念，每周更新，欢迎订阅，点赞，转发！**
![](https://cdn.steemitimages.com/DQmNqMmFcstxiRQqGStZSSEPEN4Z23cywF1whi91qbGTXxn/640.gif)

---
#### 好用不贵的VPS推荐
[https://1hour.win](https://1hour.win)
