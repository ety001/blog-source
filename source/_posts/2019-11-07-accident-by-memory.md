---
author: ety001
layout: post
title: 由四条内存引起的事故
tags:
- Docker
- LVM
- 经验
- Server&OS
---

昨天新买的四条服务器内存到了，于是早上去安装一下。

很不幸的是，关机安装完内存条后，系统起不来。第一反应是内存没有插好。
拔下所有新装的内存，先试试能不能开机，结果不能。

系统一直卡在一个光标闪烁的状态。

由于一直就很想重做这个服务器的系统，当时装的时候，忘记做LVM了，
所以这次故障也懒得修了，直接开始重做系统。

花了2个小时，把基础系统做完，重启了几遍看看有没有什么问题，一切正常。

看到内存插满主板达到256G顶值后，心里美滋滋，心想这下可以大开杀戒了。

![](/upload/20191107/cJ64E7n1icFTMST0S7wfmLxJNeKcdmhatHVTRGkX.png)

结果下午回到家，没安装几个服务，主机就挂了。

由于我的服务器电源连接在米家的电源开关上，所以我进行了远程重新断电上电操作。
通过米家可以看到机器自动启动成功了，但是一直连不上，怕是系统又进不去了。

折腾了半天没有成功后，不得不再回去看看是什么情况。

重新接上显示器后，发现跟早上的情况一个样，目测应该是硬盘有问题。打开 BIOS 看了下，果然

![](/upload/20191107/Nvjm1ifcDd4IWZ9rgLWZbjcjcc9v8nHLX3XvJe24.png)

一共三块硬盘，只识别出来了两块，最关键的那块带这 grub 引导的硬盘没有识别出来。

考虑到新系统上了 LVM ，我这块没有识别出来的硬盘（金士顿）和另外一块东芝的做成了一个逻辑组，
所以在考虑能不能把金士顿这块从逻辑组里踢出去。

但是我重启引导进U盘里的系统后，发现并没有金士顿那个硬盘

![](/upload/20191107/68U5TBj6LcWNAf1yEGo6m7KBhhQ59X8oVJQw0omm.png)

有点慌！既然系统间歇性能启动起来，那看来硬盘坏的不严重。
估计重启几次，肯定会有一次能挂上。在重启了三四次后，终于检测出来了。

![](/upload/20191107/7NwjgoAD7rOxTbLNU5WN6MqIZB4C1cqSKFBQkQkU.png)

**好，既然监测出来了，让我先理顺一下目前的情况。**

1.当前是金士顿（`/dev/sdb1`）和东芝（`/dev/sdc1`）做了一个逻辑组 `/dev/vssd`

![](/upload/20191107/Xr94c8OiTCW07NmdItTrFkKLu5bsYZAxjr23guYP.png)

2.然后在 `/dev/vssd` 这个逻辑组上划分了两个逻辑卷 `/dev/vssd/vboot` 和 `/dev/vssd/vmain`

![](/upload/20191107/cHbNU0bzz2MwSDjfRi8ocJoGwncWPNAkm5Fw0jKZ.png)

3.系统有两个分区，`/` 挂在 `/dev/vssd/vmain` 上，`/boot` 挂在 `/dev/vssd/vboot` 上。
尝试了挂载 `/` 和 `/boot` ，发现 `/` 挂载成功，`/boot` 挂载失败，提示磁盘有错误。
系统目前不超过 7G 大。

![](/upload/20191107/f7GGEkqToEkeDf8rTaQU8N3yisEOLov21OYquGl0.png)

**情况理顺完，我们的思路也就有了。**

1. 把 `/dev/vssd/vmain` 缩小到 `/dev/sdc1` 的大小以内，
2. 从 `/dev/vssd` 中把 `/dev/vssd/vboot` 删除，
3. 把 `/dev/sdb1` 这个 `pv` 从 `/dev/vssd` 逻辑组中删除，这个时候，逻辑组里就没有金士顿硬盘了，
4. 在逻辑组 `/dev/vssd` 中再新建一个 `/dev/vssd/vboot` 逻辑卷，
5. 重新调整 `/dev/vssd/vmain` 的大小，让其把剩余所有的空间占有，
6. 重新挂在 `/dev/vssd/vmain` 和 `/dev/vssd/vboot`，在 `/dev/vssd/vboot` 上安装内核，
7. 重新生成 `fstab`
8. 重新安装 `Grub` 到 `/dev/sdc` 上，并生成新的 `grub.cfg` 存储到 `/dev/vssd/vboot` 上。

**开始实施。**

1.缩小 `/dev/vssd/vmain`，需要先监测才能缩小

```
w2fsck -f /dev/vssd/vmain
```

执行缩小，由于我的东芝是400多G，那么我只要缩小到400G内就好了，懒得计算，取了个整 300G

```
# 先缩小文件系统
resize2fs /dev/vssd/vmain 300G
# 再缩小逻辑卷
lvreduce -L 300G /dev/vssd/vmain
```

三步操作如下图

![](/upload/20191107/9Gyjtf9HMeRTAoNrvJBiS10LNLA7jdnE3mZ5GjD2.png)

2.从 `/dev/vssd` 中把 `/dev/vssd/vboot` 删除，

```
lvremove /dev/vssd/vboot
```

3.从逻辑组中移除金士顿硬盘

```
vgreduce vssd /dev/sdb1
```

操作完可以看到逻辑组（VG）里只有一个 PV 了，并且 VG 的容量跟东芝的硬盘一样大了

![](/upload/20191107/mpbFv6uTk1mzZLsYCNNRVCyGFZxCCWrwrihrUIAT.png)

4.新建 `/dev/vssd/vboot`

```
lvcreate -L 200M vssd -n vboot
```

5.扩容 `/dev/vssd/vmain`

```
# 注意这里参数是小写L
lvextend -l +100%FREE /dev/vssd/vmain
```

![](/upload/20191107/T9iSiBSmcR1wcAojApuQwD2JJAEMvRJIrMIQULyl.png)

6.格式化 `/dev/vssd/vboot` 后，重新挂载

```
mkfs.ext2 /dev/vssd/vboot
mount /dev/vssd/vboot /mnt/boot
```

![](/upload/20191107/HoFpTcLPLvKDswKBRNYdWrP1uf9s8GqueyJ7sP8s.png)

重新安装内核

```
pacstrap /mnt linux linux-firmware
```

![](/upload/20191107/vXuQTb0rKjCpuPJ6Z2tf3SRj9ivOqhHitm3OfNrK.png)

7.生成新的 `fstab`

由于 `/dev/vssd/vboot` 是新创建的，所以原来分区的 `UUID` 也就不存在了，因此需要更新 `fstab`，
否则启动的时候会找不到分区。（通过截图可以看到原来的 `UUID`）

```
genfstab -U /mnt > /mnt/etc/fstab
```

![](/upload/20191107/nYXNhrTSKrRZvjcq11R7Y5mvaSekRcf9pLg0sfJo.png)

8.重新安装 Grub ，生成新的 `grub.cfg`

```
# 进入chroot
arch-chroot /mnt
# 安装 grub 到 /dev/sdc
grub-install --target=i386-pc /dev/sdc
# 生成新的 grub.cfg
grub-mkconfig -o /boot/grub/grub.cfg
```

![](/upload/20191107/djob2p07zHs9gfNeV9ce89IN7s5BGySE0Fw5plsb.png)

9.所有操作结束后，退出 `chroot`，卸载所有已挂载分区，重启。

#### 完美启动！！！！
