---
author: ety001
layout: post
title: 在Kali Linux下安装Nodejs和npm
tags:
- Server&OS
---

按照下面的命令输入即可

```
sudo apt-get install python g++ make checkinstall fakeroot

src=$(mktemp -d) && cd $src

wget -N http://nodejs.org/dist/node-latest.tar.gz

tar xzvf node-latest.tar.gz && cd node-v*

./configure

sudo fakeroot checkinstall -y --install=no --pkgversion $(echo $(pwd) | sed -n -re's/.+node-v(.+)$/\1/p') make -j$(($(nproc)+1)) install

sudo dpkg -i node_*

```

转自：http://www.free4net.com/2014/06/installing-nodejs-and-npm-in-kali-linux.html
