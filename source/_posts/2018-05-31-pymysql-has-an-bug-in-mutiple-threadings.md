---
author: ety001
layout: post
title: PyMysql 在多线程下的问题
tags:
- 经验
---
最近在使用 Python 重写 LightDB 的第二层的数据转换程序，因为之前 PHP 版的转换程序效率太低了（主要是设计思路的问题）。使用 Python 换了个思路来实现。

现在发现了 PyMysql 在多线程下工作异常，示例代码大致如下：

![](https://steemeditor.com/storage/images/SsGMFPAiBjfavtpXzIIG3akSHovOkpMSttxiPxS9.png)

执行效果如下：

![](https://steemeditor.com/storage/images/cDEQhhhyThI4sJI9m4M9jsdMOJXn71GHDEO2bTWO.png)

通过搜索引擎找到这个 Issue ([https://github.com/PyMySQL/PyMySQL/issues/422](https://github.com/PyMySQL/PyMySQL/issues/422))，在 7 楼有提到，

```
See https://www.python.org/dev/peps/pep-0249/#threadsafety

PyMySQL's threadsafety is 1.
```

解决方案，在这个 Issue 中也提到了，就是一个 process/thread 中开一个 mysql 的连接。

Oh my god !!!!!

这显然并不好！

另外，@oflyhigh O哥给找到了一个小哥写的库，[https://github.com/jkklee/pymysql-connpool](https://github.com/jkklee/pymysql-connpool) ，这个库的目的就是实现一个 Mysql connection pool 来解决多线程的问题。准备尝试下这个库。感谢 O哥。