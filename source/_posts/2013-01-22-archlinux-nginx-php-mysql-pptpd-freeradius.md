---
author: ety001
comments: true
date: 2013-01-22 16:48:00
layout: post
slug: archlinux-nginx-php-mysql-pptpd-freeradius
title: archlinux+nginx+php+mysql+pptpd+freeradius
wordpress_id: 2294
tags:
- Server&OS
---

折腾了一天终于可以实现freeradius认证登录的pptp vpn了，总结一下。

其实整个过程分为三步，第一步：

分别搭建nmp环境（主要为了能用phpmyadmin，后期可以再找找看有没有其他php管理radius的软件，实在不行就自己写一个）、pptp vpn环境、radius认证环境

第二步：

整合radius和mysql

第三步：

整合radius和pptp vpn。

**开始：**

1、由于之前已经搭建好了pptpd的vpn了，所以vpn搭建这块就跳过了。

vpn搭建好以后，自己测试一下是否可用。具体的可以参照arch wiki，wiki上有详细的配置，地址：[https://wiki.archlinux.org/index.php/PPTP_Server_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)](https://wiki.archlinux.org/index.php/PPTP_Server_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

2、安装freeradius服务端和客户端。

# pacman -S freeradius freeradius-client<!-- more -->

之所以安装客户端，是因为当用户拨号到服务器的时候，服务器的pptp其实调用了radius客户端去连接radius服务端进行认证。

安装完以后，我们先修改下这个文件


    vim /etc/raddb/users
    # 找到 steve Cleartext-Password := “testing” , 取消该段的相关注释
    steve Cleartext-Password := "testing"
    Service-Type = Framed-User,
    Framed-Protocol = PPP,
    Framed-IP-Address = 172.16.3.33,
    Framed-IP-Netmask = 255.255.255.0,
    Framed-Routing = Broadcast-Listen,
    Framed-Filter-Id = "std.ppp",
    Framed-MTU = 1500,
    Framed-Compression = Van-Jacobsen-TCP-IP


把文本形式的用户认证数据取消掉注释，然后执行下面的命令：


    radiusd -X

    # 进入debug日志输出模式
    # 如果有出现
    Listening on authentication address * port 1812
    Listening on accounting address * port 1813
    Listening on command file /usr/local/var/run/radiusd/radiusd.sock
    Listening on proxy address * port 1814
    Ready to process requests.
    # 这些字样说明正常启动成功了

    # 重新打开一个窗口，执行下面这条命令
    radtest steve testing localhost 1812 testing123 # 用户名steve 密码testing , 连接密钥testing123
    # 出现 rad_recv: Access-Accept packet 字样说明验证成功


3、安装配置LNMP环境，这个也跳过，网上已经很多说明了，我是用pacman逐个安装然后配置的。安装好以后，把phpmyadmin放到网站根目录下面，然后登录，
把/etc/raddb/sql/mysql/下面的sql全部导入进去，再在sql执行器中执行下面的SQL语句：


    GRANT SELECT ON radius.* TO 'radius'@'localhost' IDENTIFIED BY 'radpass';
    GRANT ALL on radius.radacct TO 'radius'@'localhost';
    GRANT ALL on radius.radpostauth TO 'radius'@'localhost';
    # 加入组信息，本例中的组名为user
    insert into radgroupreply (groupname,attribute,op,value) values ('user','Auth-Type',':=','Local');
    insert into radgroupreply (groupname,attribute,op,value) values ('user','Service-Type','=','Framed-User');
    insert into radgroupreply (groupname,attribute,op,value) values ('user','Framed-IP-Netmask',':=','255.255.255.0');
    # 加入用户信息
    INSERT INTO radcheck (UserName, Attribute, Value) VALUES ('ety001', 'Password', 'domyself');
    # 用户加到组里
    insert into radusergroup(username,groupname) values('sqltest','user');
    # 限制账户同时登陆次数
    INSERT INTO radgroupcheck (GroupName, Attribute, op, Value) values("user", "Simultaneous-Use", ":=", "1");


4、关联radius和mysql

先设置radius客户端，


    vim /etc/radiusclient/radiusclient.conf
    #如果不存在的话，就cp -r /etc/radiusclient.default /etc/radiusclient
    #找到 authserver 和 acctserver 将值改为 localhost
    #将 radius_deadtime 0 和 bindaddr * 将这两项注释掉

    vim /etc/radiusclient/servers
    #添加通信密码
    localhost testing123

    # 增加字典。这一步很重要！否则在win下会一直报691错误
    wget -c http://hello-linux.googlecode.com/files/dictionary.microsoft
    mv ./dictionary.microsoft /usr/local/etc/radiusclient/
    cat >>/usr/local/etc/radiusclient/dictionary<


然后设置radius服务端：


    vim /etc/raddb/sql.conf
    # 设定数据库类型,帐号,密码,数据库,根据实际情况修改
    # 找到 readclients = yes 取消前面的注释，取消该注释主要是启用nas表查询，clients.conf就可以不需要了

    vim /etc/raddb/radiusd.conf
    # 查找$INCLUDE sql.conf（第700行），去掉#号，很重要，如果这个地方不改掉，启动的时候会报找不到sql模块，即sql.conf中的sql{}

    vim /etc/raddb/sites-enabled/default
    # 找到authorize {}模块，注释掉files（170行），去掉sql前的#号（177行）
    # 找到accounting {}模块，注释掉radutmp(396行)，去掉sql前面的#号(406行)
    # 找到session {}模块，注释掉radutmp（450行），去掉sql前面的#号（454行）
    # 找到post-auth {}模块，去掉sql前的#号（475行），去掉sql前的#号（563行）

    vim /usr/local/etc/raddb/sites-enabled/inner-tunnel
    # 找到authorize {}模块，注释掉files（125行），去掉sql前的#号（132行）
    # 找到session {}模块，注释掉radutmp（252行），去掉sql前面的#号（256行）
    # 找到post-auth {}模块，去掉sql前的#号（278行）,去掉sql前的#号（302行）


上面的工作做完后，重启freeradius，启动成功后，执行下面的操作：


    # 用刚才插入数据库的用户名和密码来检验
    radtest ety001 domyself localhost 1812 testing123
    # 出现 rad_recv: Access-Accept packet 字样说明安装已经成功


5、关联pptp和radius
在pptp的配置文件中，即/etc/ppp/pptpd-options中，添加如下两行：


    plugin /usr/lib/pppd/2.4.5/radius.so
    radius-config-file /etc/radiusclient/radiusclient.conf


一切搞定，重启下pptp，你就可以去尝试从别的电脑上来连接你的vpn了。

本文参考了：[http://www.zhukun.net/archives/5375](http://www.zhukun.net/archives/5375)

