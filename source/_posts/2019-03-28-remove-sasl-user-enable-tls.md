---
author: ety001
layout: post
title: 如何删除sasl用户，如何让postfix以TLS方式连接远端服务器发信
tags:
- 后端
- Server&OS
- postfix
---

# 如何删除sasl用户

```
db_dump -p /etc/sasldb2 > /tmp/sasldb2.dump
vim /tmp/sasldb2.dump # 找到你要删除的用户，删掉用户和密码即可，也可以修改密码
mv /etc/sasldb2 /etc/sasldb2.bak
db_load -f /tmp/sasldb2.dump /etc/sasldb2
rm -rf /tmp/sasldb2.dump
```

# 如何让postfix以TLS方式连接远端服务器发信

在 `/etc/postfix/main.cf` 最后增加下面的配置。配置后再给 Gmail 发信，就不会提示不安全连接了。

```
smtpd_tls_security_level = may
smtp_tls_security_level = may
```

另外推一下之前写的《如何快速搭建邮件服务器用来发邮件》[https://akawa.ink/2018/01/08/create-a-simple-smtp-server-by-postfix-and-sasl.html](/2018/01/08/create-a-simple-smtp-server-by-postfix-and-sasl.html)

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
