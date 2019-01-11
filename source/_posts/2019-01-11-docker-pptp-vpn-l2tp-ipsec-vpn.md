---
author: ety001
layout: post
title: 用 Docker 快速部署 PPTP VPN 和 L2TP + IPSEC VPN
tags:
- Docker
- Server&OS
---

虽然平时主要用 `Shadowsocks`，但是架不住有时候没法安装 `Shadowsocks` 的客户端，那么就还是需要 `PPTP VPN` 或者 `L2TP VPN`。

最早的时候，是使用的各种一键安装脚本，但是由于系统版本差异，每次需要安装的时候，都要现找可用的一键脚本，太费劲了。于是从网上找了别人封装好的 `Docker` 镜像，这篇文章总结下，基本上就是一条语句就搞定了。

# PPTP VPN

使用的镜像是 `mobtitude/vpn-pptp`，首先需要把用户名和密码配置一下，打开 `/etc/ppp/chap-secrets`，

```
# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
ety001         *          123456              *
```
上面的就是配置了一个用户名 `ety001` 和 密码 `123456` 的用户，然后执行下面的命令就可以了，

```
docker run -d --name pptp --restart always  --privileged -p 1723:1723 -v /etc/ppp/chap-secrets:/etc/ppp/chap-secrets mobtitude/vpn-pptp
```
最后检查下 `tcp 1723` 端口在防火墙上是否打开就可以了。

# L2TP + IPSEC VPN

使用的镜像是 `hwdsl2/ipsec-vpn-server`，需要先配置下用户名、密码和PSK，新建一个环境变量的文件 `/etc/l2tp-env`，内容如下

```
VPN_IPSEC_PSK=abcdef
VPN_USER=ety001
VPN_PASSWORD=123456
```
上面的就是配置了一个用户名 `ety001`，密码 `123456`，PSK 为 `abcdef` 的用户，然后执行下面的命令就可以了，

```
docker run --name ipsec-vpn-server --env-file /etc/l2tp-env --restart=always -p 500:500/udp -p 4500:4500/udp -v /lib/modules:/lib/modules:ro -d --privileged hwdsl2/ipsec-vpn-server
```
最后检查下 `udp 500` 和 `udp 4500` 端口在防火墙上是否打开就可以了。

# Shadowsocks

最后再附带上一个一句话部署 `Shadowsocks` 的命令，先创建个配置文件 `/etc/shadowsocks.json`，内容如下
```
{
    "server":"0.0.0.0",
    "server_port": 10000,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"ety001",
    "timeout":60,
    "method":"aes-256-cfb"
}
```
然后执行下面的命令部署
```
$ docker run -d -p 10000:10000 -v /etc/shadowsocks.json:/conf/shadowsocks.json --restart=always --name ss ety001/ss
```