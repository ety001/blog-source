---
author: ety001
layout: post
title: '如何搭建Steem见证人节点'
tags:
- 教程
---

最近运行了一个见证人节点，并且发布了 [见证人公告](https://steemit.com/witness-category/@ety001/to-be-a-witness-i-need-your-vote)，欢迎各位给我投上一票，投票链接：<https://v2.steemconnect.com/sign/account-witness-vote?witness=ety001&approve=1>


为了成为 [见证人](https://steemit.com/cn/@oflyhigh/6dbdqm)，我搜索了很多的资料，中文资料目前应该是没有，基本上都是英文的，并且每一篇都只是介绍了某一点，尤其是如何把自己的账号升级为见证人，这方面的资料几乎就没有。这里我将介绍下如何快速搭建成为见证人。（为了重现这个过程，我拿我的另外一个账号 `liuye` 来重新走一遍流程）


**注意1：教程将以Ubuntu16.04作为操作环境，如果你用其他的Linux系统，需要自己解决各种依赖等问题。**

**注意2：目前网上建议最小内存 32GB，最小硬盘 100GB（当前时间：2018.01.30）为了写这个教程，现买了几个小时的 VPS 用来测试。小内存似乎也可以跑，文末总结有彩蛋。**
![](https://steemitimages.com/DQmT1CM9yF1i7fvi3RbrmT7aBFu8fKGGTPg3hwreNBrfKPx/image.png)

### 把账号升级为见证人

目前最便利的方法就是使用 [Conductor](https://github.com/Netherdrake/conductor) 了。建议把 `Conductor` 安装在本地，毕竟这一步需要导入你的账号信息，如果在服务器操作，可能安全度不高。另外，确保你的本地安装了 `Python3`。


1.安装必要的依赖

```
sudo apt install libffi-dev libssl-dev python3 python3-dev python3-pip
```


2.安装 `steem-python`

```
pip3 install -U git+git://github.com/Netherdrake/steem-python
```


3.安装 `conductor`

```
pip3 install -U git+https://github.com/Netherdrake/conductor
```


4.使用 `steem-python` 创建本地钱包，并导入你的账号

```
$ steempy addkey
```

弹出下面的提示

```
Private Key (wif) [Enter to quit]:
```

在这里输入你账号的活跃权限的私钥，在你的 `steemit` 的网站钱包页面的权限中可以找到。
输入完，回车，会提示下面的信息

```
Please provide a password for the new wallet
```

这里输入一个你自己的密码，用于加密你本地的钱包，假如这里我们设置的是 `123456`。
当再次弹出 `Private Key (wif) [Enter to quit]:` 时表明添加成功，直接回车退出。


5.初始化见证人

```
conductor init
```

回车后会依次让你输入下面的内容

```
What is your witness account name?: liuye
Witness liuye does not exist. Would you like to create it? [y/N]: y
What should be your witness URL? [https://steemdb.com/witnesses]: https://steemit.com/@liuye
How much do you want the account creation fee to be (STEEM)? [0.500 STEEM]: 0.200 STEEM
What should be the maximum block size? [65536]: 
What should be the SBD interest rate? [0]: 
BIP38 Wallet Password: 
Witness liuye created!
```

其中 `account creation fee`，`maximum block size`，`SBD interest rate`这几个参数我也不清楚具体干什么的，
我是按照多数见证人的设置来配置的，其中注意 `account creation fee` 的格式。另外那个 `BIP38 Wallet Password` 就是上一步里设置的钱包密码，即那个 `123456`。


6.生成打包区块所要用的公私钥对

```
conductor keygen
```

这一步生成的公钥将用来激活你的见证人，生成的私钥将配置在服务器节点的 `config.ini` 文件中。
比如这里我生成的是

```
+-----------------------------------------------------+-------------------------------------------------------+
| Private (install on your witness node)              | Public (publish with 'conductor enable' command)      |
+-----------------------------------------------------+-------------------------------------------------------+
| 5JEREu41d6zdBsFHjKx3PumyHMhydUH5DCPFejRiBTyQLg3rGgt | STM6fhWKaF4okgbjeAZrQg7mc7fNUKT7BtyevHAF9Qtfe666RDaEp |
+-----------------------------------------------------+-------------------------------------------------------+
```


7.激活见证人

```
conductor enable STM6fhWKaF4okgbjeAZrQg7mc7fNUKT7BtyevHAF9Qtfe666RDaEp
```

回车后会要求输入钱包密码，等看到一堆信息后，如果 `block_signing_key` 里是你设置的公钥，
那么就激活成功了。

8.临时关闭见证人

```
conductor disable
```

按照提示输入完信息后，当看到一堆信息后，其中的 `block_signing_key` 变为 `STM1111111111111111111111111111111114T1Anm` 则表明见证人临时关闭成功。

如果目前你的节点不在运行，则需要临时关闭见证人，否则如果轮到你出块了，而你不在线，则将记录一次你丢块。（PS: 通过我这一周的观察，目前我的这些票数，完全轮不到我出块，所以关不关掉都是一个样。。。😂）

### 部署见证人节点

我自己搭建见证人节点的时候，是使用的官方的 `Docker` 镜像。
本教程则使用更傻瓜化的一个 `Docker` [镜像](https://github.com/Someguy123/steem-docker) 来完成。

**再次注意：服务器环境是ubuntu16.04**

1.更新系统，安装依赖，获取 [steem-docker](https://github.com/Someguy123/steem-docker) 的安装脚本。

```
sudo apt update
sudo apt install git curl wget
git clone https://github.com/Someguy123/steem-docker.git
cd steem-docker
```

2.安装 `Docker`，如果你的系统目前已经安装，则跳过该步

```
./run.sh install_docker
```

3.拉取 `steem-docker` 镜像

```
./run.sh install
```

4.同步区块数据，目前区块数据大约23GB，该步是从大佬@gtg 维护的节点下载已经打包好的区块数据（同步和解压都需要很久，尤其是解压）。

```
./run.sh dlblocks
```

> 如果你想跳过下载这一步，而是想直接通过 `P2P` 网络来同步区块数据，那么在执行第7步之前，可以修改一下 `run.sh` 的 170 行，
> ![](https://steemitimages.com/DQmYDAniAE6xLunbYjNsetgMY8JCx3C5okTFu5mLo3U1i7B/image.png)
> 我们删除掉，最后的那个 `--replay` 参数，然后执行 `./run.sh replay`。
> 通过读取日志，看到有区块数据同步后，再次修改 `run.sh` 的 170 行，把刚才去掉的参数再加回来，加回参数后，再执行 `./run.sh replay` 即可。
> 如果提示类似下面的错误
> ```
> Error response from daemon: You cannot remove a running container c083355ec3960722bee080cff5c1bb13c225f5b9a3e0ae8ea63b4f73ce531992. Stop the container before attempting removal or force remove
> ```
> 执行下面的命令后再执行 `./run.sh deplay`，其中 `c08` 是报错中提到的那个 `container id` 的头几位
> ```
> docker stop c08
> ```

5.调整内存。由于要使用 `/dev/shm` 来作为 `shared-file-dir`，而默认 `/dev/shm` 是机器内存的一半，为了更好的利用内存，我们需要把这个内存调大，我的服务器是32GB的，因此我调到30GB，留下2GB给系统自己。([啥是 shm](http://www.361way.com/dev-shm/4029.html)。)

```
sudo ./run.sh shm_size 30G
```

6.修改 `config.ini` 配置文件

```
vim data/witness_node_data_dir/config.ini
```

只需要参照下面的内容修改几项即可，

```
p2p-endpoint = 0.0.0.0:2001 # 做种子
shared-file-size = 30G
shared-file-dir = /shm # 如果注释掉这行，在小内存机器上也可以跑
witness = "liuye"  # 这里填写你的 steem 账号，注意要加双引号！！
private-key = 5JEREu41d6zdBsFHjKx3PumyHMhydUH5DCPFejRiBTyQLg3rGgt # 这里填写 conductor 生成的私钥，不需要引号
```

7.启动见证人节点

```
./run.sh replay
```

运行成功后，可以通过 `./run.sh logs` 命令，查看 `Docker容器` 的运行情况，如图

![](https://steemitimages.com/DQmUUfm46LPZackRezNLkHEzGkTEo6Z3qsmj72cbCrWVCek/image.png)

`Log` 信息中出现见证人信息了，就代表配置成功了。等待区块链同步到最新后，显示类似下面的内容时，就一切正常了，这时别忘了用 `conductor` 激活见证人。

![](https://steemitimages.com/DQmbjAJzkUDvwBtMQapfs1aWfYdQNvngt7VzvJoFyTMcC2N/image.png)

8.发布见证人公告到 `witness-category` 下面，以表示你开始了见证人之旅。写一写你能为社区做啥，为啥大家要给你投票之类的。

### 关于喂价

见证人除了打包这个工作外，还有一个重要的工作就是给系统提供喂价。
目前有好几个版本的喂价脚本， 这里我们使用 `conductor` 提供的喂价功能即可。

```
conductor feed
```

第一次运行会出现类似的错误提示

```
BIP38 Wallet Password: 
Tue Jan 30 21:18:48 2018
Old Price: 0.000
New Price: 5.165

Current STEEM price: 5.165 USD
Current SBD price: 5.767 USD
Quote: 1.000 STEEM

Spread between prices: 100.000%
Possibly invalid spread (100.00%), ignoring...
```

查看源代码发现，之所以 `ignoring` 是因为我们目前在区块上存储的喂价是0，也就是我们还没有提供过喂价，这就导致新旧价格差价过大，即 `Spread between prices` 过大，超过了代码中设置的 `20%`，因此被忽略了。这应该是这个喂价程序的一个缺陷，没有考虑第一次喂价更新。

所以我们需要手动使用 `Python` 完成第一次喂价更新。在终端中打开 `Python3`，然后按照下面的命令进行输入：

```
Python 3.6.3 (default, Oct 24 2017, 14:48:20) 
[GCC 7.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from steem import Steem
>>> steem = Steem()
>>> steem.commit.witness_feed_publish(5.165, quote=1.000, account="liuye")
Passphrase: 
{'ref_block_num': 33686, 'ref_block_prefix': 2156333139, 'expiration': '2018-01-30T13:37:05', 'operations': [['feed_publish', {'publisher': 'liuye', 'exchange_rate': {'base': '5.165 SBD', 'quote': '1.000 STEEM'}}]], 'extensions': [], 'signatures': ['202c413bf800c51e583a30687954fa5e77b052bd90e3e4834d5fa82a817121ebb40677fbf1351abcd70e656eb7fc97e16e236aa5092960ec87e6f0a0531ba982b6']}
```

其中 `witness_feed_publish` 的参数中，`5.165` 是 `Current STEEM price: 5.165 USD`，`quote` 是 `Quote: 1.000 STEEM`。

完成手动更新后，再次使用 `conductor feed` 执行就成功了。

如果想要使用 `Docker` 化的 `conductor`，可以参考 [这里](https://github.com/ety001/docker-steem-conductor)，我自己封装了一个。

### 总结

前前后后连写加调试，完成这篇教程花了有那么几个小时，这应该是目前中文版教程里最全的了，没有之一。

**这里有个小技巧**，如果你内存不够，在配置文件中不要用 `/dev/shm` 作为 `shared-file-dir`，节点依然可以运行，也就是说可以注释掉 `shared-file-dir = /shm`。之所以把这个放在最后说，是因为我并没有完全测试这种情况。其他人貌似都是用 `/dev/shm` 来作为 `shared-file-dir` 的。

总的来说，搭建见证人节点就是会者不难，难者不会。虽然见证人节点的资源消耗不及全节点，但是也是够费资源的。我目前并不理解，为何见证人节点需要同步全量数据，难道只获取目前区块链全部数据的最近25%的数据，不能完成打包工作吗？看来这个还有待等到进一步去看源代码的时候思考。
