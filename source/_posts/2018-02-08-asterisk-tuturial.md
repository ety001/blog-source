---
author: ety001
layout: post
title: '出国狗的福音--使用树莓派搭建跨国语音短信设备'
tags:
- 教程
---

> 有朋友推荐了一个设备，我还没有测试，不过原理应该跟自己用树莓派搭建的系统一样，购买地址：https://item.taobao.com/item.htm?spm=a230r.1.14.53.250350a1rJhohU&id=558848686579&ns=1&abbucket=18 -- 更新于 20180208

对于出国狗来说，在国外想要使用国内手机语音短信服务是个比较头疼的事情。这篇教程将教你用树莓派基于
 *Asterisk* 实现一个 *PBX* 系统。最终的效果是：你可以在国外通过互联网使用你国内的手机号，享受的是国内手机号的资费。

### 基本的原理图

![1.png](https://steemitimages.com/DQmeYfsJr2q47CAM3c6r2D7HGnBrzD5BRpcL9FKWMrHuPcJ/1.png)

### 需要准备的东西

* 树莓派3B（使用2代也可以，不过性能不是很好）

![2.jpg](https://steemitimages.com/DQmUXTNoRjrGCMrPipXrbCrjCvowCfFdrwdzYL1byhHqLfB/2.jpg)

* 一个带语音支持的 *3G* 卡托（尽量买华为的，并且一定要注意带语音支持，一般带语音的都是要卖出海外的，卖给国内的都是阉割掉语音功能的。我手里还有4个，有需要的可以找我，亲测可用，150国内包邮，国外的可以考虑从 [阿里巴巴](http://www.alibaba.com/) 上搜索 *3g dongle voice* 来购买。按照我两年前的实验来看，50多 *CNY* 的带语音卡托在树莓派上识别不出来，建议优先考虑华为，另外在 [这里](https://github.com/bg111/asterisk-chan-dongle/wiki/Requirements-and-Limitations) 有一份测试通过的型号清单，不过某些型号貌似也有好几种版本，比如我曾经买到过一个E169是没法用的。）

![3.jpg](https://steemitimages.com/DQmSjbHWQ3cuUwZy8JqLBu6eGAr5MDnN6UrpL6xUQ4MH5aL/3.jpg)

* 一个带电源的USB HUB（一定要带电源，因为供电不足的话，来去电的时候可能不稳定）
* 一根HDMI转VGA线（如果有HDMI显示器，可以忽略该配件）
* 一张至少8G的TF卡（建议买树莓派的时候一并购买）
* 5V2A的电源

### 前置技能

* Linux基本知识
* 最好有折腾过树莓派
* 折腾的精神

### 基础配置

1.首先我们需要去 <http://www.raspberry-asterisk.org/downloads/> 这里下载最新的镜像，该镜像是基于 *Debian*
 已经封装好的 *FreePBX* 系统，本次教程使用的是 *raspbx-03-12-2017.zip*，其中 *Asterisk 13.18.3*, *FreePBX 14.0.1.20*。
**备注：该网站需要翻墙访问！**

2.下载后，解压 *raspbx-03-12-2017.zip*，使用你熟悉的烧录软件，把解压出来的 *.img* 文件烧录进TF卡中。推荐使用 [Etcher](https://etcher.io/) 进行烧录操作。用 [Etcher](https://etcher.io/) 烧录还是比较方便，只需要三步即可。第一步选择镜像文件，第二步选择你的TF卡，第三步点击 *Flash* 即可开始。

![](https://steemitimages.com/DQmZ1Eae6p71XY1rG77TYAPTVXt7uYk4fnRwBu5SBMNxE7z/image.png)

3.插入TF卡到树莓派中，然后上电。系统默认用户密码为： *root / raspberry*。

4.登陆后，先配置 *WiFi* （如果计划使用网线，可以跳过该步，建议使用网线，稳定），打开 `/etc/wpa_supplicant/wpa_supplicant.conf` 文件，

```
country=GB
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
# 增加如下配置，WiFi的ssid和密码
network={
    ssid="ety001_router"
    psk="12345678"
}
```

增加配置后，输入 `reboot` 进行重启，重启后，`ifconfig` 就能看到 *IP* 了，系统的 *ssh* 默认是开启状态，现在就可以使用 *ssh* 了。

另外镜像默认使用 *4G* 空间，如果你想扩展到 *TF* 卡全部空间，执行下面的命令

```
raspi-config
```

选择 *Advanced Options* ，再选择 *Expand Filesystem*，即可完成扩充。除此之外，也可以用 `fdisk` 命令完成，具体方法可以参考我博客上很早之前的一篇 [博文](https://blog.domyself.me/2015/01/23/expand-raspberry-pi-sd-card-space.html)。

5.打开浏览器，访问你树莓派IP，会看到如下的配置页面

![](https://steemitimages.com/DQmf8cLfnALZwekkbof61bzTwJuT4NV8pfrhkvLxCywX1xn/image.png)

6.增加管理用户后，显示下面的登录界面，

![](https://steemitimages.com/DQmebVv48wZJeQPuGvhmK47oZ1kuSPy7ggZBnZfZwvS8UWo/image.png)

7.点击 `FreePBX Administration` 进行管理员登陆，开始配置，登陆后进行语言和时区设置

![](https://steemitimages.com/DQmRxqyu7kDgwe4CAbLhtMMWdgWHwDSi3Gugw7NJpHGobPf/image.png)

8.设置成功后，进入了管理主界面

![](https://steemitimages.com/DQmRmkBgSRGi6Hpv2xGtLmwbx9XBKPsWjKj99PMiAq34Knv/image.png)

9.从 `Application` => `Extensions` => `Add Extension` => `Add New PJSIP Extension`

![](https://steemitimages.com/DQmXxFVjaH27ZK1Kq72xzojCRXHSLaLZZXAs4PnZYS74zxA/image.png)

![](https://steemitimages.com/DQmaydKeB9mJtgBLLbiTzNL4WL89nFobXC2FC8vK8PEmEqy/image.png)

10.需要填写的项目有 *User Extension*，*DisplayName*，*Secret*，*Link to a Default User*.

![7.png](https://steemitimages.com/DQmavEHVmqP8nd6H8JoPXs178ppUC8aChiYkVn87XRjR6Dk/7.png)

其中 *User Extension* 是你的内线号码，用于呼叫和登陆客户端；
*DisplayName* 是用于呼叫时的显示，可选填；
*Secret* 是你在客户端登陆时需要填写的密码，请使用健壮的密码，详见最后的 **安全** 章节；
*Link to Default User* 是让用户自己管理自己的号码，如果不需要，则选 *None*。

点击 *Submit* 后，保存成功。用同样的方法再创建一个用户用于测试。

创建完两个用户后，点击右上角的 *Apply Config* 使配置生效。

![](https://steemitimages.com/DQmUvEQBoP4kFq6gkgDA4Dfw8F94B7CcFTNiLXPM1k8CFxS/image.png)

11.在 *Settings* => *Asterisk SIP Settings* 页面的 *General SIP Settings* 标签页下面，*External Address* 一栏填写你的外网IP或者你的外网域名，这里我填写了我的外网IP。*Local Networks* 中填写你的树莓派所在的子网。*RTP Port Ranges* 里，填写 *10000* 到 *10100*。这里不要使用 *20000*，测试来看，如果你只是自己用，设置 *10100* 很稳定。点击 *Submit* 保存。

![8.png](https://steemitimages.com/DQmSxMmFx8fAAjhktmpMeM7t6YKbHoaGZ9ti4uPuJcLVW3E/8.png)

12.切换到 *Chan PJSIP Settings* 标签页下面，把 *tcp* 设置为 *yes*，点击 *Submit* 保存。
*Asterisk* 默认使用的是 *UDP*，为了能保证手机app在后台运行时，可以及时收到来电提醒，需要开启 *tcp* 通信。

![9.png](https://steemitimages.com/DQmefPwudwdN4fWGxXddERRvYemJQvqR5Zq6QdfitpyW2gz/9.png)

![](https://steemitimages.com/DQmeJ9NorhwV2yL8tWVKuhg6vBqBRs6DtosMStUinPdh274/image.png)

13.去自己的路由器上，设置端口映射，需要打开 *5060* 和 *10000-10100*，可以参考下图

![4.png](https://steemitimages.com/DQmNhr5za8A8pnyu9aNku5bPBrQtKModcVHLjBMpEAqVuNA/4.png)

![5.png](https://steemitimages.com/DQmabg36E8eZuerJ7TcfxNTZoCiZ4tYUfWWWNSjNNNnrsTj/5.png)

14.去 <http://www.linphone.org/> 下载 *Linphone* 到你的手机和电脑上，如下图分别用刚才新建立的两个账号登陆两个客户端。

![1.jpeg](https://steemitimages.com/DQmZieaAJTu8RaCoqrYTKqxHrQVV5R1wnRKLhskFDZ39QFw/1.jpeg)

![2.jpeg](https://steemitimages.com/DQmYraQ7jhL1wC3cFEo5XgPCFQwU2sD6miWRcUwiazmMr5J/2.jpeg)

![3.jpeg](https://steemitimages.com/DQmb9ETeHyPK8jhghBs8eAixQT3VZUjCATKuvVNVwU4QzFD/3.jpeg)

![a1.png](https://steemitimages.com/DQmS6gRMmMdSpbDRQDeWNEWmq9DMHT88ggDY45vLvoTvm3j/a1.png)

![a2.png](https://steemitimages.com/DQmaFfKZByWG2Yt7PkMmjF4EkxGV5o75cyipWA3Cro4QfRo/a2.png)

![a3.png](https://steemitimages.com/DQmQWksaW3rj9LbWABTN9iWjfwfh4yZCA1kvLC5D1e3qGmW/a3.png)

![a4.png](https://steemitimages.com/DQmWL5oQHjaM61CnKDu5boEPgZPGAHLLSyZkfkf8PcKCLbY/a4.png)

现在从手机上，拨打 *102* ，如果以上设置没有问题的话，电脑上就能响铃，接起来，两边听一下，看看有没有什么问题。如果有一方听不到，很可能是端口映射的问题，重新检查下配置。端口映射这里偶尔会有莫名奇妙的问题。

### 配置GSM，实现呼入和呼出

1.把 *SIM* 卡插入 *3G* 卡托，把 *3G* 卡托插到树莓派或者 *USB HUB* 上。

2.*SSH* 连接到树莓派后，执行下面的命令安装 *dongle* 扩展

```
root@raspbx:~# install-dongle
```

![](https://steemitimages.com/DQmQiMuMpn4trjb5zyeo5eKJPiEQxddrXUmdtGQe2vUM9qp/image.png)

其中①输入你插入 *3G* 卡托里的手机卡号，②输入你要准备接收短信的邮箱地址，③如果你不想转发短信留空即可。

安装到最后，会再问你是否需要安装网页界面的发短信工具（即访问地址就是 *http://raspbx_ip/sms*），按照提示输入即可

```
Would you like to install a webpage for sending SMS with
chan_dongle? (http://raspbx/sms/) [y/N] y
Enter password for SMS page: 123456
```

**注意：安装 *dongle* 扩展需要翻墙**

3.回到网页配置界面，依次访问 *Connectivity* => *Trunks*  => *Add Trunk* => *Add Custom Trunk*

![](https://steemitimages.com/DQmWqm8ojVQbY94AnwXdkgUHZwuNvsL4GSfEBeBMDR3Q1Dg/image.png)

![b2.png](https://steemitimages.com/DQmYDqCy2oe5BUbHjTb8DM2PH5hEqC9fBSGxDCn4AUXcwVV/b2.png)

4.在 *General* 标签页下面，设置一个 *Trunk Name*，*Outbound CallerID* 中填写你的手机号

![b33.png](https://steemitimages.com/DQmSg3izeiNK2srq86kgVE2inKur6GNxdx7UJntnzpAfzf7/b33.png)

5.在 *custom Settings* 中设置 `dongle/dongle0/$OUTNUM$`。

![b44.png](https://steemitimages.com/DQmQS9kjLvNymQNX8obrTUSF8CQYv5MFEhrUgEsjjaiecS9/b44.png)

这里如果你只是插了一个 *3G Dongle*，那么就是默认 *dongle0*，如果你设备上插了多个设备，你需要在命令行下输入一下命令，查看下所有的 *Dongle*：

```
root@raspbx:~# asterisk -rx "dongle show devices"
ID           Group State      RSSI Mode Submode Provider Name  Model      Firmware          IMEI             IMSI             Number        
dongle0      0     Free       6    5    4       CHN-CUGSM      E1750      11.126.10.00.00   359767033517971  460090019804894  +8617xxxxxxx44
```

6.点击 *Submit* 保存设置，然后点击右上角的 *Apply Config* 使配置生效。

7.从 *Connectivity* => *Outbound Routes* => *Add Outbound Route* 中，在 *Route Settings* 下面填写一个 *Route Name*，在 *Trunk Sequence for Matched Routes* 中选择刚才添加的 *Trunk*。

![b3.png](https://steemitimages.com/DQmaGPqX8bq3FNWsdh6FFZPd4U61fhzLnaWX2uttcMZua9N/b3.png)

6.切换到 *Dial Patterns* 标签下，按照下图来配置拨号规则，这里配置的规则是，匹配所有0开头的电话号码，把所有0开头的号码，去除开头的0后，转发到我们设置的那个 *Trunk* 上，进行呼出操作。

![b4.png](https://steemitimages.com/DQmPrRxMQAouB4JUo6UKPjudEikazHhALdtXU5A1wQjrZ3J/b4.png)

7.点击 *Submit* 保存配置，点击右上角 *Apply Config* 使配置生效。生效后，你现在可以用你的 *App* 进行外呼操作了，只要在要拨打的电话前加拨0，即可完成外拨。

8.在 *Connectivity* => *Inbound Routes* => *Add Inbound Route* => *General* 下，配置 *Set Destination* ，选择 *Extension*，从已经添加的 *Extension* 中，选择一个即可。点击 *Submit* 保存配置，点击右上角 *Apply Config* 使配置生效。生效后，你可以拨打你的 *3G Dongle* 中的手机卡号，如果顺利，你手机上的 *App* 将会接到这个呼入操作。

![d1.png](https://steemitimages.com/DQmRxz55NeRbi4v1Cp14cn8Eq6pzrNJ865AyKePZcSkjmZs/d1.png)

![d2.png](https://steemitimages.com/DQmbMYLBAbZ9t6dr6mWdmVih3wQnzhHC9t9XyuYbrGJUZaU/d2.png)

### 配置 *Email*，测试收发短信

1.输入如下命令进入 *Email* 配置界面：

```
# dpkg-reconfigure exim4-config
```

2.选择 *internet site; mail is sent and received directly using SMTP*

![e1.png](https://steemitimages.com/DQmQkKY3gJdP32Rqun9w7nJ5BpeLAMQ3iWBDtSXR2fXSpPi/e1.png)

3.配置你的发信域名

![e2.png](https://steemitimages.com/DQmVbB56XP6BRQWp9E9nU3cK6ahxPPxRkFQe1q9P26wJHAZ/e2.png)

4.保持默认值

![e3.png](https://steemitimages.com/DQmcHJMRN5jkuRaG9Uc3DCPFWDaMC67cYHAGuLdanH4dYD9/e3.png)

5. 配置为你的发信域名

![e4.png](https://steemitimages.com/DQmVdXQZEEhkA1dB2DdHhPQ4Zr3PnZ1n7PrVvhvbHWTNhHZ/e4.png)

6.以下几步保持默认值

![e5.png](https://steemitimages.com/DQmcMYZhBJP7CcSbuFaEELwUx5Nhs5Cnkyb4nTjvErmNJSQ/e5.png)

![e6.png](https://steemitimages.com/DQmYNEaizm8VUaDHM9jXJ2PYNMp7NYg4MZ4vfszJYKu1td6/e6.png)

![e7.png](https://steemitimages.com/DQmdveDTjFUEDtB9evWiujvkDF3dceTKz3KYkaLDWGCPkjk/e7.png)

![e8.png](https://steemitimages.com/DQmXwniU9ZN5c9AQAjpSAqZfsmQZC4gArWFsSUis7LRfJXn/e8.png)

![e9.png](https://steemitimages.com/DQmXcqZ4F7z1TTfSGihKhdhiQoj9XbRbHY2QzGqbo7oR1S5/e9.png)

7.该步输入 `root`

![e10.png](https://steemitimages.com/DQmRVY6ffJ5yJtKAzg5tU6XcGAD5dDWCGMvb9cCGfULfSVB/e10.png)

8.完成发信配置后，使用 `send_test_email <your_email>` 命令进行发信测试。打开你的邮箱，检查垃圾箱，100%的会被拦截，像我用的腾讯的企业邮，在 *自助查询* 中可以找到拦截信息，为了收信顺利，把你上面配置的发信域名加入邮箱的域名白名单即可。

![e11.png](https://steemitimages.com/DQmVXxBrpUQ1CpTPw7oDZ4K3P451WS3bBg4bwPSV4FJWTgw/e11.png)

9.用手机给自己 *3G Dongle* 里的手机卡发条短信，应该很快就能收到邮件了，

![](https://steemitimages.com/DQmSDNGwNUnLzXA4SLydE7ZRs8BjsVKyTJ14CRyxLNw4Lw1/image.png)

10.如果想要发送短信的话，我们可以通过 *Web* 页面进行，访问 **http://your_raspbx_ip/sms**，会提示你输入密码，这个密码即为你安装 *Dongle* 扩展的时候输入的那个密码，登陆后如下所示

![](https://steemitimages.com/DQmfJnm7i4cbxdLdhh5vevRBNPRnLqmg2VqojdrWT54oFXL/image.png)

**注意：收件人手机号一定要加国号**

### 设备安全！！！！！

先给大家看一个截图，

![s1.png](https://steemitimages.com/DQmUa2c9h5JnQugb5RfXEJohdV2k1APz4PNHfQV2JQPFHa7/s1.png)

这是目前我的设备被暴力破解的情况。

##### 请一定重视安全问题

再附上我之前的悲惨遭遇：<https://www.v2ex.com/t/394297#reply11>

1.首先，你的 *Extension* 一定要给各个账号配置超强的密码

2.其次，使用 *Fail2ban* 来防暴破。

```
# install-fail2ban
```

3.安装 *Fail2ban* 后，程序会自动启动，我们需要调整下配置，打开 `/etc/fail2ban/jail.conf` 文件，搜索 `[asterisk]`，找到 `maxretry` 项，修改为 2，就是说密码输入错2次，就会被 *Fail2ban* 拦截。再搜索下 `bantime`，修改为 `604800`。配置好后，意味着有人要是输入错两次密码，那么这个人的 *IP* 就会被屏蔽一周。保存后，执行 `systemctl restart fail2ban` 重启服务使配置生效。


### 后记

本来计划争取半天写完，结果写了一天半。最初其实是计划写一本 《面向菜鸟的 Asterisk 教程》，把各种好玩的功能写进去的，让菜鸟也能轻松的用上牛逼的 *Asterisk* 。不过还是感觉自己的水平和能力没有达到，于是放弃了。

目前这篇教程里还未涉及的我已经测试可用的功能，还有 **语音信箱**，**电话会议**，**电话组**。其中 **语音信箱** 功能还是很赞的，可以在自己未接听电话的时候，自动把呼入转接到 **语音信箱**，让给你打电话的人给你留言，留言还可以配置发送到你的邮箱。这些功能有机会我再写教程吧。

目前这套方案，收发短信很稳定，语音通话的话，会受到你在国外手机网络连接回你国内家里的网络情况的影响。按照两年前去欧洲的时候我的测试来看，当时在瑞士的时候，连接回国内打电话大约会有将近1秒的延时，勉强可以通话。

如果有什么疑问，可以在本帖下面留言，我收到 [回复提醒](https://steem-mention.com) 后，会尽力第一时间给出答复。