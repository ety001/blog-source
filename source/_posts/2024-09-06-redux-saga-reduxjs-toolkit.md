---
author: ety001
title: redux-saga 如何与 @reduxjs/toolkit 配合使用？
date: 2024-09-06 17:21:15
layout: post
tags:
- 经验
- 前端
- redux
- redux-saga
---

# 前情

Steemit 的几个前端项目（[condenser](https://github.com/steemit/condenser), [wallet](https://github.com/steemit/wallet), [faucet](https://github.com/steemit/faucet)）都使用了 redux 和 redux-saga。

这次升级 faucet 所有依赖库，发现新版本 redux 推荐使用官方的 `@reduxjs/toolkit` 工具集来实现 redux 的功能。

既然 redux 的官方推荐使用工具集，那么这次升级我们也要相对应的把原有的 redux 相关代码做改动。

其中，为了应对复杂的异步请求而引入的 `redux-saga`，我不是很确定是否与工具集兼容，因此投入了时间来研究了一下。

# 如何将 `redux-saga` 与 `@reduxjs/toolkit` 一起使用

* 创建 Redux Store: `@reduxjs/toolkit` 提供了 `configureStore` 来简化 `store` 的创建过程。你可以将 `redux-saga` 中间件添加到 `store` 中。

* 创建并运行 Saga 中间件: 使用 `redux-saga` 的 `createSagaMiddleware` 来创建 `saga` 中间件，然后将其添加到 `configureStore` 中。

* 运行你的 `Saga`: 在 `configureStore` 创建 `store` 后，使用 `sagaMiddleware.run` 来启动你的 `saga`。

下面是简单的例子。

store.js 文件

```
// store.js
import { configureStore } from '@reduxjs/toolkit';
import createSagaMiddleware from 'redux-saga';
import rootReducer from './reducers'; // 你的 reducer
import rootSaga from './sagas'; // 你的 saga

// 创建 Saga 中间件
const sagaMiddleware = createSagaMiddleware();

// 配置 store 并添加 saga 中间件
const store = configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(sagaMiddleware), // 添加 saga 中间件
});

// 运行 rootSaga
sagaMiddleware.run(rootSaga);

export default store;
```

saga.js 文件

```
// sagas.js
import { call, put, takeLatest } from 'redux-saga/effects';
import axios from 'axios';

// worker saga
function* fetchUser(action) {
  try {
    const response = yield call(axios.get, `/api/user/${action.payload.userId}`);
    yield put({ type: 'USER_FETCH_SUCCESS', payload: response.data });
  } catch (error) {
    yield put({ type: 'USER_FETCH_FAILURE', error: error.message });
  }
}

// watcher saga
function* rootSaga() {
  yield takeLatest('USER_FETCH_REQUEST', fetchUser);
}

export default rootSaga;
```

---

**ET碎碎念，每周更新，欢迎订阅，点赞，转发！**
![](https://cdn.steemitimages.com/DQmNqMmFcstxiRQqGStZSSEPEN4Z23cywF1whi91qbGTXxn/640.gif)

---
#### 好用不贵的VPS推荐
[https://1hour.win](https://1hour.win)