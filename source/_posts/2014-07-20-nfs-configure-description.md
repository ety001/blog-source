---
author: ety001
comments: true
date: 2014-07-20 16:21:02+00:00
layout: post
slug: nfs-configure-description
title: nfs的一些配置项介绍
wordpress_id: 2636
tags:
- Server&OS
---

简单理解rw就是可以写，前面要加上主机信息或者*表示所以的主机都可以写  
ro就是只读的表示  
至于权限方面 (就是小括号内的参数) 常见的参数则有：  
•        rw：read-write，可擦写的权限；  
•        ro：read-only，只读的权限；  
•        sync：数据同步写入到内存与硬盘当中；  
•        async：数据会先暂存于内存当中，而非直接写入硬盘！  
•        no_root_squash：  
登入 NFS 主机使用分享目录的使用者，如果是 root 的话，那么对于这个分享的目录来说，他就具有 root 的权限！ 这个项目『极不安全』，不建议使用！  
•        root_squash：  
在登入 NFS 主机使用分享之目录的使用者如果是 root 时，那么这个使用者的权限将被压缩成为匿名使用者，通常他的 UID 与 GID 都会变成 nobody(nfsnobody) 那个系统账号的身份；  
•        all_squash：  
不论登入 NFS 的使用者身份为何， 他的身份都会被压缩成为匿名使用者，通常也就是 nobody(nfsnobody) 啦！  
•        anonuid：  
anon 意指 anonymous (匿名者) 前面关于 *_squash 提到的匿名使用者的 UID 设定值，通常为 nobody(nfsnobody)，但是您可以自行设定这个 UID 的值！当然，这个 UID 必需要存在于您的 /etc/passwd 当中！  
•        anongid：同 anonuid ，但是变成 group ID 就是了！

