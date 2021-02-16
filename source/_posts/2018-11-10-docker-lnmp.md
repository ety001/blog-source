---
author: ety001
layout: post
title: 命令行版的docker化lnmp搭建
tags:
- 配置
- LNMP
- Docker
---

之前写过一篇{% post_link "build-a-dockerized-lnmp-environment-by-portainer" "用 Portainer 图形界面工具来搭建 Docker 化的LNMP" %}。但是每次开一台新的VPS，按照那个流程走下来都要累死，于是按照那个思路，整理了一份命令行版本的部署方案。

# 创建数据目录

```
mkdir -p /data/wwwroot && mkdir -p /data/logs && mkdir -p /data/mysql
```

这三个目录分别用来存储网站文件，网站日志，数据库文件。

# 在 CentOS 下安装 Docker

```
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine \
&& yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 \
&& yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo \
&& yum install -y docker-ce \
&& systemctl enable docker \
&& systemctl start docker
```
以上是 Docker 官方给出的在 CentOS 下安装 Docker 的文档，Ubuntu 可以参考这里: [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/) 。在边栏还可以看到其他系统的安装方法。

# 创建子网络

```
docker network create --gateway "172.20.0.1" --subnet "172.20.0.0/16" lnmp
```

把 LNMP 放在独立的网络里更易管理。

# 部署 Nginx

```
docker run -itd --name nginx nginx \
&& \
docker cp nginx:/etc/nginx /etc \
&& \
docker stop nginx && docker rm nginx \
&& \
docker run -itd --name nginx \
       -v /etc/nginx:/etc/nginx \
       -v /data/wwwroot:/data/wwwroot \
       -v /data/logs/nginx:/var/log/nginx \
       -p 80:80 -p 443:443 \
       --restart always \
       -l "ink.akawa.nginx" \
       -v /tmp:/tmp \
       --network lnmp --ip "172.20.0.2" nginx
```

前三行的作用就是启动一个临时的 Nginx 容器，目的是为了把其中的配置文件复制出来，最后再删除掉这个临时容器。最后一行就是真正启动 Nginx 容器的命令了。

# 部署 MySQL

```
read -s mysql_pass

docker run -itd --name mysql mariadb \
&& \
docker cp mysql:/etc/mysql /etc \
&& \
docker stop mysql && docker rm mysql \
&& \
docker run -itd --name mysql -p 3306:3306 -v /etc/mysql:/etc/mysql -v /data/mysql:/var/lib/mysql -v /tmp:/tmp -v /data/logs/mysql:/var/log/mysql --restart always --network lnmp --ip "172.20.0.3" -e MYSQL_ROOT_PASSWORD=$mysql_pass mariadb
```

前三行依旧是为了复制配置文件出来，第四行会要求你输入 MySQL 的 root 密码。第五行启动 MySQL 容器。

# 部署 PHP7

```
docker run -itd --name php7 ety001/php:7.2.14 \
&& \
docker cp php7:/etc/php7 /etc \
&& \
docker stop php7 && docker rm php7 \
&& \
docker run -itd --name php7 -v /etc/php7:/etc/php7 -v /data/wwwroot:/data/wwwroot -v /tmp:/tmp -v /data/logs/php7:/var/log/php7 --restart always --network lnmp --ip "172.20.0.4" ety001/php:7.2.14
```

前三行复制配置文件出来，第四行启动 PHP 容器。其中这里使用的镜像是我自己封装的，镜像里面写死了数据目录，如果你更改了数据目录，请自行修改 `/etc/php7/php-fpm.d/www.conf` 中的 `chdir` 参数值。

# 修改 Nginx 配置文件并进行测试

打开 `/etc/nginx/conf.d/default.conf` 文件，改成下面的样子

```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /data/wwwroot/default;          # <------ 修改这里为自己的目录
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        root /data/wwwroot/default;          # <------ 修改这里为自己的目录
        fastcgi_pass   172.20.0.4:9000;          # <------ 修改这里为正确的PHP解析地址
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;          # <------ 修改这里的路径
        include        fastcgi_params;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

修改好以后，执行 `docker exec nginx nginx -s reload` 重载 `nginx` 配置以使其生效。这时可以在 `/data/wwwroot/default` 目录下创建一个 `index.html` 的文件，然后浏览器访问下看看是否可以正常显示。再创建一个含有 `<?php   phpinfo();?>` 代码的 PHP 文件测试下 PHP 是否可用。

# 后续要添加网站

后续如果要增加新的网站，只需要在 `/data/wwwroot/` 中新建个文件夹存储网站文件，然后在 `/etc/nginx/conf.d/` 中增加新网站的配置文件，最后执行 `docker exec nginx nginx -s reload` 重载 nginx 配置即可生效。

如果要增加 Let's encrypted 的 SSL 的话，建议使用 [acme.sh](https://acme.sh) 中的 DNS 方法来注册证书，并把证书安装到 `/etc/nginx/ssl` 目录里，最后使用 `docker restart nginx` 来重启 Nginx 容器生效。这个后续可以再开篇文章写一下。

#### 完工！
