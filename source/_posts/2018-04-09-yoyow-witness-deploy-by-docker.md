---
author: ety001
layout: post
title: 'YOYOW 见证人教程(docker版)'
tags:
- 区块链
- 教程
---

# 前言

`YOYOW` 是一个基于区块链的内容激励网络，`YOYOW` 虽然给人第一印象是模仿 `Steem`，其实不然。`YOYOW` 在做的事情应该是一个区块链版的 `UCenter`。其他的事情也不多说了，不是教程范畴的，请自行去 [官网](https://yoyow.org) 阅读 [白皮书](https://yoyow.org/files/white-paper3.pdf)。

# 前置技能 和 准备工作

* 基础的 `Linux` 知识
* 基础的 `Docker` 知识
* 有一台运行有 `Docker` 的服务器（目前 2G 内存，50G 硬盘就足够足够了）
* 有 `YOYOW` 账号，且至少账号内有 **11000** 个币（抵押需要1w，手续费需要1k）

# 开始我们的表演

1.创建以下目录

```
# mkdir -p /yoyow/data
# mkdir -p /yoyow/yoyow_node_data_dir
```

2.下载 `YOYOW` 的最新版程序，[https://github.com/yoyow-org/yoyow-core/releases](https://github.com/yoyow-org/yoyow-core/releases) 。
请分别下载 `yoyow-client-v0.2.1-ubuntu-20180313.tgz` 和 `yoyow-node-v0.2.1-ubuntu-20180313.tgz`，并解压 `yoyow-client` 和 `yoyow-node` 到 `/yoyow/data` 目录。（可能你看到此文的时候，版本号已经变了，但是下载 `Ubuntu` 环境下的 `yoyow-client` 和 `yoyow-node` 肯定是没错的）
**请直接 watch 这个项目，以免错过版本更新造成丢块。**

3.下载 `Dockerfile` 文件到任意目录

```
# curl https://gist.githubusercontent.com/ety001/640f944f7299cae4af4e3ef092a5f4a8/raw/192d36950d580996c176e23f5d5c4ae6da26110e/yoyow_Dockerfile -o Dockerfile
```

4.打开 `Dockerfile` 文件，注释掉最后一行，如下

```bash
FROM ubuntu:16.04
Volume /data
Volume /yoyow_node_data_dir
# CMD /data/yoyow_node --rpc-endpoint -w 485699321 --private-key '["YYW7TSRLZ9EXZpxxxx","5JbDUxxxxxxxxxx"]'
```

保存退出。

5.生成一个镜像

```bash
# docker build -t yoyow .
```

6.启动一个容器来运行 `yoyow-node`

```bash
# docker run --name yoyow -d -v /yoyow/data:/data -v /yoyow/yoyow_node_data_dir:/yoyow_node_data_dir yoyow /data/yoyow_node --rpc-endpoint
```

7.等待数据同步到最新，可以通过下面的命令来查看容器的运行情况

```bash
# docker logs --tail 10 yoyow
```

上面的命令是显示最后10行的，如果想显示更多行，请自行修改，去掉 `--tail` 参数可以显示全部输出信息。

8.同步完数据后，执行下面的命令可以打开本地钱包

```bash
# docker exec -it yoyow /data/yoyow_client -w /data/wallet.json -s ws://localhost:8090
```

第一次打开本地钱包，会要求你设置一个本地钱包的密码，如下图（请设置后牢记）

![](https://steemitimages.com/DQmR5L8h3kdTsYP98RGf95wEPvf7UPhuzNPMyQPK5vDUZgg/image.png)

输入 `set_password` 命令完成密码设置，本教程内设置的密码是 `123456` 如下

```bash
Please use the set_password method to initialize a new wallet before continuing
new >>> set_password 123456
set_password 123456
null
locked >>> 
```

9.解锁钱包

```bash
locked >>>  unlock 123456
unlock 123456
null
unlocked >>> 
```

10.导入资金密钥 **Active key**（**Active key** 去这里可以找到 [https://wallet.yoyow.org/#/settings/viewpurview](https://wallet.yoyow.org/#/settings/viewpurview) ），导入命令如下

```bash
unlocked >>>  import_key   你的数字账号   你的ActiveKey
```

11.生成一对新的公私钥对，用于签名打包的块。**请备份好，如果丢失，需要重新生成新的公私钥对，并重新配置 `yoyow_node`**。

```bash
unlocked >>>  suggest_brain_key
suggest_brain_key
{
  "brain_priv_key": "JIGGETY DEATHLY MUSTEE WINDORE CHAGUL WACE TUQUE BEMOON FLAVIC PITCHY SEVENER FELINE VIDETTE RUMNEY OVUM XENYL",
  "wif_priv_key": "5KMJDKiUcWr9J2pPu9YdAQnbAiMKKxx2DA4W5ALfvgkUsWyXNWX",
  "pub_key": "YYW87JoiJguwTWgSXZBHHaA78xiaNaEh5Lup1rNJGEg37Z4huNGyS"
}
```

12.创建见证人

```bash
unlocked >>>  create_witness   你的数字账号名    见证人签名公钥    押金金额(10000+)    YOYO   你的宣传链接   true
```

如果创建成功，在 [https://yoyow.bts.ai/witness?locale=zh-CN](https://yoyow.bts.ai/witness?locale=zh-CN) 就可以查到了。

> 退出本地钱包的方法：ctrl + d

13.停止刚才创建的容器并删除容器和镜像

```bash
# docker stop yoyow
# docker rm yoyow
# docker rmi yoyow
```

14.打开刚才的 `Dockerfile`，把刚才注释掉的最后一行取消注释，并且 `485699321` 修改为你的数字账号，`YYW7TSRLZ9EXZpxxxx` 和 `5JbDUxxxxxxxxxx ` 分别修改为刚才生成的公私钥，即 `YYW87JoiJguwTWgSXZBHHaA78xiaNaEh5Lup1rNJGEg37Z4huNGyS` 和 `5KMJDKiUcWr9J2pPu9YdAQnbAiMKKxx2DA4W5ALfvgkUsWyXNWX`，修改完后，保存退出。

15.重新生成镜像

```bash
# docker build -t yoyow .
```

16.重新启动容器

```bash
docker run --name yoyow -d --restart always -v /yoyow/data:/data -v /yoyow/yoyow_node_data_dir:/yoyow_node_data_dir yoyow
```

到这里，就完成了见证人服务器的搭建工作。

# 一些常用的命令

1.打开本地钱包（其中 `wallet.json` 即为你本地钱包文件，在母机的 `/yoyow/data` 目录下，注意保护）

```bash
# docker exec -it yoyow /data/yoyow_client -w /data/wallet.json -s ws://localhost:8090
```

2.如果你要维护节点，为了避免错过块，请先下线见证人，然后再进行维护。启停见证人使用 `update_witness` 命令，其格式如下：

```bash
unlocked >>>  update_witness    您的数字账号名     签名用的公钥    押金金额(10000)   YOYO    链接     true
# 不需要修改的内容填null，不能填写和修改前一样的参数，否则会报错）

# 下线见证人
unlocked >>>  update_witness  485699321  YYW1111111111111111111111111111111114T1Anm  null  YOYO  null  true

# 上线见证人
unlocked >>> update_witness  485699321  YYW87JoiJguwTWgSXZBHHaA78xiaNaEh5Lup1rNJGEg37Z4huNGyS  null  YOYO  null  true
```

3.查看可以领取的见证人工资

```bash
unlocked >>>  get_full_account 485699321
```

其中 `uncollected_witness_pay` 的数值除以10万就是你未领取的见证人工资。

4.领取见证人工资

```bash
unlocked >>>  collect_witness_pay 485699321 money YOYO true
```

把 `485699321` 换成你的账号，`money` 换成你要申领的工资数。

# 节点升级工作

如果遇到程序升级，那么需要首先下载最新版的 `yoyow_node` 和 `yoyow_client`，下线见证人后停止容器

```bash
# docker stop yoyow
```

用新版的程序覆盖之前的程序后，再启动容器，

```bash
# docker start yoyow
```

容器启动数据同步完后，再上线见证人。

# 完结

以上即为 `Docker` 版的部署教程，如有遗漏请留言，欢迎给我投上一票，我的账号是：**485699321** 。