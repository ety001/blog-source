---
author: ety001
layout: post
title: 'pymysql又莫名踩到一个坑'
tags:
- 经验
---

通过跑前几天的脚本，发现网络不稳定会导致区块数据同步不全，因此还需要写一个守护脚本，定期去检查下未完成的区块，并完成同步。

但在写的过程中发现了一个坑，目前还没有找到触发的原因，临时找到了解决方案。

下面就是简化版的问题代码：

```
#!/usr/bin/python3
#encoding:UTF-8
import sys, time
from contextlib import suppress
import pymysql
# init db
try:
    conn = pymysql.connect(
        host = "steem-lightdb.com",
        user = "steem",
        password = "steem",
        database = "steemdb",
        charset = 'utf8',
        cursorclass = pymysql.cursors.DictCursor)
    #conn.autocommit(True)
except Exception as e:
    print('[warning] DB connection failed', e)
    sys.exit()

def getLatestBlockNumFromDB():
    global conn
    sql = '''
    Select block_num from blocks
    Order by block_num desc limit 1;
    '''
    try:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            result = cursor.fetchone()
            if result:
                return int(result['block_num']) + 1
            else:
                return 1
        conn.commit()
    except Exception as  e:
        print('[warning]get latest block num error', e)
        return 1

def run():
    while True:
        latest_block_num = getLatestBlockNumFromDB()
        print(latest_block_num)
        time.sleep(3)

if __name__ == '__main__':
    with suppress(KeyboardInterrupt):
        run()
```

**问题** ：每次获取最新的区块号，总是一样的，就像被 `cache` 了一样。手动 `commit` 没有效果。

**临时解决方案** ：把 `autocommit` 打开即可。

参考：[https://github.com/PyMySQL/PyMySQL/issues/76](https://github.com/PyMySQL/PyMySQL/issues/76)

等以后有机会再解决吧。。。