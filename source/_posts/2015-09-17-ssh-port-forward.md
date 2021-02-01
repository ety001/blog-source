---
author: ety001
title: ssh端口转发
layout: post
tags:
- Server&OS
---
## 基本参数：

    * -L [bind_address:]port:host:hostport
    * -L [bind_address:]port:remote_socket
    * -L local_socket:host:hostport
    * -L local_socket:remote_socket
    * -R [bind_address:]port:host:hostport
    * -R [bind_address:]port:local_socket
    * -R remote_socket:host:hostport
    * -R remote_socket:local_socket
    * -C 压缩
    * -g global forward 全局转发，否则只能绑定到127.0.0.1
    * -R 远程转发
    * -L 本地转发
    * -f 后台认证用户/密码，通常和-N连用，不用登录到远程主机
    * -N 不执行脚本或命令，通常与-f连用。

## 前置配置

如果用的是 *openssh* ，先设置 **远端服务器** 的 *GatewayPorts* 为 *yes*，否则 **远程映射** 时，
在远端无法绑定到 *0.0.0.0* 。

## 本地映射

通过参数可以看到，除了端口外，还支持socket文件映射，所以有四种方式。

理解起来，就是把远程的端口映射到本地，我们的访问是从本地的端口开始的，最终目的地是远程端口。

解决的问题是，远程主机的防火墙只开放了 `22` 端口，而我们要访问远程主机的其他端口，比如 `5900`。

参考命令:

```
# 192.168.1.1 是远程主机的内网IP
# 1.1.1.1 是远程主机的公网IP
ssh -CfNgL 15900:192.168.1.1:5900 root@1.1.1.1
```

## 远程映射

通过参数可以看到，除了端口外，还支持socket文件映射，所以也有四种方式。

理解起来，就是把本地的端口映射到远端，我们的访问是从远端的端口开始的，最终目的地是本地端口。

解决的问题是，本地主机没有公网IP，而我们需要从公网访问到本地的某个服务。

参考命令:

```
# 192.168.1.1 是本地主机的内网IP
# 1.1.1.1 是远程主机的公网IP
# 访问远程主机的12222端口相当于直接访问了本地22
ssh -CfNgR 12222:192.168.1.1:22 root@1.1.1.1
```

## 其他

如果你的远程服务器的 `ssh` 端口不是默认的　`22`，比如是　`2233`，　
那么直接加上　`-p 2233` 参数即可。
