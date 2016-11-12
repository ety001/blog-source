---
author: ety001
comments: true
date: 2012-03-29 09:39:21+00:00
layout: post
slug: wordpress-wp-hive-plugin
title: 一个WordPress安装多个博客——wp-hive插件
wordpress_id: 2063
tags:
- Server&OS
---



标题的意思是：用一套WordPress源程序来驱动多个域名的WordPress博客。（ Multiple WordPress Blogs with a Single Installation）

工具：[wp-hive](http://wp-hive.com/)插件

好处：1.不用每次WordPress升级时都多个博客分开升级，费时。

2.节省空间，一套wp解压后也要4兆多呢，再加上插件，主题等。

3.充分利用一个数据库。

4.没想好。用这个插件的朋友给我们说说吧。

<!-- more -->

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝**使用方法**＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

友情提示：这类插件使用之前，请备份你的数据库！

请你遵照如下步骤进行，【千万】别颠倒了！

1.按照正常程序安装你的主博客（第一个博客）。

2.将wp-hive文件夹上传到/wp-content/plugins/目录。

3.将/wp-hive/db.php移动到/wp-content/目录。（不用激活插件之类的。）

4.马上打开你的主博客，wp-hive会自动配置数据库，添加wphive_config和wphive_hosts两个表。（记住一定是用你的主域名打开）

5.将第二个博客的域名绑定到第一个博客的目录。（可以是子域名，也可以是顶级域名）（其实这步你可以之前做好）

6.访问第二个域名，安装。（wp-hive自动会识别出这个是第二个博客的。）

7.在第二个博客的后台激活wp-hive插件。

重复5，6，7步，你就可以安装多个博客了。

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝**注意事项**＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

1.我说第五步可以先进行，但是千万别在第三和第四步之间就访问你的第二博客域名，那么wp-hive会将其记录为主域名了。

2.如果真的发生以上的情况，请删除数据库中的wphive_config和wphive_hosts表。

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝**特殊文件**＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

对于’sitemap.xml’, ‘robots.txt’, and ‘favicon.ico’这些文件，wp-hive会另外处理。

你要做的是：

1.别让这些文件出现在根目录里。

2.将每个域名所要使用的文件放在 `/wp-content/wp-hive/domainname.com/`  下即可。

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝**卸载**＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

不是要删除你的博客，请不要卸载哦。

1.禁用子博客里的wp-hive

2.删除数据库中的wphive_config和wphive_hosts表。（彻底卸载了。）


＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝**官方文档**＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝


1.[http://wp-hive.com/documentation/](http://wp-hive.com/documentation/)

2.WordPress.org下载地址：[http://wordpress.org/extend/plugins/wp-hive/](http://wordpress.org/extend/plugins/wp-hive/)

