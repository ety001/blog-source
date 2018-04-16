---
author: ety001
layout: post
title: 解决aria2c无法开机自启动问题
tags:
- Server&OS
---

好的吧，终于搞定了aria2c的开机自启动问题。No zuo no die，离开计算所后，好像很久没有这么折腾了，
一个配置的问题引发的一系列的问题。

简单说下我的环境是树莓派 + Archlinux，看着 ArchWiki 上面关于 aria2c 的[相关页面](https://wiki.archlinux.org/index.php/Aria2#Start_aria2c_on_system_boot)，
很快就安装配置ok了，不过，重启后，发现 aria2c 根本就没有启动起来。报错信息如下：

```
Mar 31 22:31:40 alarmpi aria2c[150]: 03/31 22:31:40 [ERROR] IPv4 RPC: failed to bind TCP port 6800
Mar 31 22:31:40 alarmpi aria2c[150]: Exception: [SocketCore.cc:293] errorCode=1 Failed to bind a socket, cause: Name or service not known
```

绑定失败？怎么破？

再看下 Wiki 上 /etc/systemd/system/aria2c.service 这个配置文件，貌似没啥问题，然后又手动启动了下，也失败了。
执行 systemctl status aria2c 发现程序成功返回0，systemctl显示也是正在执行，但是ps一下，没有aria2c的进程。

见鬼了！

继续看 wiki ，发现里面说到

```
Ensure your config is set to deamonize (use daemon=true).
```

我的配置文件没问题，已经加了daemon=true。。。恍惚了好久，在wiki上看到了[systemd的页面](https://wiki.archlinux.org/index.php/Systemd#Service_types)，看到里面有这么一句话，

```
Type=forking: systemd considers the service started up once the process forks and the parent has exited. For classic daemons use this type unless you know that it is not necessary.
```

然后我在原来的wiki给出的那个配置的基础上加上了一行 Type=forking（也就是你们现在在wiki中看到的那样，我已经提交修改到wiki了）。

添加好以后，手动启动 systemctl start aria2c 成功！赶紧重启试试。结果还是不行，依旧报错，还是绑定的问题。

后来，就又继续看systemd的配置，尝试添加wants和requires之类的配置，但是都不管用，不过看了这么一段话，在[这个页面](https://wiki.archlinux.org/index.php/Systemd#Service_types)，

```
The most typical case is that the unit A requires the unit B to be running before A is started. In that case add Requires=B and After=B to the [Unit] section of A. If the dependency is optional, add Wants=B and After=B instead. Note that Wants= and Requires= do not imply After=, meaning that if After= is not specified, the two units will be started in parallel.
```

好吧，wiki给出的那个配置还不是很完善，我又加上了一行，最终配置如下

```
file path:
/etc/systemd/system/aria2c.service

file content:
[Unit]
Description=Aria2c download manager
Requires=network.target
After=network.target

[Service]
User=aria2
Type=forking
ExecStart=/usr/bin/aria2c --conf-path=/home/aria2/.aria2/aria2.daemon

[Install]
WantedBy=multi-user.target
```

再次重启试试，还是不行。。。继续看配置，发现 systemd 还可以配置 timer，我想，既然开机启动不成功，
而开机后手动启动可以，就证明有什么依赖的程序没有启动，系统就启动 aria2c 了，那我延时执行不久可以了么。
于是看文档学习下，写了个针对 aria2c 的 timer，代码如下：

```
file path:
/etc/systemd/system/aria2c.timer

file content:
[Unit]
Description=Run on boot

[Timer]
#10 seconds
OnBootSec=10

[Install]
WantedBy=timers.target
```

重启成功。这里我忽略了我测试OnBootSec的步骤，其实刚开始是1，结果有时候能启动，有时候启动不起来，才改成10的。

本来以为这就告一段落了，但是突然不知道怎么想的，脑子里闪现静态ip这个词，于是，也就顺带看看systemd的网络配置怎么搞的。
配置好静态ip后，就手贱的把这个 timer 关掉了，然后奇迹发生，aria2c 启动成功！好的吧，原来是这个地方的坑啊。。

收拾下战场，完善下 ArchWiki 的 Start aria2c on system boot 这一节的内容，顺带着去ArchBBS上把一个帖子也回复了
（我放狗搜遍网络，就这一个哥们跟我遇到了同样的问题，却没有被解决）。

就在我快要写完这篇博文的时候，收到了 ArchWiki 管理员的回复，关于daemon=true与Type=forking的这个修改接受了，
不过，对于failed to bind errors则没有接受，可能再接下来的版本会修复这个bug。（PS：庆幸我写的英文，管理员看懂了。）

最后放出我的 aria2 的网页管理界面，终于完工了，下载个Glee 3D Concert测试下：

![aria2](/upload/20150401/20150401-1.png)

