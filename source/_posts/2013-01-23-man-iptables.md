---
author: ety001
comments: true
date: 2013-01-23 07:58:01+00:00
layout: post
slug: man-iptables
title: man iptables
wordpress_id: 2297
tags:
- Server&OS
---

man iptables
 命令格式：

  # iptables [-t 表名] 命令 [链]  [规则号]  [条件]  [规则]

 说明：⑴ -t 表名    指定规则所在的表。表名可以是 filter ,nat ,mangle (小写)

⑵  命令 （iptables的子命令）

 -A        在指定链中添加规则

 -D        在指定链中删除指定规则

 -R        修改指定链中指定规则

 -I         在指定规则前插入规则

 -L        显示链中的规则

 -N        建立用户链

 -F        清空链中的规则

 -X        删除用户自定义链

 -P         设置链的默认规则

 -C         用具体的规则链来检查在规则中的数据包

 -h        显示帮助
<!-- more -->
     ⑶ 条件

–i 接口名                        指定接收数据包接口

-o 接口名                        指定发送数据包接口

-p [!]协议名                       指定匹配的协议 (tcp , udp , icmp , all )

-s [!]ip地址 [/mask]                指定匹配的源地址

--sport [!]端口号 [：端口号]         指定匹配的源端口或范围

-d [!]ip地址 [/mask]                指定匹配的目标地址

--dport [!]端口号 [：端口号]         指定匹配的目标端口或范围

--icmp –type [!]类型号/类型名        指定icmp包的类型

注：8 表示request      0 表示relay （应答）

     -m  port  --multiport         指定多个匹配端口

         limit  --limit             指定传输速度

         mac  --mac-source       指定匹配MAC地址

         sate  --state NEW,ESTABLISHED,RELATED,INVALID   指定包的状态

注：以上选项用于定义扩展规则

-j  规则                           指定规则的处理方法

          ⑷  规则

           ACCEPT   ：接受匹配条件的数据包（应用于I NPUT ,OUTPUT ,FORWARD ）

           DROP      ：丢弃匹配的数据包（应用于INPUT ,OUTPUT ,FORWARD ）

           REJECT    ：丢弃匹配的数据包且返回确认的数据包

           MASQUERADE ：伪装数据包的源地址（应用于POSTROUTING且外网地址

为动态地址，作用于NAT ）

           REDIRECT  ：包重定向 （作用于NAT表中PREROUTING ,OUTPUT,使用要加上--to-port  端口号 ）

           TOS        ：  设置数据包的TOS字段（应用于MANGLE,要加上--set-tos 值）

           SNAT       ：  伪装数据包的源地址（应用于NAT表中POSTROUTING链，要加上--to-source  ip地址 [ip地址] ）

           DNAT       ：  伪装数据包的目标地址（应用于NAT表中PREROUTING链，要加上--to-destination ip地址 ）

           LOG        ：使用syslog记录的日志

           RETURN    ：直接跳出当前规则链

3． iptables子命令的使用实例

⑴   添加规则

#iptables –A INPUT –p icmp –-icmp-type 8 –s 192.168.0.3 –j DROP

(拒绝192.168.0.3主机发送icmp请求)

# iptables –A INPUT –p icmp –-icmp-type 8 –s 192.168.0.0/24 –j DROP

(拒绝192.168.0.0网段ping 防火墙主机，但允许防火墙主机ping 其他主机)

# iptables –A OUTPUT –p icmp –-icmp-type 0 –d 192.168.0.0/24 –j DROP

(拒绝防火墙主机向192.168.0.0网段发送icmp应答，等同于上一条指令)

# iptables –A FORWARD –d  -j DROP

(拒绝转发数据包到,前提是必须被解析)

# iptables –t nat –A POSTROUTING –s 192.168.0.0/24 –j SNAT –-to-source 211.162.11.1

(NAT，伪装内网192.168.0.0网段的的主机地址为外网211.162.11.1,这个公有地址，使内网通过NAT上网，前提是启用了路由转发)

# iptables –t nat –A PREROUTING –p tcp --dport 80 –d 211.162.11.1 –j DNAT -–to-destination 192.168.0.5
(把internet上通过80端口访问211.168.11.1的请求伪装到内网192.168.0.5这台WEB服务器，即在iptables中发布WEB服务器，前提是启用路由转发)

# iptables –A FORWARD –s 192.168.0.4 –m mac --mac-source 00:E0:4C:45:3A:38 –j ACCEPT
(保留IP地址，绑定 IP地址与MAC地址)

⑵删除规则
# iptables –D INPUT  3
# iptables –t nat –D OUTPUT –d 192.168.0.3  –j  ACCEPT
⑶插入规则
# iptables –I FORWARD 3 –s 192.168.0.3  –j DROP
# iptables –t nat –I POSTROUTING 2 –s 192.168.0.0/24 –j DROP
⑷修改规则
# iptables –R INPUT 1 –s 192.168.0.2 –j DROP
⑸显示规则
# iptables –L (默认表中的所有规则)
# iptables –t nat –L POSTROUTING
⑹清空规则
# iptables –F
# iptables –t nat –F PREROUTING
⑺设置默认规则
# iptables –P INPUT ACCEPT
# iptables –t nat –P OUTPUT DROP
(注：默认规则可以设置为拒绝所有数据包通过，然后通过规则使允许的数据包通过，这种防火墙称为堡垒防火墙，它安全级别高，但不容易实现；也可以把默认规则设置为允许所有数据包通过，即鱼网防火墙，它的安全级别低，实用性较差。）
⑻建立自定义链
# iptables –N wangkai
⑼删除自定义链
# iptables –X wangkai
⑽应用自定义链
# iptables –A wangkai –s 192.168.0.8  –j DROP
# iptables –A INPUT –j wangkai
(注：要删除自定义链，必须要确保该链不被引用,而且该链必须为空，如要删除上例定义的自定义链方法为：
# iptables –D INPUT –j wangkai
# iptables  -F wangkai
# iptables  -X wangkai

