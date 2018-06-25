---
author: ety001
layout: post
title: 'YOYOW见证人监控程序部署教程（docker版）'
tags:
- 区块链
- 教程
---
部署YOYOW见证人有几个月了，发现貌似没有人关注丢块的问题，我也没有找到有相关的开源软件可以去完成丢块自动下线的功能。像 Steem 社区有太多的类似程序了，python 的、nodejs 的，多的数不胜数。只能说 YOYOW 还是很年轻。

作为一个 YOYOW 的见证人，有义务去开发一款这样开源版本的工具。经过一晚上的折腾，基本功能已经是完成了。代码库在 [这里](https://github.com/ety001/yoyow-witness-watcher)。这个工具是基于docker进行部署的，如果你看了上一篇我写的《YOYOW 见证人教程》 , 那么这个工具的部署应该会很轻松。因为我花了大量的时间在部署脚本上（大约6个小时），目的就是尽可能把部署过程傻瓜化。

# 准备

* 一台 Linux 服务器，装有 docker , wget
* 如果需要通知服务，请自行注册discord，并创建一个新的服务器、频道和频道的webhook（文章最后有个简易获取 Webhook 的教程）。

# 开始

### 1.首先下载代码

```
git clone https://github.com/ety001/yoyow-witness-watcher.git
cd yoyow-witness-watcher
```

### 2.部署 `yoyow_client`，并提供 `RPC` 服务。

```
./init.sh
```

首先提示你输入 `yoyow_client` 的下载地址：

```
*********************************************
Welcome to use YOYOW witness watcher.
This tool is made by ETY001. (https://github.com/ety001)
My YOYOW ID is 485699321. It's pleasure to get your votes!
*********************************************

Please input current yoyow_client download URL (https://github.com/yoyow-org/yoyow-core/releases/latest):
https://github.com/yoyow-org/yoyow-core/releases/download/v0.2.1-180313/yoyow-client-v0.2.1-ubuntu-20180313.tgz
```

下载地址可以在 [https://github.com/yoyow-org/yoyow-core/releases/latest](https://github.com/yoyow-org/yoyow-core/releases/latest) 找到，填写下载地址后，回车继续。

当看到出现 `Listening for incoming HTTP RPC requests on 0.0.0.0:9999` 以及 `new >>>` 的时候说明 `yoyow_client` 的 docker 镜像已经做好，现在开始创建钱包并导入你的账号

```
Create wallet
Logging RPC to file: logs/rpc/rpc.log
3505859ms th_a       main.cpp:120                  main                 ] key_to_wif( committee_private_key ): 5KCBDTcyDqzsqehcb52tW5nU6pXife6V2rX9Yf7c3saYSzbDZ5W 
3505862ms th_a       main.cpp:124                  main                 ] nathan_pub_key: YYW6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 
3505862ms th_a       main.cpp:125                  main                 ] key_to_wif( nathan_private_key ): 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 
Starting a new wallet with chain ID ae4f234c75199f67e526c9478cf499dd6e94c2b66830ee5c58d0868a3179baf6 (from egenesis)
3505863ms th_a       main.cpp:172                  main                 ] wdata.ws_server: wss://wallet.yoyow.org/ws 
3506840ms th_a       main.cpp:177                  main                 ] wdata.ws_user:  wdata.ws_password:  
Please use the set_password method to initialize a new wallet before continuing
3509652ms th_a       main.cpp:243                  main                 ] Listening for incoming HTTP RPC requests on 0.0.0.0:9999
new >>>
```

先设置本地钱包密码（比如 123456）

```
set_password 123456
```

解锁本地钱包

```
unlock 123456
```

导入你的 YOYOW 账号

```
import_key YOUR_YOYOW_ID  YOUR_YOYOW_ACTIVE_KEY
```

完成以上工作后，按 `ctrl + d` 退出钱包，docker 容器开始重启

直到看到 Finish 且已经在监听 9999 端口时，整个 `yoyow_client` 的部署完成。

```
Get Status
00200e8bde55        yoyow_client                     "/bin/sh -c '/data/y…"    10 seconds ago      Up 10 seconds                                                  yoyow_client

Logs
Logging RPC to file: logs/rpc/rpc.log
140909ms th_a       main.cpp:120                  main                 ] key_to_wif( committee_private_key ): 5K**********************5W 
140910ms th_a       main.cpp:124                  main                 ] nathan_pub_key: YY************************CV 
140910ms th_a       main.cpp:125                  main                 ] key_to_wif( nathan_private_key ): 5****************************3 
140912ms th_a       main.cpp:172                  main                 ] wdata.ws_server: wss://wallet.yoyow.org/ws 
141820ms th_a       main.cpp:177                  main                 ] wdata.ws_user:  wdata.ws_password:  
145239ms th_a       main.cpp:243                  main                 ] Listening for incoming HTTP RPC requests on 0.0.0.0:9999

************
Finish!
```

### 3.部署监控程序

直接运行下面的命令开始部署

```
./install_bot.sh
```

提示输入你的 YOYOW ID

```
# ./install_bot.sh 
Please input YOYOW ID:
485699321
```

提示输入你签名块用的公钥。

```
Please input Your Public Key:
If you have multiple public keys, separate them with commas
eg. YYW7TSRLZ9EXZps37Kt31qa7qi,YYW7TSRLZ9EXZpZqk25atoL2s37
YYW7TSRLZ9EXZpZqk25atoL2s37Kt31qa7qi78ZR368kCN969rFiT,YYW733FxEEaAFTHxdTJdowZyQzJ3JnPocsVmdq4aSsm1gSd1VkYDC
```

&gt; 如果你有多台备机，可以用逗号把多个公钥隔开填写，**请务必把当前正在运行的节点的公钥放在第一位**，程序会在检测到丢块后，自动依次往后切换，直到所有节点都不可用。因此，如果你有两个节点的话，当第一个节点挂掉，程序自动切换到第二个备份节点后，赶紧去修第一个节点，第一个节点重启可用后，**一定要重新部署下bot程序，并且填写公钥时，把目前的第二个节点的公钥放在前面**。

提示输入你的本地钱包密码

```
Please input wallet password:
123456
```

提示输入 discord 的 webhook 地址，如果你想获取通知的话，就配置这项，否则留空。最后会简单说下怎么获取 webhook 地址

```
Please input Discord webhook for notify (If you don't need it, leave empty.):
https://discordapp.com/api/webhooks/433204170/X2RWo7-qiFlnMtQeQkk_sSgb5Vn0rQVWZCF5f
```

当你看到类似以下信息的时候，就已经完成了所有部署工作。

```
Get status
string(20) "global value in init"
array(2) {
  [0]=>
  string(53) "YYW7TSRLZ9EXZpZqk25atoL2s37Kt31qa7qi78ZR368kCN969rFiT"
  [1]=>
  string(53) "YYW733FxEEaAFTHxdTJdowZyQzJ3JnPocsVmdq4aSsm1gSd1VkYDC"
}
string(9) "485699321"
string(27) "http://172.20.99.2:9999/rpc"
int(3)
send_notify:""
witness_info: [{"id":"1.5.118","account":485699321,"name":"yoyo485699321","sequence":1,"is_valid":true,"signing_key":"YYW7TSRLZ9EXZpZqk25atoL2s37Kt31qa7qi78ZR368kCN969rFiT","pledge":"4800000000","pledge_last_update":"2018-04-09T16:27:36","average_pledge":"4769814330","average_pledge_last_update":"2018-04-10T09:29:36","average_pledge_next_update_block":6208938,"total_votes":"1012502907669","by_pledge_position":"0","by_pledge_position_last_update":"13192707760156474609520154309632187","by_pledge_scheduled_time":"13192779100955781906176323330356157","by_vote_position":"0","by_vote_position_last_update":"8327365446400524735205121087916251","by_vote_scheduled_time":"8327365782480909634055199728870765","last_confirmed_block_num":6208607,"last_aslot":6220862,"total_produced":1143,"total_missed":3,"url":"https:\/\/github.com\/ety001"}]
total_produced: 1143, total_missed: 3
2018-04-10 10:23:38


***********
Finish!!
```

如果想查看监控程序的工作状态，执行下面的命令即可

```
docker logs --tail 50 yoyow_witness_watcher
```

### 4.卸载

卸载非常的简单，只需要执行下面的命令即可

```
./uninstall_bot.sh &amp;&amp; ./uninstall.sh
```

&gt; 如果你只想重新部署监控程序，只需要执行 `./uninstall_bot.sh` 即可，执行完后重新执行 `./install_bot.sh`。如果你中途执行安装脚本有错误的话，也需要先执行卸载脚本后，再重新执行安装脚本。卸载脚本如果都要执行的话，执行顺序一定要是先 `uninstall_bot` 再 `uninstall`。

# 申请 Discord 的频道 Webhook

注册账号就不说了，打开桌面app界面（网页界面应该也差不多），在左下角找到一个加号，点击后如下图

![y1.png](https://steemitimages.com/DQmZF3sQtGZo54dNxNHgcyvtXb8JitUJv7azLtL1gAyH3Rr/y1.png)

选择创建一个服务器，进入下个界面，配置下你的服务器的名字和位置后，即可完成创建，进入你的服务器，新建一个频道，然后在频道右侧有个齿轮，点击一下，如图

![y2.png](https://steemitimages.com/DQmayhuefPERpPxwx2kjtnpJ5KxgFxZ8k6wm8U2EFCRwa9q/y2.png)

打开频道配置页面后，找到 Webhook 选项，然后创建一个新的 Webhook，如图

![y3.png](https://steemitimages.com/DQmVEbzzEQUoZC9GVTKbq6jLrqSgTDe4bjM3ePatri4HUVV/y3.png)

填写下 Webhook 的名字后，即可完成创建，里面的 URL 即为你的 Webhook 地址。

![](http://image2.135editor.com/cache/remote/aHR0cHM6Ly9tbWJpei5xcGljLmNuL21tYml6X3BuZy91TjFMSWF2N29KOFc2ZHVCMU5samNoUWliaWNwczRlQTNoYnR2WnJRbENRODROUFRBN3RFdDZvSkxYeGlhUFdsSDlkNlFKV1pLbHdNUzJEQWhXMEgxMGZwZy8wP3d4X2ZtdD1wbmc)

欢迎给我投票，我的 **YOYOW** 号是 **485699321**。