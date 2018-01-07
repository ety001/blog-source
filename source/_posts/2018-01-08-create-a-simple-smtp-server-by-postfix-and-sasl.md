---
author: ety001
layout: post
title: '用postfix和sasl搭建一个简易的发邮件服务器'
tags:
- Server&OS

---

有时候为了发送一定量的邮件，而使用类似QQ邮箱这样厂商的产品就会受到各种限制。
为此，需要自己搭建个简易的发邮件的服务器。需求很简单：服务器只需要能发邮件，
不需要接收邮件，且发邮件可以使用 `smtp` 登陆验证来使用。

# 安装MTA服务器

我的VPS是 `centos7` ，系统自带了 `postfix`，然后还需要安装 `sasl`，
这个是为了实现 `smtp` 验证必备的软件。

```
yum install cyrus*
```

如果你的服务器上没有 `postfix` ，而是 `sendmail`，你需要先卸载再安装。

```
rpm -e sendmail
yum install postfix
```

# 配置DNS

我用的是DNSPOD，要配置的域名为 `mypi.win`，也就是我希望发邮件的地址是
`username@mypi.win`。需要在DNSPOD做以下三条配置

![dns配置](/upload/20180108/1.png)

其中 `SPF` 配置中的内容为 `v=spf1 a mx ip4:x.x.x.x -all`，把其中的
`x.x.x.x` 换成你的服务器IP，也就是你的主域名指向的IP。

`SPF` 的作用是为了降低邮件被识别为垃圾邮件的概率，配置好以后，可以去[这里](http://www.kitterman.com/spf/validate.html)
测试下是否配置正确了。

# 配置postfix

修改 `/etc/postfix/main.cf` 的内容。

```
##将下面的配置项注释取消，后面填上合适值##
myhostname = mypi.win
#大约在75行，postfix主机名，修改成你的域名 此项需要添加A记录并指向postfix所在主机公网IP
mydomain = mypi.win
#大约在83行，后面为主机域名
myorigin = $mydomain
#大约在100行，设置postfix邮箱的域名后缀为$mydomain，即mypi.win
inet_interfaces = localhost
#大约在117行
#指定postfix系统监听的网络接口 此处必须是localhost或127.0.0.1或内网ip
#若注释或填入公网ip  服务器的25端口将对公网开放
#默认值为all 即监听所有网络接口
#此项指定localhost后 本机postfix就只能发邮件不能接收邮件
inet_protocols = ipv4
#大约在120行,指定网络协议
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
#大约在165行
#指定postfix接收邮件时收件人的域名，换句话说，也就是你的postfix系统要接收什么样的邮件。
#此项配置中$myhostname表示postfix接受@$myhostname为后缀的邮箱的邮件 逗号分割支持指多项
#此项默认值使用myhostname
local_recipient_maps =
#此项制定接收邮件的规则 可以是hash文件 此项对本次配置无意义 可以直接注释
mynetworks = x.x.x.x, 172.17.0.1, 127.0.0.1
#大约在266行
#指定你所在的网络的网络地址
#本服务器的公网IP x.x.x.x、内网ip 172.17.0.1、以及localhost的ip127.0.0.1
#请依据实际情况修改
smtpd_banner = ETY001 Steemit Mention Server
#大约在571行
#指定MUA通过smtp连接postfix时返回的header头信息

#SMTP Config
broken_sasl_auth_clients = yes
#指定postfix兼容MUA使用不规则的smtp协议--主要针对老版本的outlook 此项对于本次配置无意义
smtpd_client_restrictions = permit_sasl_authenticated
#指定可以向postfix发起SMTP连接的客户端的主机名或ip地址
#此处permit_sasl_authenticated意思是允许通过sasl认证（也就是smtp链接时通过了账号、密码效验的用户）的所有用户
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
#发件人在执行RCPT TO命令时提供的地址进行限制规则 此处照搬复制即可
smtpd_sasl_auth_enable = yes
#指定postfix使用sasl验证 通俗的将就是启用smtp并要求进行账号、密码效验
smtpd_sasl_local_domain = $mydomain
#指定SMTP认证的本地域名 本次配置可以使用 smtpd_sasl_local_domain = '' 或干脆注释掉 默认为空
smtpd_sasl_security_options = noanonymous
#取消smtp的匿名登录 此项默认值为noanonymous smtp若能匿名登录危害非常大 此项请务必指定为noanonymous
message_size_limit = 5242880
#指定通过postfix发送邮件的体积大小 此处表示5M
```

# 配置 SMTP

配置 `postfix` 启用 `sasldb2` 的账号密码验证方式：

```
vim /etc/sasl2/smtpd.conf
#向这个文件写入如下的内容（这个文件的路径为64位系统的，如果是32位系统应该在/usr/lib/sasl2/smtpd.cof）

pwcheck_method: auxprop
auxprop_plugin: sasldb
mech_list: plain login CRAM-MD5 DIGEST-MD5
```

接下来新建一个连接stmp服务的用户名和密码：

```
[root@mypi ~]# saslpasswd2 -c -u `postconf -h mydomain` steemit
```

这条命令会新建一个 `steemit@mypi.win` 的用户，接着会让你输入密码，假设密码为 `123456789`。

新建完成后，可以使用 `sasldblistusers2` 命令 来查看 已经添加了哪些用户（密码使用userPassword代替）：

```
[root@mypi ~]# sasldblistusers2
steemit@mypi.win: userPassword
```

修改 `sasldb` 的权限，让 `postfix` 可以读取其中的内容

```
[root@mypi ~]# chgrp postfix /etc/sasldb2
[root@mypi ~]# chmod 640 /etc/sasldb2
```

# 启动 postfix 并添加开机启动

如果是 centos7 ，执行下面的命令

```
systemctl start postfix
systemctl enable postfix
```

# 测试smtp

在另外的电脑上执行下面的命令

```
/ # nc mypi.win 25
220 ETY001 Steemit Mention Server
auth login
334 VXNlcm5hbWU6
c3RlZW1pdEBteXBpLndpbg==
334 UGFzc3dvcmQ6
MTIzNDU2Nzg5
235 2.7.0 Authentication successful
```

其中 `auth login` 为登陆验证指令， `c3RlZW1pdEBteXBpLndpbg==` 是邮箱地址
`steemit@mypi.win` 的 `base64` 编码后字符串，`MTIzNDU2Nzg5` 是密码
`123456789` 的 `base64` 编码后字符串。
