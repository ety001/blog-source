---
author: ety001
layout: post
title: '关于pymysql的两个坑'
tags:
- 经验
---

在使用 *pymysql* 的时候遇到的两个坑。

第一个，在 *pymysql* 中 *sql* 语句中的占位符并不是 *Python* 中常规的占位符，*sql* 中的所有占位符都是 `%s`。如果你在 *sql* 中使用了类似 `%d` 这样的占位符，你会得到类似 `TypeError: %d format: a number is required, not str` 这样的错误提示。参考：[https://stackoverflow.com/questions/5785154/python-mysqldb-issues-typeerror-d-format-a-number-is-required-not-str](https://stackoverflow.com/questions/5785154/python-mysqldb-issues-typeerror-d-format-a-number-is-required-not-str)

第二个坑，依旧是使用规则上的问题，先看代码：

```
sql = "insert into TABLE (col_a, col_b) values (%s, %s)"
data = ("abc", "xyz")
cursor.execute(sql, data)

sql = "insert into TABLE (col_a, col_b) values ('%s', '%s')" % ("abc", "xyz")
cursor.execute(sql)
```

以上两种用法都是可以的，但是坑就在于不要混用，比如下面这两种情况：

```
sql = "insert into TABLE (col_a, col_b) values (%s, %s)" % ("abc", "xyz")
cursor.execute(sql)

sql = "insert into TABLE (col_a, col_b) values ('%s', '%s')"
data = (("abc", "xyz"), ("efg", "uvw"))
cursor.executemany(sql, data)
```

**由于 *pymysql* 里有相应的机制来处理传入的 *sql* 语句和数据，但是机制并不完善，所以混用将会导致有多余的引号出现。**