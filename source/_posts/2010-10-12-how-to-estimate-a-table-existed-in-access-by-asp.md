---
author: ety001
date: 2010-10-12 00:35:13
layout: post
title: ASP+Access如何判断一个表是否存在
wordpress_id: 226
tags:
- 编程语言
---

如何准确判断conn1里面有没有名为name1的表？ 
 
---------------------------------------------------------------  

```
变通办法  
on  error  resume  next  
rs.open  "name1",conn1  
 
if  not  err.number=0  then  
 Err.Clear      '清除该错误  
‘这里添加表不存在的处理  
end  if
```

