---
author: ety001
layout: post
title: 在OSX El Captian下安装CH340(CH341)的驱动
tags:
- Server&OS
keywords: ['osx', 'el captian', 'ch340', 'driver']
---
由于 El Capitan 强制 kext driver 进行签名，导致了驱动安装失败，
所以，得先重启机器，按住 Commond + R 进入恢复模式，然后打开终端，
输入以下命令

```
csrutil enable --without kext
```

重启后，再执行驱动安装即可。

参考：<http://tzapu.com/making-ch340-ch341-serial-adapters-work-under-el-capitan-os-x/>
