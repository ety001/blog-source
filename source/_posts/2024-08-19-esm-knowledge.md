---
author: ety001
title: ESM 模式导入文件的一些常识
date: 2024-08-19 17:21:15
layout: post
tags:
- 经验
- 前端
- javascript
---

每次看完用完，因为别的项目又切换到非 js 语言，过段时间就又忘了，所以写下来总结一下，要不然每次都要现搜索。

# 使用 import 导入的时候是否加扩展名？

是的，在 ESM 模式下，使用 import 时需要包含文件的扩展名。

这是因为 ESM 模块解析严格遵循文件路径规范，不像 CommonJS 那样自动推断 .js、.json 或 .mjs 等扩展名。

假设有下面的文件结构
```
project/
├── app.js
└── utils/
    └── helper.js
```

在 app.js 中，你需要这样导入 `helper.js`：
```
import { myHelperFunction } from './utils/helper.js';
```

# 加 {} 和不加 {} 的区别

在 JavaScript 中，import 语句的语法有两种主要形式：具名导入和默认导入。

加 {} 和不加 {} 的区别在于你是导入模块中的一个具名导出还是默认导出。

## 1. 具名导入 (Named Import)

```
// utils.js
export const myFunction = () => {
  console.log('This is myFunction');
};

export const anotherFunction = () => {
  console.log('This is anotherFunction');
};

// main.js
import { myFunction } from './utils.js';

myFunction(); // 输出: This is myFunction
```

## 2. 默认导入 (Default Import)

```
// utils.js
const myFunction = () => {
  console.log('This is myFunction');
};

export default myFunction;

// main.js
import myFunc from './utils.js';

myFunc(); // 输出: This is myFunction
```

> 这里对我来说，如果不看文档，纯靠我自己的经验
> 我一直以为不加 {} 的时候，是把整个文件导出的
> 也就是按照例子的代码，我的直观感觉应该是 `myFunc.myFunction()`