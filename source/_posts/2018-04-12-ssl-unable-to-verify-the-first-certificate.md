---
author: ety001
layout: post
title: '配置SSL时出现 Error: unable to verify the first certificate'
tags:
- 经验
- 教程
---

之前在家里的服务器上搭建了一个 BTS 的 API 节点，使用的是 [Let's Encrypt](https://letsencrypt.org/) 的证书服务。搭建好以后，一直有一个奇怪的问题没有解决，就是在交易所使用没有问题，但是用 `wscat` 连接就会报 `Error: unable to verify the first certificate` 的错误，如下图：

![](https://steemeditor.com/storage/images/gnx6OCstwifimJW6eBLEE1uyU89DdzWrXFIrkdSR.png)

使用 `openssl s_client -connect bts.to0l.cn:4443` 检查也是有报错的

![](https://steemitimages.com/DQmPEg2q8uMNQmHeoCvPYFNH6hw8xPqKcowikVnjdZjPc2V/image.png)

由于不影响我使用交易所，所以就忽略了。今天 @abit 在群里说我的节点证书有问题，虽然没有指出具体问题在哪，我目测应该就是这个问题。

经过检查，证书生成没有问题，最后确定是 `nginx` 的证书配置有问题，参考了这个帖子 [https://serverfault.com/questions/875297/verify-return-code-21-unable-to-verify-the-first-certificate-lets-encrypt-apa](https://serverfault.com/questions/875297/verify-return-code-21-unable-to-verify-the-first-certificate-lets-encrypt-apa) 。

就是把

```
ssl_certificate      /root/.acme.sh/bts.to0l.cn/fullchain.cer;
```

替换成

```
ssl_certificate      /root/.acme.sh/bts.to0l.cn/bts.to0l.cn.cer;
```

这次之所以出现这个问题，也是疏忽。之前在服务器上一直用 `certbot` 生成证书，`certbot` 生成证书后，会提示使用如下两个文件

```
/etc/letsencrypt/live/xxxx.net/fullchain.pem;
/etc/letsencrypt/live/xxxx.net/privkey.pem;
```

而这次使用家里搭建服务器，由于联通封锁了家庭网络的 80 和 443 ，所以没有办法用 `certbot` 来签发证书，因此使用的是 `acme` 脚本，通过 `DNS` 来完成证书签发过程中的域名认证。而 `acme` 最后生成好后，给出的两个文件是

```
/root/.acme.sh/bts.to0l.cn/bts.to0l.cn.cer;
/root/.acme.sh/bts.to0l.cn/bts.to0l.cn.key;
```

所以相当然的就配置上了。

具体的这两个证书文件为何不同还不清楚，目测 `bts.to0l.cn.cer` 是一个不完整的证书吧，以后有时间再去研究下。