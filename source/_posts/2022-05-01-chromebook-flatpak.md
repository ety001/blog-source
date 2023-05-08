---
author: ety001
date: '2022-05-01 08:24:49+00:00'
layout: post
title: Chromebook 使用 flatpak 来管理应用
tags:
  - 经验
  - chromebook
---

之前使用 Chromebook 内置的 Linux 容器，一直都是用系统自带的 apt 包管理程序，但是很多常用的社交软件都不在 apt 包管理中，比如 slack, telegram, discord 等等。

每次都要挨个网站去下载 deb 安装包，然后手动一个个安装，非常费劲。

这次借着五一假期对我的 Pixelbook 进行下优化整理，用 flatpak 来作为主要的包管理工具。

之所以选择 flatpak 主要是这个货官方页面显示支持 ChromeOS，那么意味着大概率是有针对 ChromeOS 进行过优化的。

![image](https://user-images.githubusercontent.com/801928/166149267-78c52d52-d4f0-4ea0-97d2-bbc409dda11a.png)

安装 flatpak 非常简单，按照官方的教程，逐步操作即可完成，[https://flatpak.org/setup/Chrome%20OS](https://flatpak.org/setup/Chrome%20OS)。

针对国内用户，唯一需要了解的就是如何给使用 flatpak 安装的应用，增加代理配置。

网上给出的方案，我没有尝试成功，不过这里还是要记录下。

思路就是进入 flatpak 安装的应用的沙盒环境，然后使用 `gsettings` 来设置 `dconf` 数据库。

有些应用是直接从 `dconf` 获取相关配置的，具体命令如下：

```
#进入容器
flatpak run --command=sh com.google.Chrome

#设置代理为手动模式
gsettings set org.gnome.system.proxy mode 'manual'

#设置 HTTP 代理
gsettings set org.gnome.system.proxy.http host localhost
gsettings set org.gnome.system.proxy.http port 3128 

#设置 HTTPS 代理
gsettings set org.gnome.system.proxy.https host localhost
gsettings set org.gnome.system.proxy.https port 3128 

#设置 Socks 代理
gsettings set org.gnome.system.proxy.socks host localhost
gsettings set org.gnome.system.proxy.socks port 1080
```

我没有测试成功这种方法。

我的方法是，修改 `~/.local/share/flatpak/exports/share/applications/` 目录下面相关的 `*.desktop` 文件，如下：

```
[Desktop Entry]
Name=Discord
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
GenericName=Internet Messenger
Exec=env http_proxy=http://127.0.0.1:8001 https_proxy=http://127.0.0.1:8001 sommelier -X --scale=0.35 /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=discord com.discordapp.Discord
Icon=com.discordapp.Discord
Type=Application
Categories=Network;InstantMessaging;
Path=/usr/bin
X-Flatpak-Tags=proprietary;
X-Flatpak=com.discordapp.Discord
```

可以看到我在 Exec 中增加了两条 env 指令来配置容器启动时的环境变量。

除了代理外，还有个问题就是 Linux 容器下打开的应用的鼠标指针很小，找到的解决方案是使用 `sommelier` 命令指定 scale 值。

在上面的代码中能看到，在调用 `/usr/bin/flatpak` 之前，先调用了 `sommelier -X --scale=0.35`。

具体的 scale 值需要看你的具体的环境来调整。

这下安装这些社交软件，就可以一键完成了。赞！
