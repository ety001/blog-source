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

最近想要在树莓派上折腾下 Home Assistant。

Home Assistant 于 2017年7月26日发布的 Hass.io 集成系统，全可视化安装配置，基于 Docker 和  ResinOS。

Docker 的引入使得 Hass.io 管理功能插件就像你在手机上安装 App 一样简单（事实上 iOS 的底层确实采用了类似机制），再不用通过命令行和代码来管理你的 Home Assistant。同时，通过 Docker 来封装插件，使得插件的稳定性得到了极大提高，用户能够把精力集中在个性化定制 Home Assistant 及自动化上来。

可以预见 Hass.io 是 Home Assistant 的发展方向，如果说它有什么缺点的话，那么也在于它的封闭性上。

## 下载针对树莓派3的 hass.io 镜像

https://github.com/home-assistant/hassio-build/releases/

![](/upload/20181205/G5b3TG80id57xV2UGde9TLHsk86lflWLBkB7HYIj.png)

## 使用 etcher 写入镜像到 TF 卡

![](/upload/20181205/1IYlHON1Ps6nYgYm2MAYdfN18NkxN2nFkCZPlUKU.png)

## 配置Wifi

如果树莓派采用 WiFi 连接，在烧录完成后使用文本编译器打开 TF 卡目录下 system-connections/resin-sample 文件，修改填写你的 WiFi 信息：

```
[connection]
id=resin-wifi
type=wifi

[wifi]
hidden=true
mode=infrastructure
ssid=你的 WiFi SSID

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto

[wifi-security]
auth-alg=open
key-mgmt=wpa-psk
psk=你的 WiFi 密码
```

## 启动初始化

将 TF 卡插入树莓派中，上电，几分钟后，在浏览器（推荐 Chrome）地址栏输入 http://hassio.local:8123 即可看到如下界面了

![](/upload/20181205/me4NsNkXIpyiyk31ejnLfkkiWu1UjvCgPUrCpyZQ.png)

由于没有国内的镜像站，所以且等着就好了，需要很久，除非你在路由上开了科学上网。

完成后，大致是这样

![](/upload/20181205/kAwZf0AZEWiy8hGjEn3TNgCcdpKDADoK9bTm6WNU.png)

## 接下来

在下一篇将会继续安装相关的插件和配置，敬请期待。