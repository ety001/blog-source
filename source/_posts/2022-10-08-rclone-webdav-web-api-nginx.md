---
author: ety001
date: 2022-10-08 13:25:31
layout: post
title: 使用 rclone 连接 WebDAV 并提供 Web Api 给 nginx
tags:
- Server&OS
- 服务器
---

最近调整了 Steem 区块数据的备份服务，使用了新的服务商 Hetzner。

由于 Hetzner 提供了多种上传下载数据的方式，我测试了 rsync，samba，webdav，目前决定使用 webdav，通过牛逼的 rclone 工具。

这篇文章记录下相关的配置。

首先需要安装 rclone，安装方法在官网有 [https://rclone.org/install/](https://rclone.org/install/)。

配置 rclone 也很简单，安装后执行 `rclone config`，按照提示，创建新的连接，输入连接名（比如 hetzner），选择连接方式为 `WebDAV`，输入 URL、用户名、密码完成配置。

使用 `rclone ls [连接名]:[目录名]` 命令，检查一下是否配置成功。

```
[root@steem ～]# rclone ls hetzner:steem
192373084633 block_log_20221005.tar.gz
341570969022 steem_api_20221005.tar.lz4
249576123913 steem_witness_20220805.tar.lz4
251694849097 steem_witness_20221003.tar.lz4
```

执行成功。

现在把本地备份服务器和远端的 [https://files.steem.fans](https://files.steem.fans) 服务器上都配置好 rclone。

本地备份服务器的备份脚本，涉及上传删除的指令都换成 `rclone copy` 和 `rclone delete`。

远端服务器之前是 nginx 做 autoindex，并以 json 格式显示目录文件结构：

```
    location /data {
        alias /data/wwwroot/steem;
        autoindex   on;
        autoindex_localtime on;
        autoindex_exact_size off;
        autoindex_format    json;
        # Enable your browser to access here.
        add_header  Access-Control-Allow-Origin "*";
        add_header  Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header  Access-Control-Allow-Headers "Origin, Authorization, Accept";
        add_header  Access-Control-Allow-Credentials true;
    }
```

现在换成 rclone 了，rclone 可以用挂载的方式继续使用 nginx 的 autoindex。

不过这里有一个问题，就是我的 nginx 是 docker 方式运行的，rclone 挂载目录后，还需要再挂载进 docker 容器。而每次 rclone 重启，都需要再重启一遍 nginx 容器。这就很糟糕了。

研究了下 rclone 的文档，发现可以使用 `rclone serve web` 启动一个 Web 服务器来显示 Hetzner 服务器目录，不过不支持 json 格式显示结果。幸好有个参数可以自定义模板。于是我自己写了个模板，

```
[{{$length := len .Entries}}{{- range $i, $entry := .Entries}}{{- if $entry.IsDir}}{{if ne $i 0}},{{end}}{ "name":"{{html $entry.Leaf}}", "type":"directory", "mtime":"{{$entry.ModTime.Format "Jan 02, 2006 15:04:05 UTC"}}", "size":{{$entry.Size}}}{{- else}}{{if ne $i 0}},{{end}}{ "name":"{{html $entry.Leaf}}", "type":"file", "mtime":"{{$entry.ModTime.Format "Jan 02, 2006 15:04:05 UTC"}}", "size":{{$entry.Size}}}{{- end}}{{- end}}]
```

然后安装 supervisor 来管理 `rclone serve` 服务，

```
[program:rclone_hetzner]
command = /usr/bin/rclone serve http --addr 0.0.0.0:8088 --template /etc/rclone/template.html --vfs-cache-mode writes --buffer-size 32M --dir-cache-time 12h --vfs-read-chunk-size 64M --vfs-read-chunk-size-limit 1G hetzner:steem
autostart = true
startsecs = 10
autorestart = true
user = root
stdout_logfile_maxbytes = 20MB
stdout_logfile_backups = 20
stdout_logfile = /var/log/supervisor/rclone_het.log
stderr_logfile = /var/log/supervisor/rclone_het_err.log
```

最后，修改 nginx 配置文件，

```
    location ~ ^/data(/?)(.*) {
        proxy_pass http://172.20.0.1:8088/$2;
    }
```

访问测试下 [https://files.steem.fans/data](https://files.steem.fans/data)，成功。

目前总体迁移工作完成了大部分了，还得需要再等最后的数据replay结束。
