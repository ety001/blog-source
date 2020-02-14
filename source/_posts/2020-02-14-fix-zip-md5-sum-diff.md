---
author: ety001
layout: post
title: 解决每次zip压缩后的md5不同的问题
tags: Chrome
---

最近为了把新版的**[温故知新](https://creatorsdaily.com/9999e88d-0b00-46dc-8ff1-e1d311695324?utm_source=vote)**扩展上传到各个浏览器，真的是操碎了心了。这篇文章就来说说在通过火狐审核的时候的遇到的最棘手的问题。

由于我的扩展使用了 `webpack`，代码 `build` 后，没有可读性，所以火狐要求需要上传源代码，然后会进行审查。审查的步骤就是根据我提供的源代码和编译方法，审核人员编译一次，然后把编译后的代码打包，最后与我上传的压缩包比对，看是否一致。负责审查我的那位审查员，用的是 `Beyond Compare` 这个软件来检查两个压缩包是否一样。

最开始并没有注意到这里，审查员说他的编译结果跟我的不一样，我以为是我的开发环境对打包环境有污染。所以再次送审的时候，我是直接从 `github` 上下载的源码，重新来了一遍。结果审查结果依然是不一致。

于是我在本地进行测试，发现即使我在自己本地，两次编译后，用`zip`打包后的文件 `md5 sum` 都不一样。

WTF！

经过各种查询，最后确定应该是文件的 `metainfo` 导致的，看了下 `zip` 命令的参数，发现 `-X` 可以移除 `metainfo` 来打包，于是使用命令 `zip -r -X extension.zip dist/` 打包，对编译后的 `dist` 目录打包了两次，对比了下，发现终于特么的一致了。

既然一致了，就赶紧更新审核包和审核文案吧。就在更新过程中，我突然想到，我应该按照审核员的步骤再操作一遍，于是我又从下载源码开始来了一遍，最后惊奇的发现，这一遍生成的压缩包和上一遍的压缩包 `md5 sum` 又特么的不一样啊！！！！

经过各种试验后，排除了大部分的可能，最后猜测应该是文件日期导致的，毕竟前后两遍编译，经过各种排除后，只有时间这个变量了。

于是我用 `find dist | xargs touch -mt 202002110000` 先对编译结果强制修改文件的时间，然后再打压缩包，然后再从源码来一遍后，也修改成这个时间，再打包，最后对比两个压缩包的 `md5 sum`，终于一样了！！！！

最后提交审核，两天后，终于过审了！！！！！

对于书签巨多的人来说，我这个插件值得你去体验下~~~

**Chrome版地址**：[https://chrome.google.com/webstore/detail/review-bookmarks/oacajkekkegmjcnccaeijghfodogjnom](https://chrome.google.com/webstore/detail/review-bookmarks/oacajkekkegmjcnccaeijghfodogjnom)

**Firefox版地址**：[https://addons.mozilla.org/zh-CN/firefox/addon/review-bookmarks/](https://addons.mozilla.org/zh-CN/firefox/addon/review-bookmarks/)

**Microsoft Edge版地址**：[https://microsoftedge.microsoft.com/addons/detail/pibjmfgfgamgohlaehhhbdkjboaopjkj](https://microsoftedge.microsoft.com/addons/detail/pibjmfgfgamgohlaehhhbdkjboaopjkj)

**反馈**：[https://creatorsdaily.com/9999e88d-0b00-46dc-8ff1-e1d311695324?utm_source=vote](https://creatorsdaily.com/9999e88d-0b00-46dc-8ff1-e1d311695324?utm_source=vote)

##### 欢迎使用，欢迎点赞！！