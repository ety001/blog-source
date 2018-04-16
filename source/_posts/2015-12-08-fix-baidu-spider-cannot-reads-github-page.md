---
author: ety001
layout: post
title: 解决百度爬虫无法爬取github page问题
tags:
- 网站日志
- Server&OS
---
最近发现百度已经不收录我的博客了，感觉很奇怪，搞了一个星期的SEO都失败了，
最后在百度站长工具里，看到经常抓取失败，于是放到搜索引擎里搜了下，发现原来是github屏蔽了百度爬虫。

于是只能自己利用DNSPod来搭建个面向百度爬虫的子站了。

首先登陆自己的vps，然后安装ruby和gem，

```
yum install ruby ruby-devel rubygems
```

安装jekyll

```
gem install jekyll
```

结果报错，说ruby版本不够，妹的。。。卸载掉，从ruby官网下载源代码，进行编译安装，

```
#这里就只写编译命令了，基本依赖自己搞定吧
./configure --prefix=/usr/local --disable-install-doc --with-opt-dir=/usr/local/lib
make && make isntall
```

再次安装jekyll，成功，再安装各种扩展

```
gem install jekyll-gist jekyll-paginate redcarpet
pip install pygments
gem install pygments.rb
```

从github上pull博客的代码，启动jekyll，测试下看看能不能访问。
由于我这台vps上开着nginx，所以jekyll是启动在4000端口上了，那么在nginx上做个反向代理即可，
可以参照我之前写的这篇博文来配置：<http://www.domyself.me/2015/03/09/nginx-proxy-config.html>.

接下来再配置crontab，让系统能自己pull代码

```
crontab -e
*/1 * * * * cd /home/wwwroot/blog; git pull > /dev/null 2>&1;
```

  这里有个小插曲，由于我的vps空间是5G的，安装ruby的时候提示空间不足，
  查了下发现，/var/spool/clientmqueue目录有2.9G之大，原因就是由于没有开启sendmail，
  crontab执行后的结果输出无法发送邮件，就全部dump到这里了，解决方案就是在写crontab命令的时候，
  如果需要输出结果，就指定到一个文件去，否则就直接用 `>2>&1` 丢掉即可。

最后一步，在DNSPod里面增加新的记录，记的把线路类型选择为 `百度` 。

这样再用百度抓取下，就成功了。

