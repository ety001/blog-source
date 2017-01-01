---
author: ety001
comments: true
date: 2015-01-22 17:08:58+00:00
layout: post
slug: make-image-of-raspberry-pi
title: 制作树莓派的镜像
tags:
- Server&OS
---

今天想用树莓派的时候，发现树莓派的ArchLinux系统坏了，于是就准备重新下载安装，但是发现官网好像已经不再提供现成的镜像了，需要自己手动制作镜像。。。[点击这里](http://archlinuxarm.org/platforms/armv6/raspberry-pi)查看官方提供的制作方法，[下载地址](http://archlinuxarm.org/developers/downloads)。

由于我用的是OSX，而官方给的教程是在Linux下的操作，于是我就开我的虚拟机操作，但是发现读卡器在虚拟机里的识别有些问题，于是相当要自己做个镜像包。

####第一步 建立空的镜像文件

    dd if=/dev/zero of=new.img bs=2M count=512

因为ArchLinux本身不大，所以建立个1G的镜像文件足够了。

####第二步 用fdisk对new.img进行分区操作

    fdisk new.img

* 输入n进入建立新分区
* 输入p，选择分区为主分区
* 回车，默认1
* 回车，默认开始扇区位置
* 输入 +100M (引导分区100M足够)

这时，第一个分区建立完毕，回到主目录，输入t，再输入c，设置引导分区类型为W95 FAT32（LBA）。（****刚开始烧了4遍，都引导树莓派失败了，就是因为忘记这一步操作了。。****）

* 再输入n进入建立新分区
* 输入p，选择分区为主分区
* 回车，默认2
* 回车，默认开始扇区位置
* 回车，默认使用剩下所有空间。

这样两个分区搞定，输入w，保存分区表，并退出fdisk。

####第三步 挂载new.img成为设备

    kpartx -av new.img

之前的两步都是我会的，但是第三步，我着实的折腾了一番，只是知道可以把img挂成设备用，但是不知道怎么搞，从网上搜索的结果，第一个搜索的是用losetup命令，但是出现的问题是，losetup是可以把镜像文件挂载为/dev/loop0，但是里面的分区一直在/dev中找不到。后来搜索 **如何挂载虚拟机镜像** 这个关键词，才找到了这条命令。这条命令执行后，会有以下设备出现

* /dev/loop0
* /dev/mapper/loop0p1
* /dev/mapper/loop0p2

####第四步 格式化，挂载，并写入文件

    mkfs.vfat /dev/mapper/loop0p1
    mkdir /mnt/boot
    mount /dev/mapper/loop0p1 /mnt/boot
    mkfs.ext4 /dev/mapper/loop0p2
    mkdir /mnt/root
    mount /dev/mapper/loop0p2 /mnt/root

    #去官网下载ARMv6 Raspberry Pi这个包
    #下载后的文件是ArchLinuxARM-rpi-latest.tar.gz

    #bsdtar 可能需要自己安装，yum install bsdtar即可
    bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C /mnt/root/

    #强制缓存写入
    sync

    #引导文件
    mv /mnt/root/boot/* /mnt/boot/

    #卸载
    umount /mnt/boot/ /mnt/root/
    kpartx -d new.img

这样一个新镜像就做好了，把new.img从虚拟机传出来，用dd直接写入SD卡，成功启动树莓派！

附带两个国内的ArchLinux ARM 的源：

    #中科大
    Server = http://mirrors.ustc.edu.cn/archlinuxarm/$arch/$repo
    #清华
    Server = http://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/$arch/$repo

参考文章：[Mounting a KVM disk image without KVM](http://dgc.uchicago.edu/20130530/mounting-a-kvm-disk-image-without-kvm/)

**码字不易，见好就分享~**
