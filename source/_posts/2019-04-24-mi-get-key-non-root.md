---
author: ety001
layout: post
title: 不用root快速获取米家数据库的方法
tags:
- Server&OS
---
# 准备
* adb
* ADB Backup Extractor ([https://sourceforge.net/projects/adbextractor/](https://sourceforge.net/projects/adbextractor/))

# 开始

1.  手机连接电脑，使用adb调用数据备份功能
```
adb backup -noapk com.xiaomi.smarthome -f backup.ab
```
执行这条命令后，手机上会显示一个界面，点击允许备份即可。

2. 使用 `ADB Backup Extractor` 把备份下来的 `backup.ab` 转换为 `backup.tar`，
```
java -jar abe.jar unpack backup.ab backup.tar
```

3. 解压缩`backup.tar` 后，在 `db` 目录里就能找到 `miio2.db` 了。

# 注意
对于新版的米家不再把 `token` 存储在 `miio2.db` 中的解决方案，就是去下载米家 **5.0.19**，这里是下载地址：
[https://www.apkmirror.com/apk/xiaomi-inc/mihome/mihome-5-0-19-release/mihome-5-0-19-android-apk-download/download/](https://www.apkmirror.com/apk/xiaomi-inc/mihome/mihome-5-0-19-release/mihome-5-0-19-android-apk-download/download/)


---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
