---
author: ety001
comments: true
layout: post
title: 在 Chromebook Linux 中安装必备的软件
tags:
- Server&OS
---

ChromeOS 内置 Debian buster 的 Linux 系统

1. 修改国内源, `/etc/apt/sources.list`
```
deb http://mirrors.163.com/debian/ buster main non-free contrib
deb http://mirrors.163.com/debian/ buster-updates main non-free contrib
deb http://mirrors.163.com/debian/ buster-backports main non-free contrib
deb http://mirrors.163.com/debian-security/ buster/updates main non-free contrib

deb-src http://mirrors.163.com/debian/ buster main non-free contrib
deb-src http://mirrors.163.com/debian/ buster-updates main non-free contrib
deb-src http://mirrors.163.com/debian/ buster-backports main non-free contrib
deb-src http://mirrors.163.com/debian-security/ buster/updates main non-free contrib
```

2. 安装 Docker
```
sudo apt-get update -y
sudo apt-get install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo gpasswd -a ety001 docker
```

3. 修改 Docker 日志量

```
# /etc/docker/daemon.json
{
  "log-driver":"json-file",
  "log-opts": {"max-size":"5m", "max-file":"3"}
}
```

```
sudo systemctl restart docker
sudo systemctl enable docker
```

4. 修改 Linux 容器为固定IP

`/etc/network/interfaces` 文件

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
      address 100.115.92.202/28
      gateway 100.115.92.193

dns-nameservers 8.8.8.8 114.114.114.114
```

重启网络 `sudo systemctl restart networking`

5. 修改 sudo 不需要密码

```
%sudo ALL=(ALL) NOPASSWD: ALL
```

6. 设置当前用户密码

```
sudo passwd ety001
```

7. 配置 Chrome 各个插件

8. 配置 ssh

9. 从 github 下载私有配置，进行自定义设置

10. 安装 nvm

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
```

11. 下载 vscode

[https://code.visualstudio.com](https://code.visualstudio.com)

12. 下载 vnc viewer

[https://www.realvnc.com/en/connect/download/viewer](https://www.realvnc.com/en/connect/download/viewer)

13. 安装 Linux 搜狗拼音

[https://pinyin.sogou.com/linux/?r=pinyin](https://pinyin.sogou.com/linux/?r=pinyin)

安装完，在家目录创建 `~/.pam_environment`

```
GTK_IM_MODULE DEFAULT=fcitx
QT_IM_MODULE  DEFAULT=fcitx
XMODIFIERS    DEFAULT=\@im=fcitx
```

14. 安装 LinuxQQ

[https://im.qq.com/linuxqq/download.html](https://im.qq.com/linuxqq/download.html)

15. 安装 Linux QQ音乐

[https://y.qq.com/download/download.html](https://y.qq.com/download/download.html)

16. 安装 Linux 网易云音乐

[https://music.163.com/#/download](https://music.163.com/#/download)

17. 安装 Slack

[https://slack.com/intl/zh-cn/downloads/linux](https://slack.com/intl/zh-cn/downloads/linux)
