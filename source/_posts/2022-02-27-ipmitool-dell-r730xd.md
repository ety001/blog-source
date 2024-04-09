---
author: ety001
date: '2022-02-27 08:24:49'
layout: post
title: 使用 ipmitool 对 dell r730xd 风扇调速
tags:
  - 经验
  - 服务器 
---

这两周一直在折腾新买的这台二手 r730xd。第一次上电的时候，风墙的6个18000转风扇的满速运行的噪音太感人了。让我想起来当年在机房跟同事维护机器的时候，说话完全靠喊的记忆。

既然风扇转速高，就去看看主板bios里有没有设置，结果看了半天，从bios到dell服务器的idrac，就没有找到可以手动设置风扇转速的地方。

我当时也是傻，没有放狗搜索一下，就直接准备干静音风扇了。。。

淘宝和闲鱼搜索了好几圈，都没有服务器用的 60*60*38 风扇的接口。

![image.png](/img/2022/02/01.png)

最后随机在一家店里买了一个5000转的，准备自己动手改一下。

![image.png](/img/2022/02/DQmYhruiGxpBbCf7ktsTe2yRaXbbCtynFALkDDkkB3TvLkY.png)

最后用杜邦线的塑料胶头改装成功了，上电测试没有问题。赶紧下单买剩下的5个。

第一周就这么过去了。

等待了五天，另外5个风扇到了，花了3个小时完成改装，改装后的风墙这个样子：

![image.png](/img/2022/02/DQmZypWE6ZT5N6G6QjENnunTJXsLFsgT1hrgHgfjcSZR4z3.png)

由于放弃了快拆头，只能手动一个个插。上电后，成功识别风扇，噪音小了很多，但是依然是吵。

不死心的我，都要准备换水冷了，这个时候，搜索到可以使用dell的 ipmitool 来给风扇调速，唯一的缺点是，机器断电后重新上电，配置还需要重新设置。

安装很简单

```
pacman -S ipmitool
```

或者

```
apt-get install -y ipmitool
```

设置为手动调速

```
ipmitool -I lanplus -U 用户名 -P 密码 -H iDracIP raw 0x30 0x30 0x01 0x00
```

设置回自动调速

```
ipmitool -I lanplus -U 用户名 -P 密码 -H iDracIP raw 0x30 0x30 0x01 0x01
```

设置风扇转速，这里我写了个脚本 speed.sh

```
#!/bin/bash
USER=xxxx
PASS=xxxx
IP=192.168.1.11
DEFAULT_SPEED=0xf

if [ "$1" != "" ]; then
	fan=`printf "0x%x" $1`
else
	fan=$DEFAULT_SPEED
fi
echo $fan
ipmitool -I lanplus -U $USER -P $PASS -H $IP raw 0x30 0x30 0x02 0xff $fan
```

设置为可执行文件，然后想要设置风扇转速为 30%，则执行

```
./speed.sh 30
```

风扇成功降速，且cpu温度也能压住，问题解决！

所以为啥我一开始不先搜索一下呢？ 哭笑。。。
