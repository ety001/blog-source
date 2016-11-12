---
title: 如何启用树莓派3b的蓝牙
author: ety001
tags:
- Server&OS
layout: post
---
表示这次买的树莓派3的坑太多了，蓝牙在Arch下都找不到，最终在论坛搜到了一篇[帖子](https://archlinuxarm.org/forum/viewtopic.php?f=65&t=9961)，

```
That too, is not yet finished by the people at the Pi Foundation.
```

原来基金会的人还没有彻底开发完。。。。WTF。。。。

不过好在有国外网友自己根据 Raspbian 下的包，做了个 Arch 下面的。不过是放在了Aur上，
需要用 `yaourt` 来安装下，这就好办了，[这是原贴](https://archlinuxarm.org/forum/viewtopic.php?f=67&t=10017)

    注意：是在非root下执行的

```
$ yaourt -S pi-bluetooth
$ sudo systemctl enable brcm43438.service
$ sudo reboot
```

重启后，可以看到已经启动成功了，

```
[ety001@docker ~]$ sudo systemctl status brcm43438.service
[sudo] password for ety001:
* brcm43438.service - Broadcom BCM43438 bluetooth HCI
   Loaded: loaded (/usr/lib/systemd/system/brcm43438.service; enabled; vendor pr
   Active: active (running) since Wed 2016-05-11 15:53:51 UTC; 1min 9s ago
 Main PID: 273 (hciattach-rpi3)
    Tasks: 1 (limit: 512)
   CGroup: /system.slice/brcm43438.service
           `-273 /usr/bin/hciattach-rpi3 -n /dev/ttyAMA0 bcm43xx 921600 noflow -

May 11 15:53:51 docker systemd[1]: Started Broadcom BCM43438 bluetooth HCI.
```

接下来安装管理工具

```
$ sudo pacman -S bluez bluez-utils
```

加载mod

```
[root@docker ~]# modprobe btusb
```

启动设备

```
[root@docker ~]# hciconfig hci0 up
```

增加配置，可以让设备开机自启动

```
[root@docker ~]# cat /etc/udev/rules.d/10-local.rules
# Set bluetooth power up
ACTION=="add", KERNEL=="hci0", RUN+="/usr/bin/hciconfig hci0 up"
```

```
 cat /etc/systemd/system/bluetooth-auto-power@.service
[Unit]
Description=Bluetooth auto power on
After=bluetooth.service sys-subsystem-bluetooth-devices-%i.device suspend.target

[Service]
Type=oneshot
ExecStartPre=/usr/bin/sleep 1
ExecStart=/usr/bin/dbus-send --system --type=method_call --dest=org.bluez /org/bluez/%I org.freedesktop.DBus.Properties.Set string:org.bluez.Adapter1 string:Powered variant:boolean:true

[Install]
WantedBy=suspend.target
```

```
[root@docker ~]# systemctl enable bluetooth
[root@docker ~]# systemctl enable bluetooth-auto-power@hci0.service
[root@docker ~]# reboot
```

重启后，执行 `bluetoothctl` ，

```
[root@docker ~]# bluetoothctl
[NEW] Controller B8:27:EB:B7:AF:FA docker [default]
[NEW] Device 0C:FC:85:B0:08:78 Bluetooth Keyboard
[bluetooth]#
```

开始配对

```
[bluetooth]# agent on
Agent registered
[bluetooth]# default-agent
Default agent request successful
[bluetooth]# scan on
Discovery started
[CHG] Controller B8:27:EB:B7:AF:FA Discovering: yes
[NEW] Device 5F:7A:78:E1:2A:0B 5F-7A-78-E1-2A-0B
[bluetooth]# scan on
Failed to start discovery: org.bluez.Error.InProgress
[CHG] Device 0C:FC:85:B0:08:78 RSSI: -54
[bluetooth]# pair 0C:FC:85:B0:08:78
Attempting to pair with 0C:FC:85:B0:08:78
[CHG] Device 0C:FC:85:B0:08:78 Connected: yes
[agent] PIN code: 547945
[CHG] Device 0C:FC:85:B0:08:78 Connected: no
[CHG] Device 0C:FC:85:B0:08:78 Connected: yes
[CHG] Device 0C:FC:85:B0:08:78 Connected: no
[CHG] Device 0C:FC:85:B0:08:78 Connected: yes
[agent] PIN code: 744661
[CHG] Device 0C:FC:85:B0:08:78 Paired: yes
Pairing successful
[CHG] Device 0C:FC:85:B0:08:78 Connected: no
[bluetooth]# trust 0C:FC:85:B0:08:78
Changing 0C:FC:85:B0:08:78 trust succeeded
[bluetooth]# connect 0C:FC:85:B0:08:78
Attempting to connect to 0C:FC:85:B0:08:78
[CHG] Device 0C:FC:85:B0:08:78 Connected: yes
Connection successful
[Bluetooth Keyboard]#
```

终于可以使用我的蓝牙键盘了~ 赞赞赞！
