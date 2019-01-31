---
author: ety001
layout: post
title: 终于填了 hapijs 中的 catbox 组件的坑
tags:
- hapijs
- catbox
- 前端
---

# 起因

由于最近在开发恒星币的钱包，其中有部分数据，如果直接通过恒星的 API 获取则效率太低，影响页面展示体验。
于是用 `hapijs` 来开发一些定制的接口，批量获取并缓存数据，来提升页面访问效果。

之前在 [《使用 hapijs 快速构建自己的 api 服务》](https://blog.domyself.me/2018/10/09/easy-startup-tuturial-for-hapi.html) 这篇文章中有写到 `hapijs` 默认使用 `catbox` 的 `catbox-memory` 组件来缓存数据。

我这次还是按照上次的方法来使用缓存，但是却没有成功，每次提交请求，都是重新去获取数据，而没有走缓存。

# 祸起文档和配置

翻了好几遍 `hapijs` 的文档，也使用搜索引擎查了，折腾了3个多小时无果，最终决定一边读源码一边在代码加标记输出。

在每个关键位置都打了输出，但是没有看到任何报错和问题。无意中看到了 `hapijs` 文档中的一个配置参数 [generateOnReadError](https://hapijs.com/api#server.cache())，作用是当在读取缓存时遇到错误时是否报错，而默认则是关掉的！！！WTF！！！！

配置这个参数为 `false` 后，得再配合 `try {} catch () {}` 才显示了错误信息，原来是缓存的 `key` 非法。

比较这次和上次使用 `cache` 功能的代码，找到了一个不同点，就是上次是使用的 `string` 作为 `key`，而这次使用的是 `object` 作为 `key`。

不过在 `hapijs` 关于 `cache` 的 [文档](https://hapijs.com/api#server.cache()) 中，关于 `generateFunc` 参数的解释里有一句 `the \`id\` string or object provided to the \`get()\` method.`，看上去 `id` 用 `object` 也没有问题啊。

于是我又去读了 `catbox` 的源码，最终看到 `catbox` 的一段关于获取缓存信息的 [代码](https://github.com/hapijs/catbox/blob/master/lib/policy.js#L88)。

在第88行，原来特么的只接受 `{id: id}` 这种样子的对象啊？！！！！并且上面82行的注释也列出来了。。。

又去看了下 `catbox` 的文档中关于 `get()` 方法的介绍，有这么一句 `id - the unique item identifier (within the policy segment). Can be a string or an object with the required 'id' key.`。

这就恍然大悟了。。。。。。。。。

**原来对象中必须包含 `id` 这个字段啊，原来要是提交对象的话，需要自己来定义索引啊？！！！**

修改下代码，这个坑过了。

不容易不容易啊。。
