---
author: ety001
comments: true
date: 2014-09-26 10:09:26+00:00
layout: post
slug: something-about-php-timeout
title: 关于PHP中的超时研究
wordpress_id: 2644
tags:
- 编程语言
---

在PHP脚本中可以使用 set_time_limit 来设置脚本的执行最大时间限制，但是用于网络连接的时间则不会计算在这里面。下面我们看两个例子，来验证一下。

**例一：**
    <?php
    set_time_limit(2);
    for($i=1;$i<100000000000000;$i++){
        $a = array(12,34,123,3412,1234123,12341234,12341234,123412341,1234123);
        $v = array('dfsdfasdfasdfsadf','fasdfsadfasdf','fasdfasdf','fasdfasdfasdfasd');
        array_merge($a,$v);
    }

该例子是一个纯运行的php脚本，执行结果


    Fatal error: Maximum execution time of 2 seconds exceeded in /home/ety001/wwwroot/localhost/time.php on line 6


可见，我们设置的set_time_limit(2)生效了，在脚本执行到两秒的时候，虽然没有运行结束，但是php还是强制停止了脚本的运行。

**但是我们还需要捕获到这个异常情况，并进行相应的处理。**

**PHP异常处理中可以通过set_error_handler来捕获.，但是却只能捕获 NOTICE/WARNING 级别的错误， 对于 E_ERROR 是无能为力的。**

**register_shutdown_function 能解决 set_error_handler 的不足.**

<!-- more -->通过此函数注册好程序结束回调函数，就可以捕获平时捕获不到的错误了，再通过 error_get_last 对错误进行判断，就容易找出难以定位的问题了。

修改完善后的代码如下：


    <?php
    set_time_limit(2);
    register_shutdown_function('shutdown_function');
    for( $i=1;$i<100000000000000;$i++){
        $a = array(12,34,123,3412,1234123,12341234,12341234,123412341,1234123);
        $v = array('dfsdfasdfasdfsadf','fasdfsadfasdf','fasdfasdf','fasdfasdfasdfasd');
        array_merge($a,$v);
    }
    function shutdown_function()  
    {  
            $error_no_arr = array(1=>'ERROR', 2=>'WARNING', 4=>'PARSE', 8=>'NOTICE', 16=>'CORE_ERROR', 32=>'CORE_WARNING', 64=>'COMPILE_ERROR', 128=>'COMPILE_WARNING', 256=>'USER_ERROR', 512=>'USER_WARNING', 1024=>'USER_NOTICE', 2047=>'ALL', 2048=>'STRICT');
            $e = error_get_last();    
            print_r($e);
            echo $error_no_arr[$e['type']];
    }


**例二：**

文件time.php


    <?php
    set_time_limit(2);
    $url = "http://localhost/aaa.php";  
    $ch = curl_init($url); 
    $html = '';  
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);  
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);  
    $html = curl_exec($ch);  
    curl_close($ch);  
    echo 'test1'.$html;


文件aaa.php


    <?php
    sleep(10000);
    echo 'test2';


访问time.php，得到的结果如下，


    1411753875

    test1

    1411753885


可见，set_time_limit 对于网络连接是无法限制的，如果要是有数据来自于网络服务接口，那么需要设置相应的网络超时时间。
