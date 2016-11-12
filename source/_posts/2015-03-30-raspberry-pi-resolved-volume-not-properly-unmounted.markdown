---
author: ety001
layout: post
title: 解决树莓派Archlinux的Volume was not properly unmounted问题
tags:
- Server&OS
---

回到家后整理完所有的行李后，第一件事，就是把我的树莓派上电，但是系统起来后，发现分区是read-only的状态，
于是输入下面的命令，发现了错误：

```
[root@alarmpi ~]# mount
/dev/mmcblk0p2 on / type ext4 (ro,relatime,data=ordered)
devtmpfs on /dev type devtmpfs (rw,relatime,size=217368k,nr_inodes=54342,mode=755)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/bfqio type cgroup (rw,nosuid,nodev,noexec,relatime,bfqio)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=22,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
tmpfs on /tmp type tmpfs (rw)
mqueue on /dev/mqueue type mqueue (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/mmcblk0p1 on /boot type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,errors=remount-ro)
/dev/sda1 on /pan type ext4 (rw,relatime,data=ordered)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,size=44324k,mode=700)

[root@alarmpi ~]# dmesg | tail
[    7.324417] systemd[1]: Started udev Coldplug all Devices.
[    8.018313] systemd[1]: Started Journal Service.
[    8.866288] systemd-journald[95]: Received request to flush runtime journal from PID 1
[   10.234796] random: nonblocking pool is initialized
[   10.244188] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   11.250720] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   12.784305] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
[   12.793837] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.203803] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0x4DE1
[   14.288086] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
```

发现/dev/mmcblk0p2是以ro模式挂载的，而mmcblk0p1分区可能有数据corrupt。执行下面的命令，把根目录重新挂载，
然后安装下fsck.fat，并修复/boot分区的data corrupt。

```
[root@alarmpi ~]# mount -o remount,rw /

[root@alarmpi ~]# pacman -S dosfstools
resolving dependencies...
looking for conflicting packages...

Packages (1) dosfstools-3.0.27-1

Total Download Size:   0.07 MiB
Total Installed Size:  0.24 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages ...
 dosfstools-3.0.27-1-armv6h                                                        69.1 KiB   691K/s 00:00 [################################################################] 100%
(1/1) checking keys in keyring                                                                             [################################################################] 100%
(1/1) checking package integrity                                                                           [################################################################] 100%
(1/1) loading package files                                                                                [################################################################] 100%
(1/1) checking for file conflicts                                                                          [################################################################] 100%
(1/1) checking available disk space                                                                        [################################################################] 100%
(1/1) installing dosfstools                                                                                [################################################################] 100%

[root@alarmpi ~]# umount /boot

[root@alarmpi ~]fsck.fat -V /dev/mmcblk0p1
fsck.fat 3.0.27 (2014-11-12)
Starting check/repair pass.
Starting verification pass.
/dev/mmcblk0p1: 130 files, 7556/51091 clusters

[root@alarmpi ~]# fsck.fat -a /dev/mmcblk0p1
fsck.fat 3.0.27 (2014-11-12)
/dev/mmcblk0p1: 130 files, 7556/51091 clusters

[root@alarmpi ~]# mount /boot/

```

修复后，重启，发现/目录的挂载还是ro，于是看了下/boot/cmdline.txt

```
[root@alarmpi ~]# cat /boot/cmdline.txt
selinux=0 plymouth.enable=0 smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=noop rootwait
```

在该文件的mmcblk0p2后面加入rw，如下

```
[root@alarmpi ~]# cat /boot/cmdline.txt
selinux=0 plymouth.enable=0 smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=noop rootwait
```

重启后，一切正常了。不过这到底是啥原因导致的呢？经过google，发现是由于意外掉电频度太高，导致的数据损坏，[参考这里](http://ruiabreu.org/2013-06-02-booting-raspberry-pi-in-readonly.html)。貌似好几篇文章都提到了，要把分区做成read-only，需要升级的时候再打开。由于现在我的树莓派内的软件还都没有完全调好，
所以就先不做成read-only了。以后做好bt下载机和家庭数据中心后，再来设置下。
