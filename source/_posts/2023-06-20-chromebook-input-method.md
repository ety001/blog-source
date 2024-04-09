---
author: ety001
date: 2023-06-20 13:25:31
layout: post
title: Chomebook 配置真文韵输入法的翻页使用逗号和句号
tags:
- 配置
- 经验
- chromebook
- fydeos
---

[真文韵输入法](https://chrome.google.com/webstore/detail/%E7%9C%9F%E6%96%87%E9%9F%B5%E8%BE%93%E5%85%A5%E6%B3%95/ppgpjbgimfloenilfemmcejiiokelkni?hl=zh-CN) 是 fydeOS 团队开发的，基于 RIME 引擎，针对 ChromeOS 的输入法集成。

给中文用户第三方输入法选择方案。

但是目前还处于早期阶段，因此 UI 配置界面很简陋，可以自己通过 RIME的配置文件，按照自己的需求更改。

比如我习惯的翻页方法是逗号和句号，而这个默认不支持的。

需要我们自己修改一下配置。

在编辑 RIME 配置文件里，找到 `/root/build` 目录下面 yaml 配置文件，命名则是根据你安装的输入法来确定的。

打开 yaml 格式配置文件，找到 `key_binder: bindings` 选项，删除掉原来的 `Page_Down` 和 `Page_Up` 配置，增加下面两行配置：


```
- {accept: "comma", send: Page_Down, when: paging}
- {accept: "period", send: Page_Up, when: paging}
```

保存后，等待输入法重载即可。