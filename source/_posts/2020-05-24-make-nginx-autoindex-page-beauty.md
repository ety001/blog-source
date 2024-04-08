---
author: ety001
layout: post
title: 美化nginx的autoindex页面
tags:
  - steem
  - 经验
---

昨天发文说到 [我上线了一个Steem数据服务](/2020/05/24/a-new-backup-steem-data-server.html)，但是 `Nginx` 自带的 `autoindex` 功能的 `UI` 实在是丑爆了，那么怎么美化一下呢？

经过研究发现了三种方案。

# 方案一

在 `Nginx` 的配置中，有下面这两个配置项目：

```
add_before_body /xxx/file1.html;
add_after_body /xxx/file2.html;
```

这两个选项，可以在 `Nginx` 输出 `HTML` 之前和之后分别先输出你设定的文件。

这样我们可以在自定义我们的头部或者尾部，加入我们自己想要的样式表或者用 `js` 实现更牛逼的功能。

完整的配置大概是这样

```
    location / {
        root /data/wwwroot/steem;
        try_files $uri $uri/ =404;
        autoindex on;
        autoindex_localtime on;
        add_before_body /.beauty/top.html;
        add_after_body /.beauty/bot.html;
        autoindex_exact_size off;
    }
```

> 这里需要注意的是这两个参数的寻址，是基于 `root` 配置项的，也就是在上面的示例中， `.beauty` 目录是在 `/data/wwwroot/steem` 目录下面的。另外，如果你的自定义文件里有包含 `css` 和 `js` 文件，还需要有 `try_files` 参数配合一下。

这个功能唯一的不好处就是在查看网页源代码的时候，发现这两个参数的插入位置是在原来 `<html>` 之前和 `</html>` 之后。

这就让有代码洁癖的人感到很恶心。。。

# 方案二

该方案是第三方开发的插件：[https://www.nginx.com/resources/wiki/modules/fancy_index/](https://www.nginx.com/resources/wiki/modules/fancy_index/) 。

鉴于我使用的是 `Docker` 版的 `Nginx`，要想安装个第三方插件，我还要自己编译打包，很麻烦，所以这个方案就没有尝试。

不过看文档说明，应该是跟方案一思路一样，只不过多加了几个注入位置吧。

# 方案三

目前，我使用的是方案三。这个方案则是依赖的 `Nginx` 的这个参数 `autoindex_format`。

这个参数可以规定输出信息格式，默认是 `html`，我们可以设置这里为 `json`。这样就变成了一个 `api` 接口。

然后自己去开发一套自己喜欢的前端，调用这个 `api` 接口就可以了。

这里我从网上找了一套现成的 `UI` 来使用，地址：[https://github.com/spring-raining/pretty-autoindex](https://github.com/spring-raining/pretty-autoindex) 。

在 `Nginx` 配置这块，我没有按照这个库的方法配置两个 `Server` 模块，我是分成了两个 `location` 来实现。

参考配置如下：

```
    location / {
        root    /data/wwwroot/pretty-autoindex/dist;
        index   index.html;
        autoindex off;
    }

    location /data {
        alias  /data/wwwroot/steem;
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

通过 `alias` 实现 `/data` 为 `api` 接口，来获取目录结构信息。

经过一下午的折腾，最终终于让 `autoindex` 页面看上去不是那么丑了，并且还加入了 `Google Analytics`。

以后如果还有什么想搞的好玩的东西，也可以加入到里面了。

---
#### 好用不贵的VPS
* [1核1G内存18G硬盘1Gbps带宽1000GB流量/月，洛杉矶机房，$23/年](https://my.racknerd.com/aff.php?aff=856&pid=207)
* [2核2G内存25G硬盘1Gbps带宽3000GB流量/月，洛杉矶机房，$33/年](https://my.racknerd.com/aff.php?aff=856&pid=208)
* [1核1G内存20G硬盘30Mbps带宽600GB流量/月，去程163直连 + 回程三网CN2_GIA，日本机房，年付方案优惠码：Friday_1，299元/年](https://kvm.yunserver.com/aff.php?aff=140&pid=79) , 测速链接: [http://118.107.12.12/speedtest/](http://118.107.12.12/speedtest/)
* [xxxx 更多主机 xxxx](https://1hour.win/)
