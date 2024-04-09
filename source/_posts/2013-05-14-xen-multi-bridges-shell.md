---
author: ety001
comments: true
date: 2013-05-14 05:11:58
layout: post
slug: xen-multi-bridges-shell
title: xen双网卡桥接配置脚本
wordpress_id: 2374
tags:
- Server&OS
---

轉自：[http://hi.baidu.com/changzheng2008/item/6162ba0fc47936d8dce5b015](http://hi.baidu.com/changzheng2008/item/6162ba0fc47936d8dce5b015)

编写脚本my-briges.sh

`
#!/bin/sh
# network-xen-multi-bridge
# Exit if anything goes wrong.
set -e
# First arg is the operation.
OP=$1
shift
script=/etc/xen/scripts/network-bridge`

case ${OP} in
start)
$script start vifnum=1 bridge=xenbr1 netdev=eth1
$script start vifnum=0 bridge=xenbr0 netdev=eth0
;;
stop)
$script stop vifnum=1 bridge=xenbr1 netdev=eth1
$script stop vifnum=0 bridge=xenbr0 netdev=eth0
;;
status)
$script status vifnum=1 bridge=xenbr1 netdev=eth1
$script status vifnum=0 bridge=xenbr0 netdev=eth0
;;
*)
echo 'Unknown command: ' ${OP}
echo 'Valid commands are: start, stop, status'
exit 1
esac

chmod u+x my-briges.sh

#my-briges.sh start 创建虚拟网桥

#my-briges.sh status 查看虚拟网桥等相关信息

#my-briges.sh stop 删除虚拟网桥

