---
author: ety001
layout: post
title: 对于btsbots修复进程的阶段性总结
tags:
- 经验
---

25天前填完 [LightDB](https://steemit.com/utopian-io/@ety001/lightdb-v0-0-2-has-been-released) 的坑以后，就开始研究 **alt** 留下的那个 **btsbots** 的 [代码](https://github.com/pch957/btsbots-demo-2016) 了。之前也有[团队在修复这套代码](https://steemit.com/notbtsbots/@aperson/introducing-not-btsbots) ，但是考虑到这么重要的一个设施，还是把核心技术握在自己手里比较好，要不然哪天那个团队歇菜了，又要凉。

代码断断续续的看了将近一个月了，总的感受就是崩溃。

从我开始参加工作开始，接的活都是半路加入救火的，没有人指导，只有代码，基本上是靠分析输出数据和看代码来逆向梳理需求的。但是这次修复 **btsbots** 的难度加大了，因为不会 *C++*，只能对着各种输出数据去逆向推理 **btsbots** 的代码到底想要做什么，为什么这么做。所以等这个 **btsbots** 修好，还是要找时间去学 **C++** 了。

目前并没有什么实质的代码修改，还停留在分析代码的阶段，该文就是基于目前我对于 **btsbots** 的理解进行的总结。

最简单的做市需要的数据无非就是当前账户内各种币剩多少，交易对是否满足下单要求，是否有订单需要取消。**btsbots** 的思路其实很简单，就是基于 **1.11.x** 这个 **operation history object** 来把链上的所有操作 **replay** 一遍，然后得到所有用户的 **balance** 和所有的交易对深度数据。

**btsbots** 项目使用 **python** 来完成从链上取数据并 **replay** 的操作，然后存入 **MongoDB**，最后基于 **Meteor** 开发了应用界面来读取 **MongoDB** 中的数据并展示，用户可以设置自己的做市逻辑并在浏览器本地完成下单和取消订单的签名操作。

思路很明确，但是比较让人恶心的就是数据和需求的分析了。

目前几乎所有的时间都在分析 **scripts** 目录下的 **python** 代码的逻辑，因为这一块之前在试跑的时候，数据一直有问题。

**scripts** 目录下主要就是 **correct-balance.py** , **monitor.py**, **statistics.py** 这三个文件。

这三个文件中，**monitor.py** 和 **statistics.py** 这两个的目的我是最明确的了，**correct-balance.py** 的目的一直很糊涂。

之前忘记在哪里看到的部署文档说，第一次运行 **btsbots** 的时候，要先运行  **correct-balance.py** 进行 **balance** 和 **order** 的初始化。然而看 **correct-balance.py** 的代码中，只是去获取 **1.8.x** 这一种类型的订单的数据和 **2.5.x** 的 **balance** 数据。在代码的头部，你需要指定 **x** 的上限，如下图

![](https://steemeditor.com/storage/images/Nch5576DeiraOIHgnlm6TV0jZylxGfTFM7CYNGsv.png)

然后循环获取从 **1.8.0** 到 **1.8.x** 获取订单数据并插入数据库，从 **2.5.0** 到 **2.5.x** 获取 **balance** 数据并插入数据库。完成这两步以后，会再遍历一遍已经插入数据库的订单数据，然后去更新数据库里已经存下来的 **balance**，如图：

![](https://steemeditor.com/storage/images/oOX8LmuGG982GhBZg9tcBkixpcJQPyEVztDOl3Gf.png)

![](https://steemeditor.com/storage/images/tsQErm0jNo9E8696zGG1lh0KuMywInXe9oeEEiAr.png)

![](https://steemeditor.com/storage/images/yO62x3OpZuFbLEl5V03q0VNfHvzIwNyPn5HXKgol.png)

![](https://steemeditor.com/storage/images/IhKwYQ8xhNHLoAOLMQGfF9oIdqsxIK14qoiAxNAV.png)

这里我就有疑问了!!!

首先是为什么第一次获取数据只获取 **1.8.x** 这一种类型的订单，而在下面的 **add_b_from_o** 函数中却有 **1.4.x** 和 **1.7.x** 的处理逻辑？

其次就是获取到的 **2.5.x** 是最新的 **balance** 数据，而拿着订单中的 **amount** 在最新 **balance** 上加减是不是错误的？我通过自己手动从 **API** 获取到的 **2.5.x** 的数据来看，拿到的这些 **balance** 数据都是刨除掉未成交订单额度后的，而在 **btsbots** 中却又在 **2.5.x** 的数据的基础上去刨除订单额度貌似是不对的，但是现在我又不敢确定，因为我不确定 **1.4.x**, **1.7.x**, **1.8.x**这些数据是代表的是未成交的订单，还是所有的订单。

最后就是感觉这里处理 **balance** 的方法跟 **monitor.py** 的处理方法是冲突的，这里先按下不表。我们先去看 **monitor.py** 的代码。

在 **monitor.py** 中，思路很简单，就是获取 **1.11.x**，然后根据各种不同的 **operation type** 来分别处理数据，最后把数据更新进数据库。这个脚本里的疑问也是有不少。

首先是怎么触发的问题，先看下图的代码，

![](https://steemeditor.com/storage/images/acKGEdCdTl7bePOxqz3z2hkG5XrWJf6AvsoQ2vEL.png)

其中 63 行是我补上的代码。与第 63 行类似的代码其实在这个类初始化的时候已经执行过了，这个在[这里](https://github.com/pch957/python-bts/blob/master/bts/ws/base_protocol.py#L87)可以看到。在 **python-bts** 库里，默认是把 **clear_filter** 置为 **false** 了，这意味着只有你发送了 **get_object** 的指令，服务端才会推送你刚才获取的那个 **object** 的变动。

在没有我补上的 63 行的代码之前，执行 **monitor.py** 其实是没有任何数据进数据库的，因为所有的插入数据库的操作都在 **onOperation** 里面，而 **onOperation** 的触发是在用户订阅的 **1.11.x** 的 **object** 有变动的时候才会触发，而程序代码从开始运行，就没有 **get_object** 的操作，所以服务端并不知道你想要获取哪个 **object** 的变动信息。加上 63 行后，把 **clear_filter** 置为 **true**，那么服务端就会推送所有的 **object** 的变动信息了。

其次就是语言方面的问题了，如下图

![](https://steemeditor.com/storage/images/Cgrg1g3FiSB4jsBuKHx5xHO5X22YXWcgjfOwMeQq.png)

由于我写 **python** 的时间不久，这里并不明白加锁的意义。如果加锁是为了保证共享资源的修改顺序的话，为啥还要用协程来异步？这里我还需要再多看看这方面的文章去了解下协程中的锁的目的。

然后这里第 41 行的代码在执行的时候也有问题。在这个类的父类中，看到作者最早是把 **op_id_begin** 置为 **1.11.0** 的，在从数据库中取不到数据的时候（也就是说第一次运行的时候），但是现在注释掉了，改为了置为 **None**，这就导致这里的代码如果按照作者原先的逻辑，就是从当前程序执行的时刻起，开始数据的同步。这也是之前那个团队修复的 **btsbots** 为何不支持老账户的原因。这里我改回到 **1.11.0** 后，运行程序跑了一天多后，发现有报错，大致意思就是插入的数据的索引有重复导致插入失败。这个问题现在还没有去深究原因。

最后为解决的难点就是这个 **monitor.py** 对 **operation** 的处理了。先看下面两个截图感受下

![](https://steemeditor.com/storage/images/wTy4zQxaCv5efixHejOjxU8jtJ71Nbi9u2WKCXGI.png)

![](https://steemeditor.com/storage/images/CBQGHbM8uTVwJiqCmuf45N07MXwOIIoaaduZ6lUx.png)

第一个截图中，是初始化了所有类型的 **op**，从 **btsbots** 的代码里看，截止到这份代码的最后修改时间，一共有 44 个类型，这里比较蛋疼的就是之后的 **bitshares-core** 中是否有再新增类型吗？由于我看不懂 **C++**，所以这里就会不确定。这 44 个类型里，有些没有手续费的类型，就去掉了没有处理，因为这个对于 **balance** 不产生影响，剩下的类型由 16 个 **handler** 处理，这里就有疑问了。大致扫过这些 **handler**，里面也有对数据库中的 **balance** 的操作，那么这里通过 **1.11.x** 对 **balance** 进行的操作与 **correct-balance.py** 文件中，通过 **1.8.x** 对 **balance** 的操作会不会有冲突？这个问题现在我一直在里面绕着出不来。现在的打算是，最好能确认 **correct-balance.py** 的意义，然后把这个文件中的逻辑整合进 **monitor.py** 中。

目前还没有深入看 **statistics.py** 这个文件，这个文件的主要作用就是通过 **1.2.9952** 发布的喂价来更新数据库里的交易对的交易价格，另外就是统计一下交易数据。

纵观这三个文件，还有个疑问就是三个文件都在获取 **global properties**，且都更新数据库，那么这里面到底会不会有问题有冲突，这个还没有细看。

以上就是现有的收获了。接下来有两个方向，一个是继续看所有的 **handler**，把具体的处理逻辑都看完，然后再修复，另一个方向就是跳过细看 **handler**，直接去看看那个索引冲突的问题，强行把程序跑起来看看。

最后再附上一份我搜集的 **object id**：

| ID     | Object Type                        |
| ------ | ---------------------------------- |
| 1.1.x  | base object                        |
| 1.2.x  | account object                     |
| 1.3.x  | asset object                       |
| 1.4.x  | force settlement object            |
| 1.5.x  | committee member object            |
| 1.6.x  | witness object                     |
| 1.7.x  | limit order object                 |
| 1.8.x  | call order object                  |
| 1.9.x  | custom object                      |
| 1.10.x | proposal object                    |
| 1.11.x | operation history object           |
| 1.12.x | withdraw permission object         |
| 1.13.x | vesting balance object             |
| 1.14.x | worker object                      |
| 1.15.x | balance object                     |
| 2.0.x  | global_property_object             |
| 2.1.x  | dynamic_global_property_object     |
| 2.3.x  | asset_dynamic_data                 |
| 2.4.x  | asset_bitasset_data                |
| 2.5.x  | account_balance_object             |
| 2.6.x  | account_statistics_object          |
| 2.7.x  | transaction_object                 |
| 2.8.x  | block_summary_object               |
| 2.9.x  | account_transaction_history_object |
| 2.10.x | blinded_balance_object             |
| 2.11.x | chain_property_object              |
| 2.12.x | witness_schedule_object            |
| 2.13.x | budget_record_object               |
| 2.14.x | special_authority_object           |
