---
author: ety001
layout: post
title: '使用LVM扩容服务器硬盘容量'
tags:
- 教程
---

昨天新购置了一台大硬盘服务器，为了完成 Steem LightDB 也是拼了。今天机房那边完成了服务器的部署，登陆后发现原本 2 X 1T 的硬盘，只挂了一块，如图：

![](https://steemeditor.com/storage/images/Y9GafQaXSWVChZ7R2bxQM2E5qli2DQHhB20NL3nq.png)

一看是通过 LVM 完成的硬盘管理。并且在 `/dev/sda` 这块硬盘上划出了243M做 `/boot`。还有两个 `/dev/mapper/vg-*` 的 Logical Volume。

再看下目前硬盘的各个分区以及 LVM 是怎么配置的。（**注意：一定要仔细看下现有LVM的配置，我刚开始由于粗心，一直误认为PV是做在了sda上，以为sdb是空硬盘啊，差点酿成大错！！！坑爹的配置，第一次见sda上只放一个引导区的。。。**

```
[root@lightdb ~]# fdisk -l

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes, 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000e0ad8

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  1953523711   976760832   8e  Linux LVM

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes, 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x00040a3c

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      514047      256000   83  Linux

Disk /dev/mapper/vg-root: 990.7 GB, 990665244672 bytes, 1934893056 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg-swap: 8455 MB, 8455716864 bytes, 16515072 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg-tmp: 1073 MB, 1073741824 bytes, 2097152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes



 ### 一开始粗心没看好这里！！！也是太长时间不摸LVM了。。。

[root@lightdb ~]# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               vg
  PV Size               931.51 GiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               1
  Allocated PE          238465
  PV UUID               3MQezN-W53d-oj6q-I3GK-9GdP-j4Yj-hag2Dj





[root@lightdb ~]# vgdisplay
  --- Volume group ---
  VG Name               vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <931.51 GiB
  PE Size               4.00 MiB
  Total PE              238466
  Alloc PE / Size       238465 / 931.50 GiB
  Free  PE / Size       1 / 4.00 MiB
  VG UUID               dzuyJa-LoIn-ZUAY-BvEN-X13J-EYkc-daFgy5






[root@lightdb ~]# lvdisplay
  --- Logical volume ---
  LV Path                /dev/vg/swap
  LV Name                swap
  VG Name                vg
  LV UUID                qNuaiE-j4mA-5dZJ-RsZZ-YqKX-4zSm-P2vWg8
  LV Write Access        read/write
  LV Creation host, time lightdb, 2018-05-12 15:20:38 -0400
  LV Status              available
  # open                 2
  LV Size                <7.88 GiB
  Current LE             2016
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
   
  --- Logical volume ---
  LV Path                /dev/vg/tmp
  LV Name                tmp
  VG Name                vg
  LV UUID                oaS1B0-eSu3-s7B4-L2Dl-EUAs-wQxU-Ueohsl
  LV Write Access        read/write
  LV Creation host, time lightdb, 2018-05-12 15:20:39 -0400
  LV Status              available
  # open                 1
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/vg/root
  LV Name                root
  VG Name                vg
  LV UUID                wqdC7u-9sg4-ekEH-dwR5-kBpy-PdN0-TXVcN0
  LV Write Access        read/write
  LV Creation host, time lightdb, 2018-05-12 15:20:40 -0400
  LV Status              available
  # open                 1
  LV Size                <922.63 GiB
  Current LE             236193
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

在 `/dev/sda` 这个硬盘上创建新的分区，使用剩余的全部空间

```
[root@lightdb ~]# fdisk /dev/sda
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): t
Partition number (1,2, default 2): 2
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): p

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes, 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x00040a3c

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      514047      256000   83  Linux
/dev/sda2          514048  1953525167   976505560   8e  Linux LVM

Command (m for help): w
The partition table has been altered!
```

把 `/dev/sda2` 做成 PV

```
[root@lightdb ~]# pvcreate /dev/sda2 
  Physical volume "/dev/sda2" successfully created.


[root@lightdb ~]# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               vg
  PV Size               931.51 GiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               1
  Allocated PE          238465
  PV UUID               3MQezN-W53d-oj6q-I3GK-9GdP-j4Yj-hag2Dj
   
  "/dev/sda2" is a new physical volume of "<931.27 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sda2
  VG Name               
  PV Size               <931.27 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               gGrU32-2AW0-10Sv-upON-cXEE-hqC9-fe3X76
```

给 VG 扩容

```
[root@lightdb ~]# vgextend vg /dev/sda2 
  Volume group "vg" successfully extended

[root@lightdb ~]# vgdisplay
  --- Volume group ---
  VG Name               vg
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  6
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <1.82 TiB
  PE Size               4.00 MiB
  Total PE              476870
  Alloc PE / Size       476870 / <1.82 TiB
  Free  PE / Size       0 / 0   
  VG UUID               dzuyJa-LoIn-ZUAY-BvEN-X13J-EYkc-daFgy5
```

给 `/dev/mapper/vg-root` 这个 LV 扩容

```
[root@lightdb ~]# lvextend -l +100%FREE /dev/vg/root
  Size of logical volume vg/root changed from <922.63 GiB (236193 extents) to 1.81 TiB (474598 extents).
  Logical volume vg/root successfully resized.
  
```

刷新文件系统
```
[root@lightdb ~]# resize2fs /dev/vg/root
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/vg/root is mounted on /; on-line resizing required
old_desc_blocks = 116, new_desc_blocks = 232
The filesystem on /dev/vg/root is now 485988352 blocks long.
```

查看下是否成功

```
[root@lightdb ~]# df -hP
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/vg-root  1.8T  1.2G  1.7T   1% /
devtmpfs             7.8G     0  7.8G   0% /dev
tmpfs                7.8G     0  7.8G   0% /dev/shm
tmpfs                7.8G  8.6M  7.8G   1% /run
tmpfs                7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda1            243M  148M   83M  65% /boot
/dev/mapper/vg-tmp   976M  2.6M  907M   1% /tmp
tmpfs                1.6G     0  1.6G   0% /run/user/0
```

根目录已经是1.8T，扩容成功！

重启服务器看了下，也没有什么异常，OVER！

---

### 扩展阅读

简单说下什么是 **LVM**。

**LVM** 是 **Logical Volume Manager** 的简称。可以用来在物理硬盘上创建虚拟的卷，使服务器的硬盘动态扩容变的更加轻松。

其中这里面涉及到以下几个常用概念：

* 物理卷（PV, Physical Volume）
物理卷就是指磁盘,磁盘分区或从逻辑上和磁盘分区具有同样功能的设备(如RAID)，是LVM的基本存储逻辑块，但和基本的物理存储介质（如分区、磁盘等）比较，却包含有和LVM相关的管理参数。当前LVM允许你在每个物理卷上保存这个物理卷的0至2份元数据拷贝.默认为1,保存在设备的开始处.为2时,在设备结束处保存第二份备份.

* 卷组（VG, Volume Group）
**LVM卷组类似于非LVM系统中的物理硬盘**，其由物理卷组成。能在卷组上创建一个或多个“LVM分区”（逻辑卷），LVM卷组由一个或多个物理卷组成。

* 逻辑卷（LV, Logical Volume）
LVM的逻辑卷类似于非LVM系统中的硬盘分区，在逻辑卷之上能建立文件系统(比如/home或/usr等)。

其实可以简单的理解为：PV相当于是传统硬盘的扇区，VG相当于是传统硬盘，LV是在VG上划分的逻辑分区。

Over!