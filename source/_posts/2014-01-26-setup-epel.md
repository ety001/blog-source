---
author: ety001
comments: true
date: 2014-01-26 01:30:44+00:00
layout: post
slug: setup-epel
title: 安装epel
wordpress_id: 2564
tags:
- Server&OS
---

#2016.08.13更新

```
yum install epel-release
```

---

[http://mirrors.fedoraproject.org/publiclist/EPEL/](http://mirrors.fedoraproject.org/publiclist/EPEL/)

[http://www.codesky.net/article/201110/170019.html](http://www.codesky.net/article/201110/170019.html)

64位系统选择：

rpm  -ivh  epel-release-6-5.noarch.rpm

导入key：

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

如果用比较新的软件，用epel-test.repo这个文件就行了

别忘了安装yum install yum-priorities

