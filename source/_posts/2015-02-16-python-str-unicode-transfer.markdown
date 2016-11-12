---
author: ety001
comments: true
date: 2015-02-16 16:07:58+00:00
layout: post
slug: python-str-unicode-transfer
title: python中str和unicode转换问题
tags:
- 编程语言
---

这两天在写一个python脚本，以实现把数据从多个excel导入进一个mdb中，遇到了比较纠结的问题，

下面的代码是我把问题简化后的代码：

```
test = u'测试'
print(str(test))
```

执行后的报错信息如下：

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
UnicodeEncodeError: 'ascii' codec can't encode characters in position 0-1: ordinal not in range(128)
```

在python下两者的转化需要使用decode和encode，具体情况如下：

```
a = '测试' # str类型
b = u'测试' # unicode类型

a.decode() # 把str类型解码，即为unicode类型
b.encode('utf-8')  # 把unicode类型编码，即为str类型
```
