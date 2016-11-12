---
author: ety001
comments: true
date: 2012-07-18 02:47:55+00:00
layout: post
slug: chrome_chromium-import-certificate
title: linux下chrome/chromium导入证书
wordpress_id: 2153
tags:
- Server&OS
---

在linux下导入chrome或者chromium的证书，只需要检查下自己是否有certutil命令，然后执行下面的命令即可：

certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n GoAgent -i '/home/ety001/goagent/local/CA.crt'

说明：

1、该命令不需要root执行，只要当前用户即可。

2、-n后面的参数随便，就是个名字

3、-i参数是你要导入的证书的位置。



2013-01-08补充：

不知道是文件损坏还是怎么回事，一运行就出错，比如：


    certutil: function failed: security library: bad database.


或者：


    certutil: could not authenticate to token NSS Certificate DB.: An I/O error occurred during security authorization.


重建目录和文件也不行，找了好几次终于找到初始化的命令：


    modutil -changepw "NSS Certificate DB" -dbdir $HOME/.pki/nssdb
