---
author: ety001
layout: post
title: 'Build a dockerized LNMP environment by portainer / 通过portainer搭建docker化的LNMP环境'
tags:
- 教程
---

[Portainer](https://portainer.io) is a simple UI management for docker. It's easy to use and all your resources will show you friendly. It's very light especially using a VPS which has only 512MB RAM.

In this tutorial, we will make a LNMP server over the docker container by Portainer.

# What Will I Learn?

- You will learn how to setup `portainer`
- You will learn how to create a custom network with the `docker`
- You will learn how to create a `container`

# Requirements

- Ubuntu 16.04 (64-bit)
- Base bash knowledge
- Base docker knowledge
- Built a normal LNMP environment before

# Difficulty

- Intermediate

# Tutorial Contents

## Setup Portainer

1.Create a volume to save the portainer data. You also can bind a folder.
```
$ docker volume create portainer_data
```

2.Run the `Portainer` docker.
```
$ docker run -d -p 9000:9000 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart always portainer/portainer
```

* `-d` means run as daemon
* `-p 9000:9000` means making a port map. Portainer needs port 9000 opening.
* `-v /var/run/docker.sock:/var/run/docker.sock` This parameter is important if you want portainer to manage your local docker.

3.Visit `http://localhost:9000` in your browser and input your username and password to create the administrator user.

![1.png](https://steemitimages.com/DQmT9JTGErJC2n36RdZd4Lm2TLZHRDexXob8wBtqfL7yjWE/1.png)

4.In next step select the `Local` option and press `Connect` button to finish setup.

![2.png](https://steemitimages.com/DQmYPejiNcH4D2eSP5SyDFv4mV12NJ2wd8oTyHHTmGCHf4r/2.png)

5.When you see the main page, the installation is over.

![3.png](https://steemitimages.com/DQmbux3arsXknHxnaFuGX2a7N9K4h7NR6VQgEo91QRo6JqA/3.png)

## Create a new network

The [container link](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/)  is out of date now. The portainer doesn't support the container link any more. So we need to create a new bridge network and bind  static IPs to every container we create. Then each container can communicate with each other through the static IPs.

1.Get in the `Networks` page and click the `Add network` button.

![4.png](https://steemitimages.com/DQmQ7y7TZ9Bvik92P25aZgqi4rBgHGZG1NK5GQGfkM6t3hg/4.png)

2.Input the required information like the snapshot and then click the `Create the network` button.

![5.png](https://steemitimages.com/DQmcr61fzmxMr56qj44oLjLntR5Hb2qp8afpntUW4xbjHr8/5.png)

## Add MariaDB container

In this tutorial, we use the `App Template` to create the MariaDB container.

1.Create a folder to storage the MariaDB database file

```
$ sudo mkdir -p /data/mariadb
```

2.Enter the `App Template` page and select the `MariaDB` option.

![6.png](https://steemitimages.com/DQmRdiSeJMQvHNDu84TAPpqP2GUuTy4cTENnfuRSMD9DddA/6.png)

3.Input required information with snapshot (When you clicked the `Deploy the container` button, you need waiting a while. Because docker is pulling the portainer image.)

![7.png](https://steemitimages.com/DQmX9tReX9ism2Uj4BXVLviJrWpf6sgASivb2iet7p4mrQ5/7.png)

4.Because the `App Template` doesn't set the static IP, we need set it with editing the container configurations manually. Open the container detail page:

![8.png](https://steemitimages.com/DQmTBfjkF4ArnAzH1G3NAk7Zignj8hgMc88ekZ6yr2XAR3U/8.png)

5.Click the `Duplicate/Edit` button

![9.png](https://steemitimages.com/DQmQaLzKXbKv8HtjRPLtXHKyakF2WB6uHemhFHWX4Wb41M2/9.png)

6.Find the `Advanced container settings` section, select the `Network` tab, input a static IP into the `IPv4 address`, click `Deploy the container`.

![10.png](https://steemitimages.com/DQmUVXxDHssU3dPq5eSVX6mV3dH3RBruKzWVNJFsLMewpcS/10.png)

7.Portainer will mention you whether if to replace the original container. Click `Replace`.

![11.png](https://steemitimages.com/DQmZ2Ffs8trHvqLtCuqBKNccZbyiPkPQzDzcPTXjvxkcX8C/11.png)

8.If we want to connect to the database on the host, we can run this command

```
$ docker run -it --rm --name mariadb_client --network mynet mariadb /usr/bin/mysql -h 172.20.0.2 -uroot -p
```

- `--network mynet` is needed. You must put the client container into your MariaDB server container's network.
- `--rm` will destroy this client container when it ends.

OR

```
$ docker exec -it mariadb /usr/bin/mysql -h 172.20.0.2 -uroot -p
```

## Add nginx container

In this example, we use the `App Template` to create the nginx container.

1.Deploy a nginx container from `App Template` and bind  container `/data` to host `/data`.

![12.png](https://steemitimages.com/DQmYogHmVTx7PPR1Ecr17V6NLAQJgkrf7WMrMvYhDGQkQZq/12.png)

2.Open the `Containers` list and find the container you just created and click the third icon to get in the container console.

![13.png](https://steemitimages.com/DQmbAbmCCHRNX9T9fmdpEYSH5QDUFFdGGCcZfXkuB1CH1gE/13.png)

3.Run this command to copy nginx configurations to your host.

```
# cp -r /etc/nginx /data
```

![14.png](https://steemitimages.com/DQmVUK9h2GTjj2LMFURrGC1seWCp37vy551iYQaom8B29ki/14.png)

4.On the host terminal run this command

```
$ sudo cp -r /data/nginx /etc/nginx
```

5.Edit the exist nginx container with these snapshots

![16.png](https://steemitimages.com/DQmVurkWMPWeeyREZHrZ6LSEdrrZ8fWVN3onKFHK5vSAWq4/16.png)

![17.png](https://steemitimages.com/DQmYL7XGcDgZMrRRQzoXrzt7jdfjMXdYg8kGoGFSrQ6K6Ve/17.png)

![18.png](https://steemitimages.com/DQmf5LhNHxjErnCahun7yN1VCcaUHhqo45d6HJvjjcEX7LR/18.png)

## Add a php-fpm7 container

1.Create a php-fpm7 image
I refer to this [repo](https://github.com/Yavin/docker-alpine-php-fpm) to create the image. This image is based on Alpine so it's light enough.

```
$ git clone https://github.com/Yavin/docker-alpine-php-fpm.git
$ cd docker-alpine-php-fpm
```

2.Edit the `php-fpm.conf`:

```
[www]
user = nobody
group = nobody
listen = [::]:9000
chdir = /data/wwwroot  # Change the chdir
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
catch_workers_output = Yes
```

3.Build image

```
$ docker build -t php-fpm7:latest .
```

4.Add a new container

![19.png](https://steemitimages.com/DQmeYjkN7y2ycQvTur4JfXXmffZWc97rHwXUcYAmo8bqTCD/19.png)

5.Configure step by step with thees snapshots:

![20.png](https://steemitimages.com/DQmNdRgfEF7xbg7KHenVoQpVvQK3kbCQ8w2LdwXgjUdDgds/20.png)

![21.png](https://steemitimages.com/DQmXRr5jjH2JiYdXXYkK5rp12uXPj3Bq7DPscUvAwtpGCub/21.png)

![22.png](https://steemitimages.com/DQmTGq6FY68GDZwgYa7pe1KBA6ZDeVTnWV8sspNBnVneFXy/22.png)

![23.png](https://steemitimages.com/DQmXgjisbnJK1WBKQd9cZ9T1PjZpixQ4LcvNpt3LPLENgZB/23.png)

## Final Config

1.At last, we need to edit the `/etc/nginx/conf.d/default.conf` on host like this:

```
$ sudo vim /etc/nginx/conf.d/default.conf

server {
    listen       80;
    server_name  localhost;

    location / {
        root   /data/wwwroot/default;
        index  index.html index.htm index.php;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ \.php$ {
        root           /data/wwwroot/default;
        fastcgi_pass   172.20.0.4:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

}
```

2.Create `index.php` for testing

```
$ sudo mkdir /data/wwwroot/default
$ sudo echo "<?php phpinfo();?>" > /data/wwwroot/default/index.php
```

3.Restart nginx container

![24.png](https://steemitimages.com/DQmZRZdRXGXHYxYrLHHbHF8WWiacefJ6AfmHGSAMJA3zthD/24.png)

## Visit the test page

![25.png](https://steemitimages.com/DQmTo7GRPcZzWLvdpBNhi289sFvpujVPgThhR78vzjp6VuH/25.png)

# Summary

Using dockerized apps is a trend. If you want to run dockerized apps on your personal VPS, Portainer is a good choice. It's easy and light.

---

[Portainer](https://portainer.io) 是一个为  `Docker`  设计的简易 `UI` 管理界面. 通过 `Portainer` 可以轻松管理你的 `Docker` 的各种资源. 它是轻量级的, 你甚至可以在一台只有 `512MB` 内存的 `VPS` 上部署使用.

在这个教程中, 我们将通过使用 `Portainer` 部署一套 `LNMP` 环境, 来学习如何使用 `Portainer`.

# 将会学到?

- 你将学到如何安装 `Portainer`
- 你将学到如何在 `Portainer` 中创建自定义的网络
- 你将学到如何用 `Portainer` 创建容器

# 准备工作

- Ubuntu 16.04 (64-bit)
- `Bash` 基础知识
- `Docker` 基础知识
- 曾搭建过普通环境的 `LNMP`

# 困难度

- 中等

# 教程内容

## 安装 Portainer

1.创建一个卷来存储 `Portainer` 的数据, 你同样也可以使用主机的目录来存储
```
$ docker volume create portainer_data
```

2.使用 `Docker` 运行 `Portainer`.
```
$ docker run -d -p 9000:9000 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --restart always portainer/portainer
```

* `-d` 已后台方式运行
* `-p 9000:9000` 映射容器9000端口.
* `-v /var/run/docker.sock:/var/run/docker.sock` 映射出 `docker socket` 使 `Portainer` 容器可以管理 `Docker`.

3.使用浏览器访问 `http://localhost:9000` 进入安装界面, 输入用户名和密码完成管理员创建.

![1.png](https://steemitimages.com/DQmT9JTGErJC2n36RdZd4Lm2TLZHRDexXob8wBtqfL7yjWE/1.png)

4.选择 `Local` 选项后点击 `Connect` 按钮完成安装.

![2.png](https://steemitimages.com/DQmYPejiNcH4D2eSP5SyDFv4mV12NJ2wd8oTyHHTmGCHf4r/2.png)

5.当你看到管理主页的时候, 安装完成.

![3.png](https://steemitimages.com/DQmbux3arsXknHxnaFuGX2a7N9K4h7NR6VQgEo91QRo6JqA/3.png)

## 创建新的网络

[container link](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/)  连接容器的方法已经过时了, 并且 `Portainer` 也不支持 `link`. 因此为了让容器间可以通讯, 我们需要建立自定义网络, 并手动分配静态IP给每个容器.

1.进入 `Networks` 页面并点击 `Add network` 按钮.

![4.png](https://steemitimages.com/DQmQ7y7TZ9Bvik92P25aZgqi4rBgHGZG1NK5GQGfkM6t3hg/4.png)

2.按照截图提示输入必要信息并点击 `Create the network` 按钮.

![5.png](https://steemitimages.com/DQmcr61fzmxMr56qj44oLjLntR5Hb2qp8afpntUW4xbjHr8/5.png)

## 添加 MariaDB 容器

在这个教程中我们使用 `App Template` 来创建 `MariaDB` 容器.

1.创建一个目录来存储数据库数据

```
$ sudo mkdir -p /data/mariadb
```

2.进入 `App Template` 页面后选择 `MariaDB` 选项.

![6.png](https://steemitimages.com/DQmRdiSeJMQvHNDu84TAPpqP2GUuTy4cTENnfuRSMD9DddA/6.png)

3.按照截图填写配置信息 (当你点击完 `Deploy the container` 按钮后, 你需要等待一段时间, 因为 `Docker` 正在后台帮你拉取镜像.)

![7.png](https://steemitimages.com/DQmX9tReX9ism2Uj4BXVLviJrWpf6sgASivb2iet7p4mrQ5/7.png)

4.由于 `App Template` 没有设置静态IP, 我们需要手动配置下. 打开容器的详情页:

![8.png](https://steemitimages.com/DQmTBfjkF4ArnAzH1G3NAk7Zignj8hgMc88ekZ6yr2XAR3U/8.png)

5.点击 `Duplicate/Edit` 按钮

![9.png](https://steemitimages.com/DQmQaLzKXbKv8HtjRPLtXHKyakF2WB6uHemhFHWX4Wb41M2/9.png)

6.找到 `Advanced container settings` 部分, 选择 `Network` 选项卡, 在 `IPv4 address` 中输入一个静态IP, 点击 `Deploy the container` 完成.

![10.png](https://steemitimages.com/DQmUVXxDHssU3dPq5eSVX6mV3dH3RBruKzWVNJFsLMewpcS/10.png)

7.`Portainer` 将会提示你是否替换原有容器. 点击 `Replace`.

![11.png](https://steemitimages.com/DQmZ2Ffs8trHvqLtCuqBKNccZbyiPkPQzDzcPTXjvxkcX8C/11.png)

8.如果想在主机上连接访问数据库, 可以执行下面的命令:

```
$ docker run -it --rm --name mariadb_client --network mynet mariadb /usr/bin/mysql -h 172.20.0.2 -uroot -p
```

- `--network mynet` 这个选项是必须的, 你必须把客户端容器放置在服务端容器的网络中才可以访问到.
- `--rm` 这个配置可以使这个容器在执行完毕后立即删除.

或者

```
$ docker exec -it mariadb /usr/bin/mysql -h 172.20.0.2 -uroot -p
```

## 创建 Nginx 容器

在本教程中我们使用 `App Template` 创建 `Nginx` 容器.

1.从 `App Template` 中部署一个 `Nginx` 容器, 并把容器中的 `/data` 绑定到主机的 `/data` 上.

![12.png](https://steemitimages.com/DQmYogHmVTx7PPR1Ecr17V6NLAQJgkrf7WMrMvYhDGQkQZq/12.png)

2.打开 `Containers` 列表, 找到你刚才创建的容器并点击第三个图标, 进入容器的 `console` 界面.

![13.png](https://steemitimages.com/DQmbAbmCCHRNX9T9fmdpEYSH5QDUFFdGGCcZfXkuB1CH1gE/13.png)

3.执行下面的命令, 把容器中 `Nginx` 的配置文件复制到主机下.

```
# cp -r /etc/nginx /data
```

![14.png](https://steemitimages.com/DQmVUK9h2GTjj2LMFURrGC1seWCp37vy551iYQaom8B29ki/14.png)

5.在主机上执行下面的命令

```
$ sudo cp -r /data/nginx /etc/nginx
```

6.按照截图的指示修改容器配置, 完成 `Nginx` 容器部署

![16.png](https://steemitimages.com/DQmVurkWMPWeeyREZHrZ6LSEdrrZ8fWVN3onKFHK5vSAWq4/16.png)

![17.png](https://steemitimages.com/DQmYL7XGcDgZMrRRQzoXrzt7jdfjMXdYg8kGoGFSrQ6K6Ve/17.png)

![18.png](https://steemitimages.com/DQmf5LhNHxjErnCahun7yN1VCcaUHhqo45d6HJvjjcEX7LR/18.png)

## 创建 php-fpm7 容器

1.创建一个 `php-fpm7` 的镜像
我参考了这个 [repo](https://github.com/Yavin/docker-alpine-php-fpm) 来创建镜像. 这个镜像的好处是基于 `Alpine` 创建, 非常轻量.

```
$ git clone https://github.com/Yavin/docker-alpine-php-fpm.git
$ cd docker-alpine-php-fpm
```

2.修改 `php-fpm.conf`:

```
[www]
user = nobody
group = nobody
listen = [::]:9000
chdir = /data/wwwroot  # 修改 chdir
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
catch_workers_output = Yes
```

3.构建镜像

```
$ docker build -t php-fpm7:latest .
```

4.创建新容器

![19.png](https://steemitimages.com/DQmeYjkN7y2ycQvTur4JfXXmffZWc97rHwXUcYAmo8bqTCD/19.png)

5.按照截图一步一步操作, 完成容器创建:

![20.png](https://steemitimages.com/DQmNdRgfEF7xbg7KHenVoQpVvQK3kbCQ8w2LdwXgjUdDgds/20.png)

![21.png](https://steemitimages.com/DQmXRr5jjH2JiYdXXYkK5rp12uXPj3Bq7DPscUvAwtpGCub/21.png)

![22.png](https://steemitimages.com/DQmTGq6FY68GDZwgYa7pe1KBA6ZDeVTnWV8sspNBnVneFXy/22.png)

![23.png](https://steemitimages.com/DQmXgjisbnJK1WBKQd9cZ9T1PjZpixQ4LcvNpt3LPLENgZB/23.png)

## 最后的配置

1.最后我们需要修改下主机上的 `Nginx` 配置文件 `/etc/nginx/conf.d/default.conf`:

```
$ sudo vim /etc/nginx/conf.d/default.conf

server {
    listen       80;
    server_name  localhost;

    location / {
        root   /data/wwwroot/default;
        index  index.html index.htm index.php;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ \.php$ {
        root           /data/wwwroot/default;
        fastcgi_pass   172.20.0.4:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

}
```

2.创建一个测试首页 `index.php`

```
$ sudo mkdir /data/wwwroot/default
$ sudo echo "<?php phpinfo();?>" > /data/wwwroot/default/index.php
```

3.重启 `Nginx` 容器

![24.png](https://steemitimages.com/DQmZRZdRXGXHYxYrLHHbHF8WWiacefJ6AfmHGSAMJA3zthD/24.png)

## 在浏览器中访问测试页面

![25.png](https://steemitimages.com/DQmTo7GRPcZzWLvdpBNhi289sFvpujVPgThhR78vzjp6VuH/25.png)

# 总结

使用 `Docker` 化应用是一个趋势. 如果你想在你的个人 `VPS` 上运行 `Docker` 化的应用, `Portainer` 是一个不错的选择, 因为它使用简单并且轻量.