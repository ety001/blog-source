---
author: ety001
comments: true
date: 2012-02-02 05:44:35+00:00
layout: post
slug: htaccess-disabled-cause
title: .htaccess未生效可能的原因
wordpress_id: 1925
tags:
- 理论
- 后端
- Server&OS
---

.htaccess文件如果没有生效的话，那么很可能是你的虚拟机配置信息中的AllowOverride 配置项的参数是None（默认是None），把这个设置为All 即可。

下面是AllowOverride 指令的相关信息：

**说明：**确定允许存在于`.[htaccess](http://www.jzxue.com/tag/htaccess/)`文件中的指令类型

**语法：**[AllowOverride](http://www.jzxue.com/tag/AllowOverride/) All|None|directive-type[directive-type] ...

当[服务器](http://server.jzxue.com/)发现一个`.htaccess`文件(由`AccessFileName`指定)时，它需要知道在这个文件中声明的哪些指令能覆盖在此之前指定的配置指令。



<!-- more -->


### 仅允许存在于<Directory>配置段


`AllowOverride`仅在不包含正则表达式的`<Directory>`配置段中才是有效的。在`<Location>`,`<DirectoryMatch>`, `<Files>`配置段中都是无效的。

如果此指令被设置为`None` ，那么.htaccess文件将被完全忽略。事实上，服务器根本不会读取`.htaccess`文件。

当此指令设置为 `All`时，所有具有".htaccess"作用域的指令都允许出现在`.htaccess`文件中。

`directive-type` 可以是下列各组指令之一：

AuthConfig
    允许使用与认证授权相关的指令(`AuthDBMGroupFile`, `AuthDBMUserFile`, `AuthGroupFile`,`AuthName`, `AuthType`, `AuthUserFile`, `Require`, 等)。
FileInfo
    允许使用控制文档类型的指令(`DefaultType`, `ErrorDocument`, `ForceType`, `LanguagePriority`,`SetHandler`, `SetInputFilter`, `SetOutputFilter`, `mod_mime`中的 Add* 和 Remove* 指令等等)、控制文档元数据的指令(`Header`, `RequestHeader`, `SetEnvIf`, `SetEnvIfNoCase`, `BrowserMatch`,`CookieExpires`, `CookieDomain`, `CookieStyle`, `CookieTracking`, `CookieName`)、`mod_rewrite`中的指令(`RewriteEngine`, `RewriteOptions`, `RewriteBase`, `RewriteCond`, `RewriteRule`)和`mod_actions`中的`Action`指令。
Indexes
    允许使用控制目录索引的指令(`AddDescription`, `AddIcon`, `AddIconByEncoding`, `AddIconByType`,`DefaultIcon`, `DirectoryIndex`, `FancyIndexing`, `HeaderName`, `IndexIgnore`, `IndexOptions`,`ReadmeName`, 等)。
Limit
    允许使用控制主机访问的指令(`Allow`, `Deny`, `Order`)。
Options[=Option,...]
    允许使用控制指定目录功能的指令(`Options`和`XBitHack`)。可以在等号后面附加一个逗号分隔的(无空格的)`Options`选项列表，用来控制允许`Options`指令使用哪些选项。
例如：以下指令只允许在`.htaccess`中使用`AuthConfig`和`Indexes`组的指令：


`AllowOverride AuthConfig Indexes`


不在这两组中的指令将会导致服务器产生一个内部错误。

