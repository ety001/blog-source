---
author: ety001
title: Redux 的 createStore 在编辑器中被提示弃用
date: 2024-08-28 17:21:15
layout: post
tags:
- 经验
- 前端
- redux
---

在 React 18 中，`createStore` 是 `Redux` 提供的一个函数，用于创建 `Redux store`，但从 `Redux Toolkit v5` 开始，`createStore` 已被标记为弃用，并建议使用 `configureStore` 作为替代。

`configureStore` 是 `Redux Toolkit` 中提供的一个函数，它简化了 `Redux` 的配置过程，内置了 `Redux DevTools`、默认的中间件配置等。

下面是如何使用 `configureStore` 替代 `createStore` 的一个简单示例：

```
import { configureStore } from '@reduxjs/toolkit';
import rootReducer from './reducers';

const store = configureStore({
  reducer: rootReducer,
});

export default store;
```

这次重构 faucet 将会替换掉 `createStore` 方法。
