---
title: 最近升级了我的『温故知新』Chrome插件，现在写写心路历程
author: ety001
tags:
- 随笔
layout: post
---
春节假期快结束的时候，终于是找到了些时间来埋一埋去年的坑。经过2.2.0到2.2.6几个版本，终于把新版完成了。

在去年年中的时候，我开发了一款chrome应用，目的是为了方便自己整理自己的书签栏。想法很简单，就是利用零碎的时间去review自己的书签栏，没有用的就可以删除掉了。毕竟，单独拿出时间去整理书签栏，是个很累人的活，把这个活分散成零碎的时间去完成，倒也惬意。

这个想法其实是四年前的，只不过一直没去做罢了。每当自己的书签栏迫切需要整理的时候，就会想起来这个想法。终于在去年7月左右开始动工了。

不过开发进展不是很顺利，毕竟自己不是个专业前端，英语水平也一般，看chrome的文档就耗费了很多精力。先是把整个的chrome的文档页面的结构理顺了一下。真的是很想吐槽下chrome开发的文档组织的很糟糕，Api接口的列表的进入放在了一个三级的目录中，几乎每次要找一个Api接口的时候，都要翻好久，主要是找一级菜单就要花好久。

后来习惯后，也就习惯了。。。

最初的计划是能够每次打开新标签页的时候，自动提醒一次，提醒的数据是随机从书签栏里获取，使用 Chrome 的 Notification 接口显示书签名和地址，并提供打开和删除按钮。（原始想法，雏形）

但是在开发的过程中，首先发现的问题是，随机获取一个书签并不是像自己想的那样。
本来计划是扩展安装的时候，自动把书签一次性读入到html5的本地存储中去，然后从本地存储中随机获取。但是这里面涉及到几个点：

```
1、使用何种本地存储能方便的检索数据？
2、用户变动书签信息（增加、删除）的时候，还需要同步到本地存储中。
```

考虑到后期可能会迁移到 Firefox 和 Safari，于是选择本地存储的时候，我除了考虑数据的获取外，还参考过兼容列表。最终觉得还是先不要想那么远了，先把chrome版本的做好再说其他的。于是选择了IndexedDB。

然后的问题就是如何随机。在考虑这个问题的时候，我最先想到的就是获取本地存储中的书签列表的索引范围，然后写个方法来从这个索引范围中随机一个数。但是后来觉得这样不是很妥，如果随机性不是很好的话，那么可能某些书签被随机到的概率很大，那么效果就不理想了，或者是某个书签连续几次都被随机到，那么用户体验也是不好的。

那么能不能加个访问量的字段，然后把这个字段纳入到随机数的计算中呢？倒是可以，不过貌似这样程序就复杂了太多了，我也不知道最后做出来的效果是否满意，所以最后就放弃了随机一条书签的计划，改成顺次提取一条书签了。实验证明，这个方案至少我自己是满意的。

另外的就是找到书签的监听接口，在用户操作书签的时候，能把数据同步到本地存储中。不过这里当时为了赶时间尽快做出来看效果，就省掉了数据同步，而是每次打开新标签页获取一条书签的时候，都会读一遍全部的书签列表，然后把索引记录在本地存储中，以及这次访问的索引值存储在本地存储中。

第一版差不多就这样勉强的上线了。

上线后，发现还是有不少人来安装，真的是很感谢这些初期的用户。但是貌似我没有具体的运营数据。于是又研究了下 Google Analytics，在扩展中加入了一些操作事件的记录，依次来看一下，现在有多少人在用，提醒了多少次书签，删除了多少次书签。依次来判断我的扩展的价值。

之后，有用户开始反馈。反馈的主要问题就是弹出框和不再提醒机制。

弹出框的第一个问题，主要就是各个操作系统的 notification 差异性导致的。在 Win 下，notification 是在右下角弹出，而 Mac 和 Linux 下是在右上角。我的开发环境是 Mac，所以最初在右上角弹出，我觉得可以，就没有多留意。后来 Win 用户提出来能不能把提醒从右下角放到右上角，我才发现了这个问题。

弹出框第二个问题，右上角弹出的时候，有时候可能正好挡住了标签页的关闭按钮（在标签页打开了很多的时候），这样进行关闭标签页的操作时，要先关闭 notification ，才能点击标签页的关闭，显得很不方便。

弹出框的第三个问题，chrome升级某个版本后，notification 不再自动关闭了，只能手动关闭了。

弹出框的第四个问题，chrome 的 notification 只支持添加最多两个按钮，而当前已经有『打开标签页』和『删除』两个了，想再增加『不再提醒』按钮是不可能了。

关于『不再提醒』功能，是用户提出来的，希望能够把一些书签设置为『不再提醒』。

针对用户提出来的这些问题，我一直都很想处理，最后还是拖到了年后。

年后第一版v2.2.0，重构了本地存储部分，把书签存储在了 localStorage 中，并且完成了用户变动书签后，自动同步到 localStorage 中，这样每次取数据的时候，只需要从 localStorage 中获取 bookmark_id ，然后再调用 Api 取详细信息即可。这样也便于以后向 Firefox 和 Safari 迁移。

v2.2.0 -- v2.2.2 还弃用了 notification 接口，使用替换『新标签页』的方式，我自己写了一个 html 页面，可以显示书签标题和网址，带 iframe 预览功能，带『新标签页打开』，『删除』，『不再提醒』等按钮。

上线后，好几个用户反馈能不能不替换新标签页。其实我最初也是不想替换的，但是无奈 chrome 应该处于安全考虑，不允许向 chrome://newtab/ 插入js代码，所以我也是不得已为之啊。

不过经过思考，觉得没必要非要在『新标签页』中进行提醒呀。于是开始开发迷你模式，即把弹层放到了正常的网页中去，也就是现在 v2.2.6 版本大家所看到的。

到此，这个扩展应该基本上就完成了。估计短时间内是不需要增加或者修改什么功能了。

总结一下，开发扩展基本上就跟开发传统软件是一样的了，应该要遵循传统的流程。平时自己写 PHP 网站写习惯了，遇到问题随时修改随时上线。现在扩展出个bug，至少要60分钟才能发布完毕，等用户升级到新版本还不知道什么时间。我在开发的时候，经常遇到的就是这个问题，某个版本发布前已经测试的很不错了，结果在商店点击完发布了，又用了几次就发现新问题了，导致自己不得不增加版本号，重新上传修复bug后的版本进行发布。

另外就是需要加强与用户的沟通和交流，现在感觉做的最不足的就是这一点。其次就是交流后，用户反馈的哪些该采纳，哪些该舍弃，还是个很让我迷惑的问题。这个还需要再思考思考。

最后，附上扩展地址和反馈地址：

<http://bm.to0l.cn/>

<https://gitter.im/ety001/bookmark-extension>

