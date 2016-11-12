---
author: ety001
title: 在树莓派Archlinux的Cli下连接Wifi
layout: post
tags:
- Server&OS
---

今天弄到一个360的随身wifi，就想给树莓派安装上，这样就不用再用有线连接了。
由于我的 `Archlinux` 没有安装桌面环境，所以只能在命令行下配置。Arch在最近的版本中，
开始使用 `systemd-networkd` 进行网络管理了，具体可以看 [Arch Wiki](https://wiki.archlinux.org/index.php/Systemd-networkd)。

#### 检查驱动

分别执行 lsusb 和 lsmod 后，发现需要自己安装mod。
但是pacman包管理中的是 MT7601 的驱动，而 360wifi 的是 MT7601U，尝试安装了 MT7601，
使用 `dmesg | grep mt7601` 发现有err。于是看了下 Aur，发现 Aur 下有 MT7601U 的驱动，
于是又安装了下 yaourt 。使用 `yaourt -S mt7601u-dkms` ，安装后即可。

#### 安装 wpa_supplicant

```
pacman -S wpa_supplicant
```

#### 配置 wpa_supplicant

```
[root@alarmpi ~]# cat /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
fast_reauth=0
network={
   ssid="your ssid"
   key_mgmt=WPA-PSK
   psk="your password"
   priority=5
}
```

其中 `your ssid` 就是热点名称了，`your password` 就是热点的密码了。

#### 配置 systemd-networkd

```
[root@alarmpi ~]# cat /etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=ipv4
```

其中 `wlan0` 是我的设备名称，请替换成你自己的。

#### 设置为开机自启 并 启动

```
systemctl enable wpa_supplicant@wlan0.service
systemctl start wpa_supplicant@wlan0.service
```

#### 其他内容

如果你使用的是 RTL8188CUS 这个芯片的 wifi，那么可能会遇到下面的错误，

```
nl80211: Driver does not support authentication/association or connect commands
```

请先尝试下面的命令

```
# wpa_supplicant -B -i wlan0 -D wext -c /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
# dhcpcd wlan0
```

如果 wlan0 成功获取到 ip 地址，则证明需要使用wext模式，那么 systemd 的配置如下：

```
# vim /etc/systemd/system/wpa_supplicant@.service.d/wext.conf
-----
[Service]
ExecStart=
ExecStart=/usr/bin/wpa_supplicant -c/etc/wpa_supplicant/wpa_supplicant-%I.conf -i%I -Dwext
```
