---
author: ety001
comments: true
date: 2014-02-14 02:40:23
layout: post
slug: iptables-nat-route
title: 如何使用iptables的NAT功能把Linux作为一台路由器使用？
wordpress_id: 2576
tags:
- Server&OS
- 配置
---

近期做cobbler服务器，由于就一块网卡，前几天折腾了一个usb的网卡的驱动，也算是折腾好了，再后来忘记什么原因了，就又回到了单网卡，做虚拟ip的方法，但是出现的情况是虚拟网卡做完后，上不了网，因为虚拟出来的ip段是没法上网的，估计是电脑走的网关错了，route -n看了下，果然，把虚拟网卡配置文件中的GATEWAY去掉，重启网络就可以了，另外附上在解决这个问题时找到的关于做NAT的方法。

方法:

提示: 以下方法只适用于红帽企业版Linux 3 以上。

1、打开包转发功能:

echo "1" > /proc/sys/net/ipv4/ip_forward

2、修改/etc/sysctl.conf文件，让包转发功能在系统启动时自动生效:

# Controls IP packet forwarding

net.ipv4.ip_forward = 1

3、打开iptables的NAT功能:

/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

说明：上面的语句中eth0是连接外网或者连接Internet的网卡. 执行下面的命令，保存iptables的规则: service iptables save

4、查看路由表:

netstat -rn 或 route -n

5、查看iptables规则:

iptables -L

查看nat表

iptables -t nat -vnL POSTROUTING --line-number

