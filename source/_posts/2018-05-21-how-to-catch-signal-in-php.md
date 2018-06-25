---
author: ety001
layout: post
title: '在PHP中捕获系统信号'
tags:
- 教程
---
为了让 [LightDB](https://github.com/ety001/steem-lightdb) 在退出的时候更加安全，因此考虑加入信号处理。目前 [LightDB](https://github.com/ety001/steem-lightdb) 在主循环中，先获取区块数据，再遍历区块数据进行加工，最后入库，这几个步骤中，最不希望发生的事情就是，在加工数据最后入库的时候，程序被中断。

因此加入信号处理，对人为执行 ctrl + c 的时候，把程序中断放到获取数据阶段或者入库结束之后。

以下是示例代码

```
<?php
//使用ticks需要PHP 4.3.0以上版本
// declare(ticks = 1);

class a {
    public function __construct() {
        pcntl_signal(SIGTERM, array($this, 'handle'));
        pcntl_signal(SIGINT, array($this, 'handle'));
    }

    public function handle($signo) {
        var_dump($signo);
        exit();
    }

    public function start() {
        while (1) {
            echo time()."\n";
            sleep(1);
            echo "11111111\n";
            pcntl_signal_dispatch();
            echo "22222222\n";
        }
    }

}

$b = new a();
$b->start();
```

PHP处理信号的方法是，把程序收到的信号入队列，然后再从队列里取信号处理。这样在使用 `pcntl_signal` 方法的时候，需要加上 `declare(ticks = 1);` 或者 `pcntl_signal_dispatch();`，二者添加一个即可。`declare(ticks = 1);` 的作用是，让 `PHP` 每执行一行代码就去触发下从队列取信号的操作。`pcntl_signal_dispatch();` 的作用则是，主动去处理队列里的信号。如果这两句不添加一个，那么最终的执行效果是，你触发了信号，但是程序只是对信号进行入队列的操作，没有程序来执行队列中的信号。

另外一个需要注意的就是，`pcntl_signal` 的第二个参数的使用。网上多是面向过程的使用方法，直接写要绑定的回调函数的名字即可，PHP文档中也只是有面向过程的使用方法。经过搜索，才找到绑定对象中的函数的方法，就是上面示例代码的方法。

Over!