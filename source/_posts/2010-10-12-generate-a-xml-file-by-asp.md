---
author: ety001
date: 2010-10-12 00:11:01+00:00
layout: post
title: Asp读取access数据库生成XML文件(gb2312 总穆修正版)
wordpress_id: 216
tags:
- 编程语言

---

```
<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--Asp读取access数据库生成XML文件(gb2312 总穆修正版) 程序修改自网络 仅帮助新手入门 Zongmu-->
<%
dim conn,connstr,rs,sql
    connstr="provider=Microsoft.Jet.OLEDB.4.0;data source="&Server.MapPath("zongmu_db/zongmu_km.mdb")&";"
set conn=Server.CreateObject("ADODB.Connection")
set rs=Server.CreateObject("ADODB.RecordSet")
    conn.open connstr
%>

<!-- more -->
<%
if request("action")="zongmu_shengcheng" then

set conn=Server.CreateObject("ADODB.Connection")
set rs=Server.CreateObject("ADODB.RecordSet")
    conn.open connstr
sql="select * from content order by id desc"
    rs.open sql,conn,1,1
xmlfile=Server.MapPath("test.xml")
Set fso = CreateObject("Scripting.FileSystemObject")
Set MyFile = fso.CreateTextFile(xmlfile,True)

MyFile.WriteLine("<?xml version=""1.0"" encoding=""gb2312""?>")
MyFile.WriteLine("<config>")

do while not rs.eof
MyFile.WriteLine"<item>"
MyFile.WriteLine"<Id>"&rs("title")&"</Id>"
MyFile.WriteLine"<name>"&rs("name")&"</name>"
MyFile.WriteLine"<client>"&rs("client")&"</client>"
MyFile.WriteLine"<url>"&rs("url")&"</url>"
MyFile.WriteLine"<markUp1 href=""#"">"&rs("markUp1")&"</markUp1>"
MyFile.WriteLine"<markUp2 href=""#"">"&rs("markUp2")&"</markUp2>"
MyFile.WriteLine"<markUp3 href=""#"">"&rs("markUp3")&"</markUp3>"
MyFile.WriteLine"<markUp4 href=""#"">"&rs("markUp4")&"</markUp4>"
MyFile.WriteLine"<image>"&rs("image")&"</image>"
MyFile.WriteLine"<imgAlt>"&rs("imgAlt")&"</imgAlt>"
MyFile.WriteLine"<content>"&rs("content")&"</content>"
MyFile.WriteLine"<className>"&rs("className")&"</className>"
MyFile.WriteLine("</item>")

rs.movenext
loop

MyFile.WriteLine("</config>")

MyFile.Close

rs.close
conn.close
set rs=nothing
set conn=nothing
end if
%>

<!--网页显示部分 并显示XML文件的链接-->
<p>　</p>
<script language="javascript">
<!--

function ConfirmDel()
{
   if(confirm("确定要更新XML数据吗? 一旦更新将不能恢复!"))
     return true;
   else
     return false;�
}

-->
</script>
<form name="zongmu" method="post" action="?action=zongmu_shengcheng"><input type="submit" name="Submit" value="更新XML数据为最新" onClick="return ConfirmDel();"></form>
<p>　</p>
<p><a href="test.xml">查看XML文件内容</a></p>
```

