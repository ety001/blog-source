---
author: ety001
comments: true
date: 2012-05-09 07:20:26+00:00
layout: post
slug: geolocation
title: geolocation
wordpress_id: 2113
tags:
- 前端
---

获取地理位置的方式及其优缺点：

　　1、ip地址
　　书上说不准确，很多时候获取的是ISP机房的位置，但是获取非常方便，没有什么限制。但是实际上我觉得在中国，ip地址还是比较准确的，基本上上能精确到小区或大楼的标准。
　　2、GPS
　　非常准确，但是需要在户外，且需要很长时间搜索卫星。最主要的很多设备比如笔记本电脑基本都是不带GPS的，新的智能手机倒是都有。
　　3、WiFi基站的mac地址。（猜测是连接位置已知的公共WiFi的时候，通过Mac地址识别WiFi接入点，从而定位)
　　这种定位的精度还是很不错的，而且还可以在室内定位。不过由于这种位置公开的wifi比较少，此种方法的适用范围比较少。
　　4、 GSM或CDMA基站
　　通过基站定位，精度随基站密度变化，精度一般，还是只有手机能用。看来地理位置API还是手机上比较有实用性。
　　5、用户指定位置
　　晕，这个就不是HTML5的范畴了。

地理位置获取流程：

　　1、用户打开需要获取地理位置的web应用。
　　2、应用向浏览器请求地理位置，浏览器弹出询问窗口，询问用户是否共享地理位置。
　　3、假设用户允许，浏览器从设别查询相关信息。
　　4、浏览器将相关信息发送到一个信任的位置服务器，服务器返回具体的地理位置。

检测浏览器支持：

　　function loadDemo() {
    　　if(navigator.geolocation) {
    　　  document.getElementById(“support”).innerHTML = “HTML5 Geolocation supported.”;
    　　} else {
    　　  document.getElementById(“support”).innerHTML = “HTML5 Geolocation is not supported in your browser.”;
    　　}
　　}
位置请求方式：

    单次请求navigator.geolocation.getCurrentPosition(updateLocation, handleLocationError, options);
    回调函数updateLocation接受一个对象参数，表示当前的地理位置，它有如下属性：
    　　latitude——纬度
    　　longitude——精度
    　　accuracy——精确度，单位米
    　　altitude——高度，单位米
    　　altitudeAccuracy——高度的精确地，单位米
    　　heading—运动的方向，相对于正北方向的角度
    　　speed——运动的速度（假设你在地平线上运动），单位米/秒

    回调函数handleLocationError接受错误对象，error.code是如下错误号。
    　　UNKNOWN_ERROR (error code 0) —— 错误不在如下三种之内，你可以使用error.message获取错误详细信息。
    　　PERMISSION_DENIED (error code 1)—— 用不选择不共享地理位置
    　　POSITION_UNAVAILABLE (error code 2) ——无法获取当前位置
    　　TIMEOUT (error code 3) ——在指定时间无法获取位置会触发此错误。
    　　第三个参数options是可选参数，属性如下：
    　　enableHighAccuracy——指示浏览器获取高精度的位置，默认为false。当开启后，可能没有任何影响，也可能使浏览器花费更长的时间获取更精确的位置数据。
    　　timeout——指定获取地理位置的超时时间，默认不限时。单位为毫秒。
    　　maximumAge——最长有效期，在重复获取地理位置时，此参数指定多久再次获取位置。默认为0，表示浏览器需要立刻重新计算位置。
    　　参数使用的例子如下：
    　　navigator.geolocation.getCurrentPosition(updateLocation,handleLocationError,
    　　{timeout:10000});
    　　重复请求navigator.geolocation.watchPosition(updateLocation, handleLocationError);
    　　使用 watchPosition可以持续获取地理位置，浏览器或多次调用updateLocation函数以便传递最新的位置。该函数返回一个watchID，使用navigator.geolocation.clearWatch(watchId)可以清除此次回调，使用不带参数的navigator.geolocation.clearWatch()清除说有watchPosition。

地址转换：

    由于地理位置API返回的是经纬度，如果要计算两个位置之间的距离，可以使用著名的Haversine公式计算两个坐标在地平线上的距离。

    　　Listing 4-7. A JavaScript Haversine implementation
    　　function toRadians(degree) {
    　　return degree * Math.PI / 180;
    　　}
    　　function distance(latitude1, longitude1, latitude2, longitude2) {
    　　// R is the radius of the earth in kilometers
    　　var R = 6371;
    　　var deltaLatitude = toRadians(latitude2-latitude1);
    　　var deltaLongitude = toRadians(longitude2-longitude1);
    　　latitude1 =toRadians(latitude1);
    　　latitude2 =toRadians(latitude2);
    　　var a = Math.sin(deltaLatitude/2) *
    　　Math.sin(deltaLatitude/2) +
    　　Math.cos(latitude1) *
    　　Math.cos(latitude2) *
    　　Math.sin(deltaLongitude/2) *
    　　Math.sin(deltaLongitude/2);
    　　var c = 2 * Math.atan2(Math.sqrt(a),
    　　Math.sqrt(1-a));
    　　var d = R * c;
    　　return d;
    　　}
