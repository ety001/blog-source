---
author: ety001
title: redux ， react-redux 和 redux-saga 什么区别
date: 2024-08-27 17:21:15
layout: post
tags:
- 经验
- 前端
- redux
---

Redux、React-Redux 和 Redux-Saga 是前端开发中常用的状态管理和异步数据处理工具。它们各自有不同的功能和用途。

# 1. Redux

Redux 是一个用于 JavaScript 应用的状态管理库。它提供了一种可预测的方式来管理应用的全局状态。

## Redux 的核心概念包括：

* Store: 存储应用的状态，是唯一的数据源。
* Actions: 是描述状态变化的普通 JavaScript 对象。
* Reducers: 是纯函数，接收当前状态和 action，返回新的状态。
* Dispatch: 用于触发 action，从而引发状态的改变。

## Redux 的特点:

* 单一数据源: 整个应用只有一个状态树（store）。
* 状态是只读的: 不能直接修改状态，必须通过 action 来描述状态变化。
* 纯函数更新状态: Reducers 必须是纯函数，不得有副作用。

# 2. React-Redux

React-Redux 是官方提供的 Redux 和 React 的绑定库。它允许 React 组件与 Redux store 进行连接，使得组件能够访问 Redux 的状态并分发 actions。

## React-Redux 的特点:

* `<Provider>` 组件: 这个组件将 Redux store 提供给应用内所有的组件。
* connect() 函数: 将 React 组件连接到 Redux store，允许组件从 store 中读取状态和分发 actions。
* Hooks: useSelector 和 useDispatch 是 React-Redux 提供的 hooks，用于替代 connect()，更符合函数组件的使用方式。

## Demo Code

```
import { Provider } from 'react-redux';
import { createStore } from 'redux';
import App from './App';
import rootReducer from './reducers';

const store = createStore(rootReducer);

const Root = () => (
  <Provider store={store}>
    <App />
  </Provider>
);
```

```
import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { increment } from './actions';

const Counter = () => {
  const count = useSelector(state => state.count);
  const dispatch = useDispatch();

  return (
    <div>
      <span>{count}</span>
      <button onClick={() => dispatch(increment())}>Increment</button>
    </div>
  );
};
```

# 3. Redux-Saga

Redux-Saga 是一个用于处理 Redux 应用中的异步操作的中间件。它基于 ES6 的 Generator 函数，使得处理复杂的异步逻辑（如异步 API 请求、并发请求、失败重试等）变得更直观和可管理。

## Redux-Saga 的特点:

* Sagas: Generator 函数，用于定义异步操作的逻辑。
* Effects: Redux-Saga 提供了一系列 effects 函数（如 take, call, put 等）用于处理副作用（例如异步调用）。
* 非阻塞调用: 通过 Generator 的 yield 机制，可以使异步操作的代码写起来像同步代码。

## Demo Code

```
import { call, put, takeEvery } from 'redux-saga/effects';
import { fetchDataSuccess, fetchDataFailure } from './actions';
import api from './api';

// 定义 Saga
function* fetchDataSaga(action) {
  try {
    const data = yield call(api.fetchData, action.payload);
    yield put(fetchDataSuccess(data));
  } catch (error) {
    yield put(fetchDataFailure(error));
  }
}

// 监听特定的 action
function* watchFetchData() {
  yield takeEvery('FETCH_DATA_REQUEST', fetchDataSaga);
}

export default watchFetchData;
```

# 总结

* Redux: 用于管理全局状态，提供一个规范化的状态管理框架。
* React-Redux: 是 Redux 和 React 的连接工具，让 React 组件可以访问 Redux 的状态和 actions。
* Redux-Saga: 处理复杂的异步操作，让异步逻辑的管理更加简单和可维护。

这三个工具通常配合使用，以实现复杂的状态管理和异步数据处理。

---

**ET碎碎念，每周更新，欢迎订阅，点赞，转发！**
![](https://cdn.steemitimages.com/DQmNqMmFcstxiRQqGStZSSEPEN4Z23cywF1whi91qbGTXxn/640.gif)

---
#### 好用不贵的VPS推荐
[https://1hour.win](https://1hour.win)