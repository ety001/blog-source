---
author: ety001
comments: true
date: 2013-10-11 15:45:20+00:00
layout: post
slug: debian-ubuntu-network-manager
title: Debian/Ubuntu的Network-Manager
wordpress_id: 2504
tags:
- Server&OS
---

debian/ubuntu管理网络连接的有两个东西，图形化的NetworkManager和文字的 ifup/ifdown，如果在 /etc/network/interfaces里设置了网卡信息，那么NetworkManager就不会接管该网卡，如果没有设置NetworkManager默认是会接管网卡的。

当使用 NetworkManager的时候，可以注释掉所有/etc/network/interfaces 里的内容，仅仅保留本地回环网络：
auto lo
iface lo inet loopback
这两句。设置固定ip，可以在NetworkManager图形界面里配置。

关闭NetworkManager
关闭命令：sudo /etc/init.d/network-manager stop
取消开机启动：update-rc.d -f network-manager remove
重启网络：/etc/init.d/networking restart

修改 /etc/network/interfaces 文件，
系统配置部分：本地回环网络。

```
auto lo
iface lo inet loopback
```
有线配置部分：

```
auto eth0
#iface eth0 inet dhcp # 如果你不想用固定ip的话，推荐用固定ip，这样可以省去请求路由分配的时间
iface eth0 inet static
netmask 255.255.255.0
gateway 192.168.0.1 #gateway 0.0.0.0 # 拨号上网请把 gateway全部设置为0
address 192.168.0.112
```

无线配置部分：

```
auto wlan0
iface wlan0 inet static
netmask 255.255.255.0
gateway 192.168.0.1
address 192.168.0.113
pre-up ip link set wlan0 up
pre-up iwconfig wlan0 essid ssid
wpa-ssid TP-Link # 这里的ssid为路由里设置的无线名称
wpa-psk 12345678 # 无线密码
```

adsl拨号上网：

```
auto dsl-provider
iface dsl-provider inet ppp # dsl-provider 为之前配置好的拨号名称
provider dsl-provider
```
