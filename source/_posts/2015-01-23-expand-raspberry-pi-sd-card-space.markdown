---
author: ety001
comments: true
date: 2015-01-23 01:46:58+00:00
layout: post
slug: expand-raspberry-pi-sd-card-space
title: 扩容树莓派SD卡分区空间
tags:
- Server&OS
---

每次装完树莓派上的系统，第一件事就是要把没有利用的SD卡空间利用上，因为img镜像一般都是最小化的，所以用dd还原镜像到SD卡后，SD卡都还会有一部分未使用的空间。
之前我一直都是装完系统，把SD卡笔记本上的gparted这种图形界面的软件进行扩容操作，由于现在笔记本上没有Archlinux系统了，所以这次就直接在树莓派上操作了。

    [root@alarmpi ~]# fdisk /dev/mmcblk0

    Welcome to fdisk (util-linux 2.25.2).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.


    Command (m for help): p
    Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x0e8c6e83

    Device         Boot  Start     End Sectors  Size Id Type
    /dev/mmcblk0p1        2048  206847  204800  100M  c W95 FAT32 (LBA)
    /dev/mmcblk0p2      206848 2097151 1890304  923M 83 Linux

    Command (m for help): d
    Partition number (1,2, default 2): 2

    Partition 2 has been deleted.

注意第二个分区的Start，记录下来。然后删掉第二个分区。

    Command (m for help): n
    Partition type
       p   primary (1 primary, 0 extended, 3 free)
       e   extended (container for logical partitions)
    Select (default p): p
    Partition number (2-4, default 2): 2
    First sector (206848-31116287, default 206848):
    Last sector, +sectors or +size{K,M,G,T,P} (206848-31116287, default 31116287):

    Created a new partition 2 of type 'Linux' and of size 14.8 GiB.

    Command (m for help): p
    Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x0e8c6e83

    Device         Boot  Start      End  Sectors  Size Id Type
    /dev/mmcblk0p1        2048   206847   204800  100M  c W95 FAT32 (LBA)
    /dev/mmcblk0p2      206848 31116287 30909440 14.8G 83 Linux

创建个新的主分区，First sector输入第一步记录下来的那个值，也就是我这里的Default的值。新建好后，输入p查看，第二个分区的size已经调整完毕。

    Command (m for help): w
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Re-reading the partition table failed.: Device or resource busy

    The kernel still uses the old table. The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8).

    [root@alarmpi ~]# reboot

输入w，保存分区表并退出，会提示分区表写入失败，因为设备正忙，直接重启即可。

    [root@alarmpi ~]# resize2fs /dev/mmcblk0p2
    resize2fs 1.42.12 (29-Aug-2014)
    Filesystem at /dev/mmcblk0p2 is mounted on /; on-line resizing required
    old_desc_blocks = 1, new_desc_blocks = 2
    The filesystem on /dev/mmcblk0p2 is now 3863680 (4k) blocks long.

    [root@alarmpi ~]# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/root        15G  647M   14G   5% /
    devtmpfs        214M     0  214M   0% /dev
    tmpfs           218M     0  218M   0% /dev/shm
    tmpfs           218M  260K  218M   1% /run
    tmpfs           218M     0  218M   0% /sys/fs/cgroup
    tmpfs           218M     0  218M   0% /tmp
    /dev/mmcblk0p1  100M   17M   84M  17% /boot
    tmpfs            44M     0   44M   0% /run/user/0

重启后，立即执行resize2fs命令，df查看容量，Avail已经是14G啦，搞定，收工。

**码字不易，见好就分享~**
