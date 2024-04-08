---
author: ety001
layout: post
title: OpenWRT的wifi掉线问题及其它配置
tags:
- Server&OS
---

##WiFi经常掉线问题

相关报错:

```
daemon.info hostapd: wlan0: STA 4c:8d:79:f2:53:9c IEEE 802.11: disconnected due to excessive missing ACKs
```

在把极壹刷成OpenWRT后，使用了半周多了，稳定性还是不错的，今天用极壹替换掉了家里的总入口的TpLink，
发现接上网线后，wifi在刚开始就连不上，后来连上了，用了2个多小时后，就总是掉线，到最后就连不上了。
不过重启路由后，又好了。看了日志发现好像验证相关的问题，经过搜索，发现大家的解决方案都是把组密钥更新关掉了，
我也先关掉再看下吧，配置如下：

```
#修改/etc/config/wireless
config wifi-iface
        option device 'radio0'
        option ssid 'yourssid'
        option key 'yourpassword'
        option mode 'ap'
        option encryption 'psk-mixed'
        option network 'lan'
        option wmm '0'
        option wpa_group_rekey '0' #把组密钥更新关掉
        option 'wpa_pair_rekey' '0'
        option 'wpa_master_rekey' '0'
```

保存后，重启网络

```
root@ETYOpenWrt:~# /etc/init.d/network restart
```

####2015-06-12 10:00 update
------------------
貌似这是个不简单的bug，[https://dev.openwrt.org/ticket/12372](https://dev.openwrt.org/ticket/12372)

####2015-06-12 14:27 update
------------------
找到了个解决方案，<https://forum.openwrt.org/viewtopic.php?id=43188>，
按照6楼的方法，加个 `option disassoc_low_ack 0` 配置再试试。

####2015-06-12 15:00 update
------------------
上一个方案不成功。

####2015-06-12 16:58 update
另外一个方法，再试试 <https://www.bungie.net/en/Forum/Post/69319415/0/0/1>

```
root@ETYOpenWrt:~# cat /sys/kernel/debug/ieee80211/phy0/ath9k/ani
            ANI: ENABLED
      ANI RESET: 63
     OFDM LEVEL: 0
      CCK LEVEL: 0
        SPUR UP: 0
      SPUR DOWN: 0
 OFDM WS-DET ON: 0
OFDM WS-DET OFF: 0
     MRC-CCK ON: 0
    MRC-CCK OFF: 0
    FIR-STEP UP: 12
  FIR-STEP DOWN: 14
 INV LISTENTIME: 0
    OFDM ERRORS: 8792
     CCK ERRORS: 11634
root@ETYOpenWrt:~# echo 0 > /sys/kernel/debug/ieee80211/phy0/ath9k/ani
root@ETYOpenWrt:~# cat /sys/kernel/debug/ieee80211/phy0/ath9k/ani
            ANI: DISABLED
root@ETYOpenWrt:~#
```


##Samba配置

先从/etc/passwd中添加一个用户ety001，然后再新加一个samba用户，命令如下：

```
root@ETYOpenWrt:~# smbpasswd -a ety001
```

把ety001换成你自己的用户名，然后再到luci界面里配置下samba就可以了，也可以直接写下面的配置文件：

```
#文件位置:/etc/config/samba
config samba
        option workgroup 'WORKGROUP'  #组名
        option homes '0'  #是否共享家目录
        option name 'ety001_hiwifi' #计算机名
        option description 'ety001_hiwifi' #计算机描述

config sambashare
        option name 'hiwifi'  #共享名
        option path '/upan'  #要共享的目录
        option create_mask '0700'  #文件权限
        option dir_mask '0700'  #目录权限
        option read_only 'no'  #只读
        option guest_ok 'no'  #是否允许匿名登陆
        option users 'ety001'  #可允许操作的用户
```
重启samba即可

##花生壳配置

由于是动态公网IP，所以需要弄个花生壳，要不然多麻烦。需要下载个插件就能搞定了，
地址：[http://www.domyself.me/assets/upload/20150612/luci-app-oray.ipk](http://www.domyself.me/assets/upload/20150612/luci-app-oray.ipk),下载后传到路由器root用户家目录下，执行：

```
opkg install luci-app-oray.ipk
```

安装好以后，就可以在luci界面看到相关的配置页面了，配置很简单，这里略过。

