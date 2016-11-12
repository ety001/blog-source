---
author: ety001
comments: true
date: 2013-04-07 13:51:46+00:00
layout: post
slug: kickstart-params-introduction
title: Kickstart文件中的主要项目及参数介绍
wordpress_id: 2350
tags:
- Server&OS
---

Kickstart文件中的主要项目及参数介绍：

每个项目都由关键字来识别；关键字可跟一个或多个参数；如果某选项后面跟随了一个等号（=），它后面就必须指定一个值。

install   (可选)
明确指定系统次次进行的是全新安装系统；是默认项；

cdrom  （可选）
以本地CD-ROM为源安装系统；

harddrive  (可选)
以硬盘分区中包含的镜像为源（安装树）安装新系统；当以该种方式安装系统时，即使指定clearpart --all项，源所在分区也不会被重新抹去；
--partition=    指定分区
--dir=        指定包含镜像的目录
例：
harddrive  --partition=/dev/sdb2  --dir=/data/iso
<!-- more -->
nfs   (可选)
指定从NFS服务器上获取安装树；
--server=    指定NFS服务器，主机名称或IP
--dir=        包含安装树的目录
--opts=        可以指定挂载NFS的目录时的挂载选项
例：
nfs  --server=192.168.1.254  --dir=/data/iso

url   (可选)
指定通过FTP或HTTP从网络获取安装树；
--url    指定资源位置
例：
url  --url  ftp://<username>:<password>@install.example.com/iso
url  --url  http://install.example.com/iso

bootloader （必需）
设定boot loader安装选项；
--append=        可以指定内核参数
--driveorder=    设定设备BIOS中的开机设备启动顺序
--location=        设定引导记录的位置； mbr：默认值；partition：将boot loader安装于包含kernel的分区超级快中；none：不安装boot loder。
示例：
bootloader  --location=mbr  --append=“rhgb quiet” --driveorder=sda,sdb

clearpart （可选）
在建立新分区前清空系统上原有的分区表，默认不删除分区；
--all      擦除系统上原有所有分区；
--drives    删除指定驱动器上的分区
--initlabel    初始化磁盘卷标为系统架构的默认卷标
--linux        擦除所有的linux分区
--none（default）不移除任何分区
例：
clearpart  --drives=hda,hdb --all  --initlabel

zerombr  （可选）
清除mbr信息，会同时清空系统用原有分区表

drivedisk （可选）
如果使用特殊存储方式时，需要指定驱动程序盘位置以便加载存储驱动；
1.  将驱动盘拷贝到本地硬盘某分区根目录：
drivedisk <partition> [ --type=<fstype> ]
2.  也可以指定一个网络位置加载驱动程序盘
drivedisk  --source=ftp://path/to/drive.img
drivedisk  --source=http://path/to/drive.img
drivedisk  --source=nfs:host://path/to/drive.img

firewall （可选）
配置系统防火墙选项；
firewall –enable|--disable  [ --trust ] <device> [ --port= ]
--enable        拒绝外部发起的任何主动连接；
--disable        不配置任何iptables防御规则；
--trust        指定完全信任网卡设备；
--port        使用port:protocol格式指定可以通过防火墙的服务；
示例：
firewall --enable --trust eth0  --trust eth1  --port=80:tcp

selinux （可选）
设置系统selinux状态；默认为启用并处于enforcing模式；
selinux [ --disabled|–enforcing|--premissive ]

reboot （可选）
在系统成功安装完成后默认自动重启系统（kickstart方法时）；在收到你敢装系统完成后，会提示按任意键进行重启；
在本文件中没有明确指明其他方法时就默认完成方式为reboot；
使用 reboot 选项可能会导致安装的死循环，这依赖于安装介质和方法。需要特别注意；

halt  （可选）
在系统成功安装完成后关机；默认为reboot；
其他选项还有shutdown、poweroff，需要使用请自行参考官方文档。

graphical （可选）
默认值，在图形模式下进行kickstart方式安装；

text （可选）
以文本方式进行kickstart安装；默认为图形界面

key  (可选)
设置一个安装码(installration number)，用于获取redhat官方的支持服务；
--skip    跳过key设置，不进行设置；如果不设置可能跳转到交互模式让用户选取动作；

keyboard （必需）
设置键盘类型；一般设置为us；

lang （必需）
设置安装过程使用的语言及系统的缺省语言；文本模式安装时可能不支持某些语言（中、韩...），所以可能仍以默认的英文方式安装；默认en_us，装中文时，需要后期%packages部分装上中文支持组件；
例：
lang en_US

timezone （可选）
设置系统的时区；
timezone  [ --utc ]  <timezone>
例：
timezone  --utc  Asia/Shanghai

auth/authconfig  (必需)
设置系统的认证方式；默认为加密但不隐藏(shadow)；
--enablemd5    使用MD5加密方式
--useshadow或—enableshadow    使用隐藏密码；
--enablenis=     使用NIS认证方式
--nisdomain=    NIS域
--nisserver=       NIS服务器
还可以设置LDAP、SMB及Kerberos 5认证方式，详细请参考官方文档；
例：
authconfig  --useshadow  --enablemd5

rootpw （必需）
设置系统root账号的密码；
rootpw [ --iscrypted ]  <passwd>
--iscrypted    表示设置的密码为加密过的串；
例：
rootpw  pa4word
rootpw --iscrypted  $1$RPYyxobb$/LtxMNLJC7euEARg2Vu2s1

network （可选）
配置网络信息；在网络安装（NFS/HTTP/FTP）时必须指定；
--bootproto=dhcp|bootp|static    指定ip获取方式，默认为dhcp/bootp;
--device=    设置安装时激活来进行系统安装的网卡设备；该参数只在kickstart文件为本地文件时有效；若kickstart配置文件在网络上，安装程序会先初始化网卡然后去寻找kickstart文件；
--ip=    ip设置
--gateway=   网关
--nameserver=  DNS设置
--nodns         不设置DNS
--netmask=   掩码
--hostname= 设置安装后主机名称
--onboot=    设置是否在系统启动时激活网卡
--class=        设置DHCP的class值
--noipv4        禁用该设备的ipv4功能
--noipv6        禁用该设备的ipv6功能
如将网络模式设置为静态模式，则必须在一行内写上ip，netmask、dns、gateway等信息；
例：
network –bootproto=static –ip=1.1.1.1 --metmask=255.0.0.0 --gateway=1.1.1.254 --nameserver=1.1.1.2
netmask --bootproto=dhcp  --device=eth0

skipx （可选）
如果该项存在，就不对系统的X进行设置；

xconfig （可选）
配置X window ；如果不给出选项，在安装过程中需要手动调整设置；当然不安装X时不应该添加该项；
--driver            为显卡设置X驱动
--videoram=    设置显卡的RAM大小
--defaultdesktop=    设置GNOME/KDE作为默认桌面；假定这两个桌面环境在%packages例已经安装
--startxonboot   使用图形界面登录系统
--resolution=     设置图形界面的分辨率；可用值有640*480、800*600、1024*768等；确保设置指适合于显示卡及显示器；
--depth=           设置显示色深；可用值有8/16/24/32；确保设置值适合于显示设备；
例:
xconfig    --startxonboot  --resolution=800*600 --depth=16

services （可选）
设置禁用或允许列出的服务；
--disabled 设置服务为禁用
--enabled  启动服务
例：
services --disabled autid,cups,smartd,nfslock  服务之间用逗号隔开，不能有空格

iscsi（可选）
指定额外的ISCSI设备；
issci --ipaddr= ipaddr  [options].
--target
--port=
--user=
--password=

part/partition  （install模式必须）
建立新分区；
part  <mntpoint>|swap|pv.id|rdid.id  options
mntpoint:挂载点，是在创建普通分区时指定新分区挂载位置的项；挂载点需要格式正确
swap： 创建swap分区；
raid.id:  表示创建的分区类型为raid型；必须用id号进行唯一区别；
pv.id：  表示所创建的分区类型为LVM型；必须用唯一id号进行区别；
--size=  设置分区的最小值，默认单位为M，但是不能写单位；
--grow  让分区自动增长利用可用的磁盘空间，或是增长到设置的maxsize值；
--maxsize 设置分区自动增长(grow)时的最大容量值，以M为单位，但不能写单位；
--onpart=/--usepart=     设置使用原有的分区；
--noformat    设置不格式化指定的分区，在跟—onpart一同使用时，可以避免删除原有分区上的数据，在新安装的系统中保留使用数据；
--asprimary    强制制定该分区为主分区；若指定失败，分区会失败，导致安装停止；
--fstype=    新增普通分区时指定分区的类型，可以为ext2、ext3、ext4、swap、vfat及hfs；
--ondisk=/--ondrive=     设定该分区创建在一个具体的磁盘上；
--start   指定分区以磁盘上那个磁道开始；需要跟--ondisk参数一块使用；
--end    指定分区以磁盘上那个磁道结束；需要跟上述两个参数一起使用；
--recommended：让系统自行决定分区的大小；在创建swap分区时，若RAM<2G，则分区大小为2*RAM；若RAM>=2G时，分区大小为RAM+2G；
--bytes-pre-inode=    指定分区格式化时inode的大小；默认值为4096
--fsoptions=    指定创建fstab文件时该分区挂载参数项；
例：
part  /boot  --fstype=“ext3” --size=100
part  swap  --fstype=“swap” –size=512
part  /  --bytes-pre-inode=4096  --fstype=“ext4”--size=10000
part  /data    --onpart=/dev/sdb1  --noformat
part  raid.100  --size=2000
part  pv.100     --size=1000

raid  (可选)
设置RAID。
raid 挂载点  --level=<level>  --device=<mddevices_name>  <raid组成分区>
挂载点：    选取根/时，注意尽量避免/boot在RAID内，除非为RAID1；
--level=     设置RAID级别
--device=  RAID设备名称，如md0，md1...
--byte-pre-inode=    设置该RAID分区上inode大小；若分区文件系统类型不支持该参数，会静默忽略参数；
--spares=  设置RAID的热备盘
--fstype=  设置文件系统类型
--fsoptions=  设置挂载该文件系统时自定义的一些参数，参数写入fstab文件；
--useexisting  使用现有的RAID设备并且重新格式化原设备
--noformat     在使用现有的RAID设备时不格式化原有RAID设备
例：完整创建一个RAID1设备示例；
part  raid.10  --size=1000  --ondisk=/dev/sdb
part  raid.11  --size=1000  --ondisk=/dev/sdc
raid  /data  --level=1  --device=md0  raid.10  raid.11

volgroup  (可选)
创建一个LVM卷组VG；
volgroup  vg_name  partition  [options]
--useexiting   使用现有的VG并且重新格式化
--noformat    使用现有的VG时不做格式化
--pesize          设置PE（physical extents）块大小
例：
part pv.11  --size=2000
volgroup  myvg  pv.11

logvol  (可选)
创建一个LVM逻辑卷LV；
logvel  mnt_point  --vgname=vg_name  --size=lv_size  --name=lv_name  [options]
--useexiting  使用现有的LV并且重新格式化
--noformat   使用现有的LV时不做格式化
--fstype=      指定RAID分区类型
--fsoptions=  设置挂载该文件系统时自定义的一些参数，参数写入fstab文件；
--byte-pre-inode=    设置该RAID分区上inode大小；
--precent=    设定LV大小为VG可用空间的比例；
例：
part pv.20  --size=5000
volgroup  mvvg  pv.20
logvol    /data  --vgname=myvg  --size=3000  --name=mydata





原文地址：[**http://www.qianshoublog.com/post/7528.html**](http://www.qianshoublog.com/post/7528.html)
本文标题：[**ks.cfg 文件，参数讲解**](http://www.qianshoublog.com/post/7528.html)
