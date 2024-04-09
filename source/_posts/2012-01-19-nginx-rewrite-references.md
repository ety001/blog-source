---
author: ety001
comments: true
date: 2012-01-19 02:25:52
layout: post
title: 'nginx rewrite 参考资料'
wordpress_id: 1871
tags:
- Server&OS
---

nginx rewrite 正则表达式匹配，其中：
* ~ 为区分大小写匹配


* ~* 为不区分大小写匹配

* `!~`和`!~*`分别为区分大小写不匹配及不区分大小写不匹配

文件及目录匹配，其中：
* -f和!-f用来判断是否存在文件

* -d和!-d用来判断是否存在目录

* -e和!-e用来判断是否存在文件或目录

* -x和!-x用来判断文件是否可执行

flag标记有：

* last 相当于Apache里的[L]标记，表示完成rewrite

* break 终止匹配, 不再匹配后面的规则

* redirect 返回302临时重定向 地址栏会显示跳转后的地址

* permanent 返回301永久重定向 地址栏会显示跳转后的地址

一些可用的全局变量有，可以用做条件判断(待补全)

```
$args

$content_length

$content_type

$document_root

$document_uri

$host

$http_user_agent

$http_cookie

$limit_rate

$request_body_file

$request_method

$remote_addr

$remote_port

$remote_user

$request_filename

$request_uri

$query_string

$scheme

$server_protocol

$server_addr

$server_name

$server_port

$uri
```

多目录转成参数

```
abc.domian.com/sort/2 => abc.domian.com/index.php?act=sort&name=abc&id=2
if ($host ~* (.*)\.domain\.com) {
    set $sub_name $1;
    rewrite ^/sort\/(\d+)\/?$ /index.php?act=sort&cid=$sub_name&id=$1 last;
}
```

目录对换

```
/123456/xxxx -> /xxxx?id=123456
rewrite ^/(\d+)/(.+)/ /$2?id=$1 last;
```

例如下面设定nginx在用户使用ie的使用重定向到/nginx-ie目录下：

```
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /nginx-ie/$1 break;
}
```

目录自动加“/”

```
if (-d $request_filename){
    rewrite ^/(.*)([^/])$ http://$host/$1$2/ permanent;
}
```

禁止htaccess

```
location ~/\.ht {
    deny all;
}
```

禁止多个目录

```
location ~ ^/(cron|templates)/ {
    deny all;
    break;
}
```

禁止以/data开头的文件
可以禁止/data/下多级目录下.log.txt等请求;

```
location ~ ^/data {
    deny all;
}
```

禁止单个目录
不能禁止.log.txt能请求

```
location /searchword/cron/ {
    deny all;
}
```

禁止单个文件

```
location ~ /data/sql/data.sql {
    deny all;
}
```

给favicon.ico和robots.txt设置过期时间;
这里为favicon.ico为99天,robots.txt为7天并不记录404错误日志

```
location ~(favicon.ico) {
    log_not_found off;
    expires 99d;
    break;
}

location ~(robots.txt) {
    log_not_found off;
    expires 7d;
    break;
}
```

设定某个文件的过期时间;这里为600秒，并不记录访问日志

```
location ^~ /html/scripts/loadhead_1.js {
    access_log off;
    root /opt/lampp/htdocs/web;
    expires 600;
    break;
}
```

文件反盗链并设置过期时间
这里的return 412 为自定义的http状态码，默认为403，方便找出正确的盗链的请求

```
rewrite ^/ http://leech.onexin.com/leech.gif; #显示一张防盗链图片
access_log off;#不记录访问日志，减轻压力
expires 3d;#所有文件3天的浏览器缓存
location ~* ^.+\.(jpg|jpeg|gif|png|swf|rar|zip|css|js)$ {
    valid_referers none blocked *.onexin.com *.onexin.net localhost 208.97.167.194;
    if ($invalid_referer) {
        rewrite ^/ http://leech.onexin.com/leech.gif;
        return 412;
        break;
    }
    access_log off;
    root /opt/lampp/htdocs/web;
    expires 3d;
    break;
}
```

只充许固定ip访问网站，并加上密码

```
root /opt/htdocs/www;
allow 8.8.8.8;
deny all;
auth_basic “ONEXIN_ADMIN”;
auth_basic_user_file htpasswd;
```

将多级目录形式转成一个文件形式，增强seo效果

```
/job-123-456-789.html 指向/job/123/456/789.html
rewrite ^/job-([0-9]+)-([0-9]+)-([0-9]+)\.html$ /job/$1/$2/jobshow_$3.html last;
```

将根目录下某个文件夹指向2级目录
如/shanghaijob/ 指向 /area/shanghai/
如果你将last改成permanent，那么浏览器地址栏显是/location/shanghai/

```
rewrite ^/([0-9a-z]+)job/(.*)$ /area/$1/$2 last;
```

上面例子有个问题是访问/shanghai 时将不会匹配

```
rewrite ^/([0-9a-z]+)job$ /area/$1/ last;
rewrite ^/([0-9a-z]+)job/(.*)$ /area/$1/$2 last;
```

这样/shanghai 也可以访问了，但页面中的相对链接无法使用，
如./list_1.html真实地址是/area/shanghia/list_1.html会变成/list_1.html,导至无法访问。
那我加上自动跳转也是不行咯
(-d $request_filename)它有个条件是必需为真实目录，而我的rewrite不是的，所以没有效果

```
if (-d $request_filename){
    rewrite ^/(.*)([^/])$ http://$host/$1$2/ permanent;
}
```

知道原因后就好办了，让我手动跳转吧

```
rewrite ^/([0-9a-z]+)job$ /$1job/ permanent;
rewrite ^/([0-9a-z]+)job/(.*)$ /area/$1/$2 last;
```

文件和目录不存在的时重定向：

```
if (!-e $request_filename) {
    proxy_pass http://127.0.0.1;
}
```

域名跳转

```
server

{
    listen 80;
    server_name jump.onexin.com;
    index index.html index.htm index.php;
    root /opt/lampp/htdocs/www;
    rewrite ^/ http://www.onexin.com/;
    access_log off;
}
```

多域名转向

```
server_name www.onexin.com www.onexin.net;
index index.html index.htm index.php;
root /opt/lampp/htdocs;
if ($host ~ “onexin\.net”) {
    rewrite ^(.*) http://www.onexin.com$1 permanent;
}
```

三级域名跳转

```
if ($http_host ~* “^(.*)\.i\.onexin\.com$”) {
    rewrite ^(.*) http://top.onexin.com$1;
    break;
}
```

域名镜向

```
server
{
    listen 80;
    server_name mirror.onexin.com;
    index index.html index.htm index.php;
    root /opt/lampp/htdocs/www;
    rewrite ^/(.*) http://www.onexin.com/$1 last;
    access_log off;
}
```

某个子目录作镜向

```
location ^~ /job {
    rewrite ^.+ http://job.onexin.com/ last;
    break;
}
```

转载请注明出处：[http://www.onexin.net/nginx-rewrite-references/](http://www.onexin.net/nginx-rewrite-references/)

