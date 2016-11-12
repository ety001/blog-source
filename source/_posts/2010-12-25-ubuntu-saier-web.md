---
author: ety001
date: 2010-12-25 18:43:09+00:00
layout: post
title: 可以用ubuntu上赛尔网了
wordpress_id: 758
tags:
- Server&OS
---

今天给一赛尔网用户安装ubuntu系统，安完后却没法上网很是无语，主要问题就是登录验证这个环节，赛尔方面没有提供linux环境下的程序。首先说一下，鲁大校园网是用的安腾的验证系统，现在用小蝴蝶登录进行BAS验证。从网上找了一大圈，终于是找到了能够在linux环境下通过验证的软件，它就是aecium 。


先把aecium的下载地址贴出来~[http://u.115.com/file/f846c28d09](http://woshao.com/router.php?link=http%3A%2F%2Fu.115.com%2Ffile%2Ff846c28d09&title=http%3A%2F%2Fu.115.com%2Ffile%2Ff846c28d09)

下载后首先解压，解压后可以选择直接在终端运行，也可以把它复制到bin文件夹下作为指令来使用。

建议选择后者，具体命令为：

$sudo cp aecium /usr/bin/program_name

（其中program_name为你想给这个程序起的名字，也可以保持原来的aecium不变）

然后打开你的网卡设置，把赛尔分配给你的ip等信息填上

<!-- more -->

准备工作搞定后，再执行

$program_name -h IP -u username -p password -d eth0 -f

（program_name为上一步你给程序起的名字，IP为学校计费服务器的IP地址，鲁东大学计费服务器为10.0.2.5 ,username和password分别为上网验证用的用户名和密码，eth0为你接网线的网卡，一般默认都是eth0）

运行后，如图所示


[![鲁大校园网安腾BAS验证通过](http://www.domyself.me/wp-content/uploads/2010/12/b10-400x75.jpg)](http://www.domyself.me/index.php/2010/12/758/b10)




如果你想下线的话，可以使用如下命令

$program_name -l

（我感觉此功能一般没用）

其它的使用方法见下：

Usage 1:

./aecium [-h Host] -u Username -p Password [-d Device] [-f]

-h Host                 attestation host IP address.

-u Username             your user name.

-p Password             your user password.

-d Device               your network card interface.

-f                      find server type.

Usage 2:

./aecium -l

-l Leave                        leave Internet.

Usage 3:

./aecium -v

-v Version              show program version.

