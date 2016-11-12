---
author: ety001
comments: true
date: 2013-12-03 13:00:23+00:00
layout: post
slug: mysqli_pconnect-is-not-exist
title: mysqli_pconnect is not exist
wordpress_id: 2528
tags:
- 编程语言
- Server&OS
---

This function not exists for mysqli db extension. For Persistent Connections can use p: prefix by hostname at php 5.3.

fix:


    function mysqli_pconnect($host, $username, $password, $new_link = false, $port = 0)
    {
        if($port)
        {
            mysqli_connect("p:".$host, $username, $password, $new_link, $port);
        }
        else
        {
            mysqli_connect("p:".$host, $username, $password, $new_link);
        }
    }

for more infomation:[http://us1.php.net/manual/zh/mysqli.construct.php](http://us1.php.net/manual/zh/mysqli.construct.php)
