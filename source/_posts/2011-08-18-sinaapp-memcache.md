---
author: ety001
date: 2011-08-18 18:31:57+00:00
layout: post
title: 新浪云平台缓存使用方法
wordpress_id: 1478
tags:
- Server&OS
- 编程语言
---

今天遇到一个在[新浪云平台](http://sinaapp.com)搭建Wordpress的朋友，他也正好要用我写的[Ntalker for Wordpress插件](http://www.domyself.me/ntalker-for-wordpress)，但是有些问题存在，于是我就开始开始研究看看。经过分析，发现原来是缓存无法写入，导致的部分功能的丢失。这是新浪云平台官网原话：“SAE不允许写本地文件目录。由于SAE是分布式架构，每次的请求可能到达不同的机器，为了提升性能和安全，我们不允许对代码目录进行写操作。数据并不会永久地写到“本地”，而是通过以下两个方法写到临时存储或Storage/MC服务中：TmpFS，用于处理临时文件需求； Wrapper，让你只需要修改文件路径就可以将数据写入到Storage服务或者Memcache服务中。详细的说明请参照相关服务说明。”
下面是这次修改的主要方法的参照源。根据提示我选择了Memcache服务来代替原插件里的那个开源cache类。关于Memcache的使用方法如下：

服务概要

Memcache是SAE为开发者提供的分布式缓存服务，用来以共享的方式缓存用户的小数据。用户需要先在在线管理平台创建Memcache，然后通过标准的memcache*函数读写Memcache。

特别注意：

1. SAE平台的Memcache技术指标和标准的Memcache相同，不适合存放大文件，特别是大于4M的数据
2. SAE Memcache不需要用户调用memcache_connect函数，取而代之的，用户在get、set之前需要调用memcache_init函数

应用场景

因为SAE的Web Service是分布式环境，所以当用户需要共享的缓存某些key-value形式的小数据时，就需要用Memcache服务，这样可以快速进行数据响应，而且可以减轻后端存储的压力。

使用指南

例子：

appname: saetest
appversion: 1

开启Memcache

您需要先到SAE在线管理平台开通Memcache服务，在服务管理=>Memcache页面开通Memcache服务后，就可以通过在线管理平台的UI接口，测试Memcache读写情况，以确认开通成功。

关闭Memcache

在您不需要使用缓存服务时，也可以在在线管理平台禁用Memcache服务.禁用后，用户就不可以再使用分布式缓存服务。

特别注意：当禁用后，原有的缓存数据将全部被删除！

使用Memcache

Memcache服务目前提供以下接口：

memcache_init - 初始化MC链接
memcache_get - 获取MC数据
memcache_set - 存入MC数据
除memcache_init外,其他接口和php的memcahe模块保持一致.

需要注意的是, memcache_connect()，Memcache::connect()、memcache_pconnect()、Memcache::pconnect()、memcache_add_server() ，Memcache::addServer()等函数不建议使用。

使用示例：

$mmc=memcache_init();
if($mmc==false)
echo "mc init failed\n";
else
{
memcache_set($mmc,"key","value");
echo memcache_get($mmc,"key");
}

