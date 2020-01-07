---
author: ety001
layout: post
title: 用 Docker 和 Firewalld 实现高度防护
tags:
- Server&OS
- Docker
---

最近接了一个运维 **cybex** 节点的任务，过程甚是坎坷。首先，我的客户提供的服务器上有一个在运行的 **eos** 侧链节点，其次，**cybex** 节点的搭建，官方要求要做严格的防火墙设置，即入站规则中只允许指定的 **IP** 访问本地的指定端口，出站规则中只允许本地访问指定IP的指定端口。

这样就防火墙要求就有些棘手了。由于目前服务器上的 **eos** 侧链节点并没有什么防火墙配置，所以要是把 **cybex** 的出站白名单机制做上了，**eos** 侧链要想正常工作，也需要配置一份出站白名单，否则 **eos** 侧链节点将拿不到其他节点的同步数据了。

思前想后，觉得可以把 **cybex** 节点使用 **docker** 容器运行，这样 **cybex** 节点就有独立的 **IP** 和隔离的环境了，我只需要在宿主机，使用 **cybex** 容器的 **IP** 作为标示来过滤进出站数据包即可。

思路定下来后，开始准备实施。

由于宿主机操作系统是 **CentOS7**，也就是系统默认安装的是 **Firewalld**。经过一番学习，写出了入站规则，如下：

```
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="IP1" forward-port port="5000" protocol="tcp" to-port="5000" to-addr="172.20.0.2"' --permanent
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="IP2" destination address="172.20.0.2" accept' --permanent
```

以上只是规则的一部分，重复语法的规则就不再写了。入站主要是两种规则，一种规则是指定来源IP，访问指定端口，就像第一条，来源 **IP** 是`IP1`，访问宿主机 `5000` 端口，直接转发到容器 `172.20.0.2` 的 `5000` 端口，即这是一条 `FORWARD` 链的规则。另外一种规则就是指定来源 **IP** 可以访问容器的所有端口，即这是一条 `INPUT` 链的规则。

这里需要注意，由于我们需要容器的高度隔离，所以，在启动容器的时候，就不再使用 `-p` 参数来绑定端口了。原因我们通过 `iptables -L FORWORD --line-number` 可以看到如下信息，

```
[root@li1677-102 ~]# iptables -L FORWARD --line-number
Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination
1    DOCKER-USER  all  --  anywhere             anywhere
2    DOCKER-ISOLATION-STAGE-1  all  --  anywhere             anywhere
3    ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
4    DOCKER     all  --  anywhere             anywhere
5    ACCEPT     all  --  anywhere             anywhere
6    ACCEPT     all  --  anywhere             anywhere
7    ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
8    DOCKER     all  --  anywhere             anywhere
9    ACCEPT     all  --  anywhere             anywhere
10   ACCEPT     all  --  anywhere             anywhere
11   ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
12   DOCKER     all  --  anywhere             anywhere
13   ACCEPT     all  --  anywhere             anywhere
14   ACCEPT     all  --  anywhere             anywhere
15   ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
16   ACCEPT     all  --  anywhere             anywhere
17   FORWARD_direct  all  --  anywhere             anywhere
18   FORWARD_IN_ZONES_SOURCE  all  --  anywhere             anywhere
19   FORWARD_IN_ZONES  all  --  anywhere             anywhere
20   FORWARD_OUT_ZONES_SOURCE  all  --  anywhere             anywhere
21   FORWARD_OUT_ZONES  all  --  anywhere             anywhere
22   DROP       all  --  anywhere             anywhere             ctstate INVALID
23   REJECT     all  --  anywhere             anywhere             reject-with icmp-host-prohibited
```

结合 `iptables` 的结构流程图（[http://www.zsythink.net/archives/1199/](http://www.zsythink.net/archives/1199/)），

![](https://steemeditor.com/storage/images/JtTZMLQZLKqcFjL4baLqyxsSZ8N4LYcFmyDBZDrm.png)

所有 **Docker** 容器的流量都是通过 **FORWARD** 链转发的，我们能看到上面第1\2\4\8\12行都是 **Docker** 产生的自定义链，并且通过 **Docker** 的官方文档了解到，官方不建议用户去修改 **DOCKER** 命名的自定义链，而是把需要增加的自定义内容放到 **DOCKER-USER** 这个自定义链中。而我们平时启动容器的时候，使用 `-p` 参数的时候，其实是把过滤规则写入了 **DOCKER** 链中。这就意味着，使用 `-p` 参数设置的转发过滤规则的优先级最高，无法用 **Firewalld** 来限制（17--21行是 **Firewalld** 产生的自定义链）。这也是我最初尝试的方案，用 `-p` 把容器端口映射到宿主机，然后再在宿主机配置端口策略，**这个方法是不行的**！

写完入站规则后，也想用入站的规则改一下成出站规则，发现 **Firewalld** 的 **rich rules** 无法做到（至少目前我是绕不出来）。于是继续看文档，发现 **Firewalld** 有一个 **--direct** 的参数可以直接使用 **iptables** 的语法来写入规则到 **iptables** 中。

又经过若干时间的学习和本地虚拟机实验，最终总结出的出站规则如下:

```
firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -p tcp -s 172.20.0.2 -d IP1 --dport 5000 -j ACCEPT
firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -s 172.20.0.2 -d IP2 -j ACCEPT
firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -s 172.20.0.2 -j REJECT
```

同样，这里也是捡出来关键的几条来展示。

这里就涉及到刚才说的，如果你要添加针对 **Docker** 的防火墙规则，就要把规则写入到 **DOCKER-USER** 中，因为 **DOCKER-USER** 的优先级最高。这几条规则的思路就是写出要放行的是哪些，然后最后把其他的**所有的**出站数据都禁掉。

这个地方，我踩到了一个还没有填的坑。

由于 **Docker** 和 **Firewalld** 都是通过修改 **iptables** 来实现其相应的功能的。而 **Docker** 的 **DOCKER-USER** 链 **Firewalld** 无法管理。具体表现就是上面的规则，你执行后，由于加了 `--permanent` 参数，需要重载配置才能生效，但是重载配置的时候，会报错，并且新增配置并不能生效。

经过两天的搜索，最终找到了一个临时的解决方案（ [https://github.com/moby/moby/issues/35043#issuecomment-356036671](https://github.com/moby/moby/issues/35043#issuecomment-356036671) ） 。

这个方案的原理大概是这样的：**Docker** 启动的时候会去检查有没有 **DOCKER-USER** 链，如果没有就创建一个，如果有就不再操作了，只是检查该链的最后，是不是放行所有规则。由于 **Docker** 的这个特性，那么我们就手动删掉 **DOCKER-USER** 链，用 **Firewalld** 来创建并管理这个链，这样并不影响 **Docker** 的正常使用，且 **Firewalld** 也可以正常重启或者重载配置。

```
# Removing DOCKER-USER CHAIN (it won't exist at first)
firewall-cmd --permanent --direct --remove-chain ipv4 filter DOCKER-USER

# Flush rules from DOCKER-USER chain (again, these won't exist at first; firewalld seems to remember these even if the chain is gone)
firewall-cmd --permanent --direct --remove-rules ipv4 filter DOCKER-USER

# Add the DOCKER-USER chain to firewalld
firewall-cmd --permanent --direct --add-chain ipv4 filter DOCKER-USER
```

所以，先执行上面这三条命令，用 **Firewalld** 重建 **DOCKER-USER** 链，然后再执行写好的出站规则，重载配置。进入容器测试了下，出站规则生效了。

到这里，我本来以为已经完美配置结束了。正要欢呼的时候，**cybex** 那边的技术小哥说，我的 **5000** 端口为啥不通？

WTF？！

考虑了下，感觉应该是后加的出站规则影响了入站规则。我也用 `nc -zv server_ip 5000` 测试了下，发现会一直卡到连接超时。我猜测可能是 `firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -s 172.20.0.2 -j REJECT` 这条规则影响的，于是手动删除掉这条规则，再用 **nc** 测试就正常了。

思考了下，这个过程应该是，白名单中的外部主机向我的服务器的 **5000** 端口发送了握手包要建立连接，而外部主机肯定是系统随机了一个高位的端口来连接我的 **5000** 端口，虽然入站规则符合了，但是我回应给他的握手包却不符合我设置的出站规则，导致握手不成功。

这个思路确定后，就继续去翻 **iptables** 的教程，去看看这种关联性的数据包怎么处理。最终还真让我发现了，[http://www.zsythink.net/archives/1597](http://www.zsythink.net/archives/1597)

![](https://steemeditor.com/storage/images/I3d5w4nJSBbIu20reYo7QscJFoESVMO2XTKGbxpn.png)

也就是，我可以在出站规则中先加上放行这些 **state** 的数据包的规则，所以修改后的出站规则如下:

```
firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -m state --state RELATED,ESTABLISHED -j ACCEPT
firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -s 172.20.0.2 -d IP2 -j ACCEPT
firewall-cmd  --permanent --direct --add-rule ipv4 filter DOCKER-USER 0 -s 172.20.0.2 -j REJECT
```

这样配置后，再测试，所有配置都已达到预期，完工！

这里再补充下这种出站策略对于节点的保护的意义。

很早之前，还是 **webshell** 盛行的时代，有见过类似这样配置的主机。由于 **webshell** 的运行权限一般不是 **Administrator** 或者 **root**，所以入侵者通过 **web** 网站拿到 **webshell** 后的权限比较低，会想通过上传本地溢出漏洞代码的方式，拿到最高权限。而有时候，管理员会配置上传文件的大小或者扩展名，所以直接通过 **webshell** 上传是受限的，所以入侵者想到了一个曲线救国的方案，就是用 **webshell** 指定一个下载路径，让服务器自己去指定的下载路径下载溢出漏洞的执行代码。这时候出站规则就排上用途了，如果管理员配置了禁止所有出站链接，除了 **RELATED,ESTABLISHED** 这样的数据包外，那么入侵者的这个方案就不可行了。另外还有就是如果入侵者通过 **webshell** 成功上传了被动链接式的木马程序，出站规则一样可以拦截掉。

这就是我之前对于出站规则的理解，就是防止内鬼从外部获取数据。

但是这次这种分布式节点，为什么还要这么设置呢？在咨询了 @abit 后豁然开朗。那就是这种配置，可以避免自己服务器的 **IP** 暴露给不信任的节点。不过我还是觉得这种规则的必要性并不是很强。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
