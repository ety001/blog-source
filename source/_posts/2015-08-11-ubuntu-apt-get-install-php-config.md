---
author: ety001
layout: post
title: ubuntu的apt-get安装Nginx+PHP时的配置
tags:
- Server&OS
---

在使用ubuntu的apt-get安装php-fpm的时候，默认的nginx配置文件的php相关部分少了如下一行代码

```
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
```

把这行代码加在 `include fastcgi_params;` 之前即可。

