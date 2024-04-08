---
title: Linux中的locale报错问题
date: 2017-03-02 12:22:30
keywords: ['centos', 'debian', 'linux', 'locale', 'setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory']
tags:
- Server&OS
---
最近好几个服务器，ssh登录的时候，都有同一个报错，

```
setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
```

经过搜索，找到了解决方案

```
# tee /etc/environment <<- 'EOF'
 LANG=en_US.utf-8
 LC_ALL=en_US.utf-8
 EOF

# source /etc/environment

/* 生成 en_US.UTF-8 locale文件 CentOS没有locale-gen命令*/
# localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
```
