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

4. 下载 vscode

[https://code.visualstudio.com](https://code.visualstudio.com)

5. 下载 vnc viewer

[https://www.realvnc.com/en/connect/download/viewer](https://www.realvnc.com/en/connect/download/viewer)

6. 配置 Chrome 各个插件

7. 配置 ssh

8. 从 github 下载私有配置，进行自定义设置

9. 安装 Linux 搜狗拼音

[https://pinyin.sogou.com/linux/?r=pinyin](https://pinyin.sogou.com/linux/?r=pinyin)

10. 安装 LinuxQQ

[https://im.qq.com/linuxqq/download.html](https://im.qq.com/linuxqq/download.html)

11. 安装 Linux QQ音乐

[https://y.qq.com/download/download.html](https://y.qq.com/download/download.html)

12. 安装 Linux 网易云音乐

[https://music.163.com/#/download](https://music.163.com/#/download)
