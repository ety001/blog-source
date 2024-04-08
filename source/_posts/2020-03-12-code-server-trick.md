---
author: ety001
layout: post
title: Code Server使用小技巧--禁用浏览器标签页关闭
tags:
  - 经验
  - 配置
  - code server
---
最近在我工作用的台式机上部署了传说中的、微软的 **Code Server**。

**Code Server** 其实就是微软 **Code editing** 的服务器版，可以通过在你的服务器上，通过 **Docker** 容器建立一个网页 **IDE**，这样能做的事情就太多了。

比如我现在需要经常出门，而我的工作环境都在台式机上，有时候出门仅几个小时，在笔记本上可能代码都没有写完，就回家了，要把工作进度转移到台式机上就很麻烦。

现在用了 **Code Server** 后，我出门在笔记本上，只要用 **SSH** 把家里台式机的相关端口映射到笔记本的本地，就可以获得跟在台式机上开发几乎一致的开发体验。

不过里面也有一点很不爽，就是经常会习惯性的按 **Command + W** 想去关闭 **Code Server** 里的标签页，结果就是触发了浏览器的快捷键，把整个网页都关掉了。

从网上搜索了一下，发现了一个[非常赞的方法](https://github.com/cdr/code-server/issues/53#issuecomment-563350766)，就是通过参数，让 **Chrome** 以 **App** 的形式运行，这样就可以自动屏蔽掉一些快捷键，其中包括 **Command + W**，更厉害的是，**Command + W** 可以像 **IDE** 里一样，关闭当前的代码标签页。

具体命令就是

```
chrome --app=http://localhost:8080
```

如果你是OSX系统，那么命令就是

```
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app=http://localhost:8080
```

最后的效果就是这样：

![WX20200313-013203@2x.png](/upload/20200312/WX20200313-013203@2x.png)
