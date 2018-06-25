---
author: ety001
layout: post
title: '服务器间大文件传输还是要用Rsync'
tags:
- 教程
---

下午购买了新的vps，从原来的 `1核1G内存100G硬盘100M带宽1TB流量` 升级到 `2核6G内存500G硬盘100M带宽流量不限`，为了搭建 `steem-mysql` 我也是拼了血本了。

为了转移已经同步好的数据库文件，大约有33G，一开始大意了，使用了 `scp` ，然后就放在那里传输，也忘记开个 `screen` ，中间打了个盹，等醒了的时候发现，服务器断开连接了😂。由于 `scp` 不带断点续传，所以说已经传完的60%多的数据就是白传了🤣🤣🤣🤣。

大文件的传输还是得靠 `rsync`，自己大意了。`rsync` 除了支持断点续传外，还可以进行 `gzip` 压缩传输，这样效率更高，以下是两者的对比：

scp:

```
root@steem-mysql:~# scp /data/mysql.tar root@173.249.63.24:~/
root@173.249.63.24's password: 
mysql.tar                                            18% 6158MB   6.9MB/s 1:05:55 ETA
```

rsync:

```
root@steem-mysql:~# rsync -avzP /data/mysql.tar  root@173.249.63.24:~/ --progress
root@173.249.63.24's password: 
sending incremental file list
mysql.tar
 13,484,294,144  38%   21.12MB/s    0:16:30
```

如果 `ssh` 端口换了，那么需要加个参数

```
rsync -avzP -e 'ssh -p 1234' /data/mysql.tar  root@173.249.63.24:~/ --progres
```

另外，为了防止网络不稳定，在执行一些用时比较久的任务时，建议使用 `screen` 新开一个 `session` 来进行耗时较久的任务:

```
$ screen -S ws   # ws是自己定义的一个session名字
```

如果中途网络断开了，我们重新连入服务器，只需要执行

```
$ screen -r ws
```

即可恢复刚才的 `session`.

如果有多个 `session` 的话，可以使用下面的命令查看有哪些 `session`:

```
$ screen -ls
```