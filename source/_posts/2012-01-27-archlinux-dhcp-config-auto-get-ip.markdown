---
author: ety001
comments: true
date: 2012-01-27 13:05:18+00:00
layout: post
slug: archlinux-dhcp-config-auto-get-ip
title: ArchLinux配置DHCP自动获取IP
wordpress_id: 1914
tags:
- Server&OS
---

捣鼓了好几个小时了，终于知道怎么配置DHCP自动获取IP了，还是得上ArchLinux的官方Wiki才是王道啊。。。


### DHCP （自动获取） IP

在这种情况下，你需要安装 dhcpcd 包（绝大多数情况下都是默认安装好的）。这样编辑 `/etc/rc.conf` ：

```
    eth0="dhcp"
    INTERFACES=(eth0)
    ROUTES=(!gateway)
```

貌似2012年9月份那个包以后，启动dhcp的方法有变化，看这里：[https://wiki.archlinux.org/index.php/Configuring_Network_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.90.AF.E5.8A.A8.E6.97.B6.E8.BF.90.E8.A1.8C_DHCP](https://wiki.archlinux.org/index.php/Configuring_Network_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E5.90.AF.E5.8A.A8.E6.97.B6.E8.BF.90.E8.A1.8C_DHCP)
