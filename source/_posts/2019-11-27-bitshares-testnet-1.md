---
author: ety001
layout: post
title: 快速搭建私有单节点 Bitshares Testnet（一）
tags:
- Bitshares
---
# 前因

有时候想搞点事情的时候，最终都是由于 BTS 目前的公共测试网络里你要用代币只能找别人要。
我是很不喜欢麻烦别人的，所以就放弃想搞点东西的想法了。

很好奇，BTS 作为一个好几年的老项目了，居然没有一个类似 ETH 那样的可以自行申请代币的测试网络，
真是神奇！

所以我打算自己部署一整套类似 ETH 那边 kovan 一样的测试网络。
测试网络每个季度重置数据，Dapp 开发人员可以通过机器人申请代币。

同时，部署方案我也会公开出来，如果你不想用我搭建的服务，也可以自建。

这第一篇是讲节点部署的，在我完成发币机器人和水龙头后，会再发布第二篇，介绍机器人和水龙头部署方法。

# 准备工作

由于考虑到部署尽量傻瓜化，所以我选择用 `Docker` 来作为部署底层支持。

这样，我们能够屏蔽掉很多环节，只需要很少量的工作，就可以完成目标。

# 开始部署

### 1.拉取测试网镜像

目前我已经把测试网的程序封装好了，如果你希望自己封装，可以参考的 `Dockerfile` 文件，
文件地址是：[https://github.com/ety001/dockerfile/blob/master/bitshares-core-builder/Dockerfile.test](https://github.com/ety001/dockerfile/blob/master/bitshares-core-builder/Dockerfile.test) 。

如果你想直接用现成的，那么直接执行下面的命令拉取我的镜像即可

```
docker pull ety001/bts-core-testnet:latest
```

> latest 版本指向最新的测试网程序，如果你想用其他的版本，可以去这里看下我之前编译的版本 [https://hub.docker.com/r/ety001/bts-core-testnet/tags](https://hub.docker.com/r/ety001/bts-core-testnet/tags)

### 2.下载 docker-compose.yml 文件

```
wget https://raw.githubusercontent.com/ety001/dockerfile/master/btfdd/docker-compose.yml
```

### 3.创建数据目录

在 `docker-compose.yml` 文件的同目录下，创建数据目录，用于存放区块数据。

```
mkdir bts_data
```

### 4.创建 my-genesis.json 文件

在 `bts_data` 目录下，创建 `genesis` 目录，
并创建 `my-genesis.json` 文件用于配置创世块。

```
mkdir bts_data/genesis
touch bts_data/genesis/my-genesis.json
```

> `my-genesis.json` 文件可以参考模板配置文件 `genesis-dev.json`，地址在这里：[https://raw.githubusercontent.com/bitshares/bitshares-core/master/libraries/egenesis/genesis-dev.json](https://raw.githubusercontent.com/bitshares/bitshares-core/master/libraries/egenesis/genesis-dev.json)

接下来我们需要修改 `my-genesis.json` 文件，以上面提到的 `genesis-dev.json` 模板为例。

我们需要修改默认11个见证人的 `owner_key`、`active_key` 和 `block_signing_key` 这三种值。

另外里面还有个 `nathan` 的用户，我们一并修改这个用户的 `owner_key` 和 `active_key`。

> 当然你也可以把 `nathan` 这个名字换成自己的，比如 `ety001`。这个账号，我们之后会拿来给机器人用。

这样这里就需要很多组公私钥对，我们可以使用下面的命令即可快速生成

```
docker run \
    -it \
    --rm \
    ety001/bts-core-testnet \
    /app/get_dev_key TEST seed1 seed2 seed3 seed4
```

`get_dev_key` 是 BTS 自带的生成公私钥对的小工具，使用语法是：
第一个参数是公钥的前置，之后的参数都是生成私钥时所需要的 `seed`。

上面的示例中，可以生成四组公私钥对，并且公钥是以 `TEST` 开头。

> 这里需要注意，测试网公钥必须要以 `TEST` 开头。

除了修改上面提到的 `owner_key`、`active_key` 和 `block_signing_key` 之外，
还需要修改 `initial_balances` 中的 `owner` 和 `asset_symbol`。

> * `owner` 使用的是 `address` 而不是 `public_key`。
> * `asset_symbol` 设置为 `TEST`。
> * `initial_balances` 申领需要在节点启动后，在 `cli` 里使用 `import_balance ety001 [5JLxxx] true` 命令获取，其中 `5JLxxx` 是 `ety001` 的 `owner` 权限的私钥。

### 5.创建 config.json 文件

接下需要启动一次容器，以创建 `config.json` 文件

```
docker-compose up
```

执行后，由于还没有配置见证人，所以会一直卡住。这个时候，我们 `ctrl + c` 结束，
在 `bts_data` 目录下就能看到 `config.json` 文件了。

### 6.配置见证人

我们需要把我们的11个见证人配置进 `config.json` 里。

我们把 `config.json` 里原有的 `private-key` 删掉，加入新的配置，示例如下：

```
witness-id = "1.6.1"
witness-id = "1.6.2"
witness-id = "1.6.3"
witness-id = "1.6.4"
witness-id = "1.6.5"
witness-id = "1.6.6"
witness-id = "1.6.7"
witness-id = "1.6.8"
witness-id = "1.6.9"
witness-id = "1.6.10"
witness-id = "1.6.11"

private-key = ["TEST7HSRc2ifS2Xzr98t1xQgdPWrM6zChe8gTAycKDYTCJvKJqVyJC", "5JQ7Uo6f8WmqnzoYcE5AkuSLFyUEQWP5uLNphykFnJCmpMXKa4D"]
private-key = ["TEST6hboHaJmrdSNdawxrjpHtM7dm5cbd16rBegrswer3yBfHth9Zo", "5JkW1yf6MwTGaP9CjimugZMRjgPuJMm1Pdmp785NndtXmWAfUe6"]
private-key = ["TEST8WbrXZn9v334bv5v4PKnDG36QZfkvt6qsK46knQQpxgA6RnHhV", "5KNBtnDp3yEu1RZchANYoZsTXCwQVvMQb42bbwjNtq3Woq7nRES"]
private-key = ["TEST8k9DRh9KrTjAYZFgFXwznAWkdD6Ke48URYWjgeit8jA5V1vnnU", "5JaFdWJvf9Vu1Bz98P1g4PjJGEUDquGzZ3vFtWXzuHZeLNiaTpF"]
private-key = ["TEST8CzmYt2sJVdRCpdx51N7YXjBFhyj17DS7oaiQ6MjLa8oHyFkUX", "5KgtUPZXF4AxQSqXVSqweRb8ixFfdev41c1jAszZ8PTSHowcXyc"]
private-key = ["TEST6PU8rAukkA8ynMqiBVxYDTsoYz8TFSZDZ68Hct9LVmhaYc6AbT", "5K9Fxnc9RvDS1CWUhrd89ap8zJ8hEggibYvahvAJKexSrTeZS46"]
private-key = ["TEST8FMi4q6A8hELQRJ5zrdwuW7tkjKABSP4DRuRVkVA3rp6s4HRZy", "5KKpUNdUMqEwT8hBhwc9p9x5JxeRxHgwAeTCPt3BjL1Yh7ASoU6"]
private-key = ["TEST8XEJor1k1f9jTd9GiS4VycmmaL6WTtj4NpKrz3BMPhW9w6pxw9", "5KKmySfMqXeeutsfYsbD8AonsxVm1cbC33nCZEvVbUsnc7KEshD"]
private-key = ["TEST7NLQf5P2csPdmfSbMftcBsfvKfY96RMHrpZtcrQHG454khzALY", "5Ji1FVJZDTnTFJ1dSGo7EGqroLCi9kuZMYqgvphYcSvKCWkEfZH"]
private-key = ["TEST6Gvr1QZdPQyFWnZrPsgUASTFUsfmZmrAWZKQjX1TL5yQs5GMro", "5KErQxNxaQJXHaeWGLonW23RSc6zqZuBUE9YCZASEyPG5nBjnkG"]
private-key = ["TEST6ujzsVvmKr1ASSDSukjC9EtobjMM1uVTWtYFPzJ5TvaZjCRGYz", "5JT6QzZnV14jCuyxqPk6BjPDFAvhYBfjfXkCgk5Mr5neA92voyA"]
```

> * 其中 `private-key` 要与 `my-genesis.json` 中的 `block_signing_key` 一致。
> * 注意 `checkpoint` 设置为 `[]`

### 7.启动

至此，所有的配置都已完成，执行下面的命令启动即可

```
docker-compose up -d
```

# 结语

部署的主要工作就是配置 `my-genesis.json` 和 `config.json`。

如果有疑问，请到这里提 issue: [https://github.com/ety001/bitshares-testnet-for-dapp-developers/issues](https://github.com/ety001/bitshares-testnet-for-dapp-developers/issues) 。

#### 参考文档
* [https://dev.bitshares.works/en/master/development/testnets/private_testnet-v2.html#creating-another-directory-for-the-bitshares-private-testnet-project](https://dev.bitshares.works/en/master/development/testnets/private_testnet-v2.html#creating-another-directory-for-the-bitshares-private-testnet-project)
* [https://dev.bitshares.works/en/master/bts_guide/tutorials/how_to_get_key_pairs.html#suggest-brain-key](https://dev.bitshares.works/en/master/bts_guide/tutorials/how_to_get_key_pairs.html#suggest-brain-key)

#### 感谢
@abit  @Necklace
