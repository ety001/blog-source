---
author: ety001
title: React 中 useEffect 的依赖项如何理解
date: 2024-09-21 17:21:15
layout: post
tags:
- 经验
- 前端
- react
---

在 React 中，useEffect 的依赖项决定了其什么时候执行。

# 基本语法

useEffect 接受两个参数：

* 副作用函数：在组件渲染后或依赖项发生变化时执行的函数。
* 依赖项数组（可选）：决定副作用函数何时重新执行。

```
useEffect(() => {
  // 副作用逻辑
}, [dependency1, dependency2, ...]);
```

# 依赖项的常见场景与解释

1.无依赖项数组（每次渲染都会执行）： 如果不传入依赖项数组，useEffect 中的副作用函数将在每次组件渲染后都执行。

```
useEffect(() => {
  console.log('This runs after every render');
});
```

场景：这种用法不常见，通常用于希望在每次渲染时执行某些逻辑，但要注意性能开销。

2.空依赖项数组（只在组件挂载和卸载时执行）： 如果传入一个空数组 []，则 useEffect 只会在组件挂载时运行一次，并在组件卸载时运行清理函数（如果提供了）。

```
useEffect(() => {
  console.log('This runs only on mount');
  return () => {
    console.log('This runs on unmount');
  };
}, []);
```

场景：通常用于初始化数据（例如组件挂载时的 API 请求），或在组件卸载时执行清理操作（例如清理定时器、取消订阅等）。

3.具有依赖项的数组（依赖项变化时执行）： 当传入特定的依赖项时，useEffect 只有在这些依赖项的值发生变化时才会重新执行。

```
useEffect(() => {
  console.log('This runs when count changes');
}, [count]); // 当 count 变化时副作用重新执行
```

场景：用于根据某个特定状态或 prop 变化来执行副作用逻辑。例如，当 count 变化时，可能需要重新获取某些数据或触发其他副作用。

4.多个依赖项： 可以在依赖项数组中传入多个依赖项，useEffect 将会在其中任何一个依赖发生变化时重新执行。

```
useEffect(() => {
  console.log('This runs when count or user changes');
}, [count, user]);
```

场景：用于当多个状态或 prop 变化时，重新执行某个逻辑。例如，可能需要在 count 或 user 变化时重新发起某个 API 请求。

# 如何选择依赖项

1.依赖项的选择要遵循以下原则：
* 副作用函数中使用的所有外部变量：任何在 useEffect 中使用的外部变量（函数组件中的状态、props 等）都应该作为依赖项传入。这是因为这些变量在每次渲染时都可能更新，你需要确保 useEffect 在依赖的值发生变化时执行。
* dispatch 和其他稳定函数：通常像 dispatch（来自 useDispatch）这样的函数引用是稳定的（即在多次渲染之间不会改变），所以可以安全地放入依赖项数组中。如果某个函数引用在不同渲染周期中保持不变，就可以把它作为依赖项。

2.常见的误区与优化：
* 忘记依赖项：如果 useEffect 中依赖的某些值没有包含在依赖项数组中，可能会导致副作用函数使用了过时的值（也称为“闭包陷阱”）。例如，依赖于某个 state 却没有将其加入依赖项数组，这样的结果是 useEffect 中的逻辑不会随着 state 的变化重新执行。
* 过度依赖不必要的变量：有时候不小心将不必要的变量放入依赖项数组，导致 useEffect 过于频繁地执行，浪费性能。例如，不必要地将某些稳定的变量放入依赖项。


---

**ET碎碎念，每周更新，欢迎订阅，点赞，转发！**
![](https://cdn.steemitimages.com/DQmNqMmFcstxiRQqGStZSSEPEN4Z23cywF1whi91qbGTXxn/640.gif)

---
#### 好用不贵的VPS推荐
[https://1hour.win](https://1hour.win)