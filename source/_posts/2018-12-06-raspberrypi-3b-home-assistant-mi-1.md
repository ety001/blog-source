---
author: ety001
layout: post
title: 在树莓派3B上搭建Hass.io并接入米家和iOS（一）
tags:
- HomeAssistant
- 家庭智能
- 米家
- 树莓派
---

本来今天应该是写（二）的，但是昨晚配置的过程中发现了很多问题，比如声音、蓝牙之类的配置，以及最关键的是发现原来 **Hass.io** 已经不被官方推荐了，现在官方推荐他们自己做的 **HassOS**，WTF，这都是啥跟啥？！所以今天就是把昨天写的(一)推翻掉，重新写。

先来说说刚才提到的 **Hass.io** 和 **HassOS** 。

按照目前我的理解，这个项目的演化历程是这样的，最早的 **Home Assistant** 是一堆脚本构成的，系统是基于 **Respbian** 的，所以起名叫做 **Hassbian**，之后基于 **ResinOS**(一个面向嵌入式系统的docker系统平台)，把整个的核心代码封装进了两个镜像中，一个是 **[homeassistant/raspberrypi3-homeassistant](https://hub.docker.com/r/homeassistant/raspberrypi3-homeassistant/)**，一个是 **[homeassistant/armhf-hassio-supervisor]()**，其余的插件都各自独立成为一个镜像，这样整个系统运行起来就是一个 **ResinOS** 加上一堆容器，对于整体的稳定性和可维护性提升了不少，这也就是 **Hass.io**。再之后不知道什么原因，又基于 **buildroot** 系统（另外一个面向嵌入式的系统平台）做了 **HassOS**，这款比起上一款来说，感觉加入了一些新的驱动，比如声卡和蓝牙，另外就是宿主机做的更加的封闭了，可能是处于安全考虑，也可能是处于以后的商业考虑。

由于不想覆盖掉昨天的那篇，所以开始这篇作为第一篇，然后开始我们的重做系统之旅吧。。。。。

目前 **HassOS** 的稳定版本是 *1.13*，最新版本是 *2.3*，这个在 **HassOS** 项目的 **Release** 页面可以看到，[https://github.com/home-assistant/hassos/releases](https://github.com/home-assistant/hassos/releases) 。我选择了 *2.3* 这个版本，由于我是树莓派3B，所以下载了 **hassos_rpi3-2.3.img.gz** 这个包（这里之所以不下载64位的是因为树莓派官方推出64位的系统时间也不长，稳定性有待观察）。

下载后解压得到 **img** 文件，依旧用 **etcher** 来写入到 **TF** 卡中。

这里需要注意，如果你是 **Mac** 电脑，那么写完后，会提示 **TF** 卡无法识别，你直接推出就好。这是因为 **HassOS** 使用的 **GPT** 分区格式，而 **Mac** 默认不支持这个格式。

那么这里就有意思了，往常都是 **boot** 分区是 **FAT** 格式，然后挂载，放入各种位置文件，比如wifi联网的配置，然后把卡插回树莓派，启动就能用了，但现在 **TF** 卡的 **boot** 分区无法挂载，这咋整？

官方给出了方案：[https://github.com/home-assistant/hassos/blob/dev/Documentation/configuration.md](https://github.com/home-assistant/hassos/blob/dev/Documentation/configuration.md) ，思路就是再找一个U盘，格式化成 **FAT32** / **EXT4** / **NTFS** 任意格式，格式化的时候把U盘命名为 **CONFIG**（全大写）。

![](/upload/20181206/XERIGA49irRbHDpStCCTkJWuj7mz4xwymhv0C86N.png)

之后需要加入的配置文件，按照文档要求的格式放在U盘根目录下即可。启动树莓派的时候，先把U盘插好，系统会自动读取U盘的配置文件并生效。

![](/upload/20181206/gsOSk9x1aXds3uLtOMtFq4UWzQetIWokbJaGKqDR.png)

**另外注意就是配置network的时候，文件名必须是my-network。**

**除了网络配置以外，timesyncd.conf也要配置，否则系统启动起来时间不对，然后更新就会卡住，因为更新访问的是 HTTPS 加密链接，时间不对，签名就有问题，进而就无法访问更新镜像的链接（下面的截图就是这个坑了）。timesyncd.conf中的NTP服务器网上找下亚洲区的就好。**

![](/upload/20181206/WlBcqLD97OTqxEtLyMgXmxSSAiDUgrQ1Clkn8tMy.png)

**另外建议把 authorized_keys 也配置了吧，这样可以远程直接SSH到宿主机。authorized_keys 文件里的内容其实就是你电脑 ~/.ssh/id_rsa.pub 文件的内容，如果没有这个目录，就执行下 ssh-keygen 生成下。**

**还有就是一定记住，初始化结束后，要在UI界面上把U盘的配置再导入一次，这个之后会再提到，切记切记啊！！！**

### 以上满满的都是坑！

所有工作做完，启动树莓派，来看看显示器最后输出的内容，**默认登陆用户是root，不需要密码。**

![](/upload/20181206/kbLzSsoKiFIbEVxjphTruFHG3DtrdXtuCltbDFTa.png)

恩，你没有看错，登陆后是官方实现的一个 **cli**，用于便捷管理各种服务，屏蔽掉操作系统的存在。虽然现在允许你使用 **login** 命令进入宿主机，但是我觉得早晚会屏蔽掉这个命令，做的跟路由器似的。

这时候，你执行 **login** 进入宿主机，然后执行 `docker ps`，看看是不是一个 **supervisor** 的容器，一个 **homeassistant/raspberrypi3-homeassistant** 生成的容器。

如果没问题，那么在浏览器里访问 **http://hassio.local:8123** 就能看到创建新用户的界面了（如果你路由器不支持mDNS，那么就只能用 **http://树莓派IP:8123** 的形式访问了。

![](/upload/20181206/BUHkhtk3LUHmQKwEy28ImqELyIG4IjBnKLbDjYCA.png)

登陆之后，就能看到主界面了。去左边栏 **Hass.io** 中，选择 **ADD-ON STORE**，然后找到 **SSH & Web Terminal**，点进去安装，如下图

![](/upload/20181206/pIBImO28p50Bsk4jd0f79NhKAXYhLTVw0pET2bm0.png)

这个插件其实是让你 **SSH** 登陆进一个容器，然后把一些配置文件从宿主机映射进容器，这样相对安全一些。

安装完，在下面的配置中，把你的登陆用户名和密码加入进去，另外配置下 **Web Terminal** 的证书，证书是放在 **/root/ssl** 目录下的。你可以先关闭 **Web Terminal**，启动 **SSH** 成功后，用 **SCP** 把证书传上去，或者去插件中心安装 **Samba Share** 插件，用共享的方法传上去。

最关键的一步来了，在 **Hass.io** 中，选择 **SYSTEM** ，点击 **IMPORT FROM USB** 完成配置写入。

![](/upload/20181206/eBX8GzKodKV7FRzFIX9Jl9w8PjLSkNuwDF0BD53D.png)

### OK，这一篇就先到这里，下一篇真的要讲讲其他的配置了。