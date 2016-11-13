---
author: ety001
comments: true
date: 2013-09-01 09:18:27+00:00
layout: post
slug: message-system-design
title: 群发“站内信”的实现
wordpress_id: 2437
tags:
- 编程语言
- 后端
---

转自：http://www.cnblogs.com/grenet/archive/2010/03/08/1680655.html（文章后面的评论也不错）

在很多网站系统（如CMS系统，SNS系统等），都有“站内信”的功能。

“站内信”不同于电子邮件，电子邮件通过专门的邮件服务器发送、保存。而“站内信”是系统内的消息，说白了，“站内信”的实现，就是通过数据库插入记录来实现的。

“站内信”有两个基本功能。一：点到点的消息传送。用户给用户发送站内信；管理员给用户发送站内信。二：点到面的消息传送。管理员给用户（指定满足某一条件的用户群）群发消息。点到点的消息传送很容易实现，本文不再详述。下面将根据不同的情况，来说说“站内信”的群发是如何实现的。

第一种情况，站内的用户是少量级别的。（几十到上百）

这种情况，由于用户的数量非常少，因此，没有必要过多的考虑数据库的优化，采用简单的表格，对系统的设计也来的简单，后期也比较容易维护，是典型的用空间换时间的做法。

数据库的设计如下：表名：Message

ID：编号；SendID：发送者编号；RecID：接受者编号（如为0，则接受者为所有人）；Message：站内信内容；Statue：站内信的查看状态；PDate：站内信发送时间；

如果，某一个管理员要给所有人发站内信，则先遍历用户表，再按照用户表中的所有用户依次将站内信插入到Message表中。这样，如果有56个用户，则群发一条站内信要执行56个插入操作。这个理解上比较简单，比较耗损空间。

某一个用户登陆后，查看站内信的语句则为：

Select * FROM Message Where RecID=‘ID’ OR RecID=0

第二种情况，站内的用户中量级别的（上千到上万）。

如果还是按照第一种情况的思路。那发一条站内信的后果基本上就是后台崩溃了。因为，发一条站内信，得重复上千个插入记录，这还不是最主要的，关键是上千乃至上万条记录，Message字段的内容是一样的，而Message有大量的占用存储空间。比方说，Message字段有100个汉字，占用200个字节，那么5万条，就占用200×50000=10000000个字节=10M。简单的一份站内信，就占用10M，这还让不让人活了。

因此，将原先的表格拆分为两个表，将Message的主体放在一个表内，节省空间的占用

数据库的设计如下：

表名：Message

ID：编号；SendID：发送者编号；RecID：接受者编号（如为0，则接受者为所有人）；MessageID：站内信编号；Statue：站内信的查看状态；

表名：MessageText

ID：编号；Message：站内信的内容；PDate：站内信发送时间；

在管理员发一封站内信的时候，执行两步操作。先在MessageText表中，插入站内信的内容。然后在Message表中给所有的用户插入一条记录，标识有一封站内信。

这样的设计，将重复的站内信的主体信息（站内信的内容，发送时间）放在一个表内，大量的节省存储空间。不过，在查询的时候，要比第一种情况来的复杂。

第三种情况，站内的用户是大量级的（上百万），并且活跃的用户只占其中的一部分。

大家都有这样的经历，某日看一个网站比较好，一时心情澎湃，就注册了一个用户。过了一段时间，由于种种原因，就忘记了注册时的用户名和密码，也就不再登陆了。那么这个用户就称为不活跃的。从实际来看，不活跃的用户占着不小的比例。

我们以注册用户2百万，其中活跃用户只占其中的10%。

就算是按照第二种的情况，发一封“站内信”，那得执行2百万个插入操作。但是其中的有效操作只有10%，因为另外的90%的用户可能永远都不会再登陆了。

在这种情况下，我们还得把思路换换。

数据库的设计和第二种情况一样：

表名：Message

ID：编号；SendID：发送者编号；RecID：接受者编号（如为0，则接受者为所有人）；MessageID：站内信编号；Statue：站内信的查看状态；

表名：MessageText

ID：编号；Message：站内信的内容；PDate：站内信发送时间；

管理员发站内信的时候，只在MessageText插入站内信的主体内容。Message里不插入记录。

那么，用户在登录以后，首先查询MessageText中的那些没有在Message中有记录的记录，表示是未读的站内信。在查阅站内信的内容时，再将相关的记录插入到Message中。

这个方法和第二种的比较起来。如果，活跃用户是100%。两者效率是一样的。而活跃用户的比例越低，越能体现第三种的优越来。只插入有效的记录，那些不活跃的，就不再占用空间了。

以上，是我对群发“站内信”的实现的想法。也欢迎各位提出自己的建议，大家互相借鉴，共同进步。
