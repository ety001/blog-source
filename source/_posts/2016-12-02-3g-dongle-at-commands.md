---
title: 3g无线网卡上的AT指令总结
date: 2016-12-02 01:38:43
keyword:
- asterisk
- 3g dongle
- raspberry pi
- at command
tags:
- 理论
- 配置
---

## 前言

之前6月份搞过树莓派外加3G网卡接打电话，一直想要写份关于 **asterisk** 的菜鸟教程。
话说目录都拟好了，就是没有时间。另外也是因为其中还有些 **NAT的问题** 没有完全攻克。

复杂的既然没时间搞，那么就先总结下简单的东西吧，从AT指令开始。

## 概念

**AT** 即 **Attention** ，**AT指令集** 是从 **终端设备(Terminal Equipment，TE)**
或 **数据终端设备(Data Terminal Equipment，DTE)** 向 **终端适配器(Terminal Adapter， TA)**
或 **数据电路终端设备(Data Circuit Terminal Equipment，DCE)** 发送的。

通过TA，TE发送 **AT指令** 来控制 **移动台(Mobile Station，MS)** 的功能，
与 **GSM 网络业务** 进行交互。用户可以通过AT指令进行呼叫、短信、电话本、数据业务、传真等方面的控制。

具体的概念参考百度百科吧 <http://baike.baidu.com/link?url=h5HIp9nrv3c5YUwrdBPJsiAzeifMIlvpowj2FprSP5_vmWuZLteVAlbPrf-oBIYZs6_zPVkYagLFV0clhTYZmK>。

## 常用指令总结

指令是以 **AT** 开头的，切记！！！

国内貌似这方面的总结文章不多，我在折腾那套设备的时候，主要参考的是国外的文章。
其中很多文章写指令的时候，都省略了 **AT** ， 这也使我刚开始是一头雾水。

下面就是我总结的常用的指令

* **AT+CGMI**

    *获取生产商名字*

* **AT+CGMR**

    *获取软件版本*

* **AT+CIMI**

    *获取 SIM 卡的 IMSI*

* **AT+CGSN**

    *获取设备的 IMEI*

* **AT^HWVER**

    *获取硬件版本*

* **AT+CPWD=SC,old pin, new pin**

    *改变 pin*

* **AT+CLCK=SC,mode,pin**

    *Enable PIN*

    ```
    Mode: 0=unlock, 1=lock, 2=query state
    ```

* **AT+CGDCONT=1,”IP”,”apn name”**

    *选择APN*

    ```
    对于中国联通的SIM卡
    AT+CGDCONT=1,”IP”,”internet”
    ```
* **AT+CFUN=1,1**

    *重启设备*

* **AT^u2diag=mode**

    *设置设备模式*

    ```
    mode的可选值
    * 1, modem+cdrom
    * 255, modem+cdrom+cardreader
    * 256, modem+cardreader
    ```

* **AT^CVOICE=?**

    *查询语音功能是否可用*

* **AT^CVOICE=0**

    *激活语音功能*

* **AT+CSQ**

    *获取信号质量*

* **AT^SYSINFO**

    *获取系统信息*

    *返回信息包含: status, domain, roaming status, mode, SIM state*

    ```
    其中返回值的各个数值的意义如下:

    * Status
        0 No service.
        1 Restricted service
        2 Valid service
        3 Restricted regional service.
        4 Power-saving and deep sleep state
    * Domain
        0 No service.
        1 Only CS service
        2 Only PS service
        3 PS+CS service
        4 CS and PS not registered, searching
    * Roaming
        0 Non roaming state
        1 Roaming state
    * Mode
        0 No service.
        1 AMPS mode (not in use currently)
        2 CDMA mode (not in use currently)
        3 GSM/GPRS mode
        4 HDR mode
        5 WCDMA mode
        6 GPS mode
    * SIM state
        0 Invalid USIM card state or pin code locked
        1 Valid USIM card state
        2 USIM is invalid in case of CS
        3 USIM is invalid in case of PS
        4 USIM is invalid in case of either CS or PS
        255 USIM card is not existent
    ```

* **AT^SYSCFG=mode, order, band, roaming, domain**

    *设置系统*

    ```
    设置为 GPRS Only
    AT^SYSCFG=13,1,3FFFFFFF,2,4

    设置为 3G only
    AT^SYSCFG=14,2,3FFFFFFF,2,4

    设置为 GPRS 优先
    AT^SYSCFG=2,1,3FFFFFFF,2,4

    设置为 3G 优先
    AT^SYSCFG=2,2,3FFFFFFF,2,4
    ```

    *具体参数意义*

    ```
    * Mode
        2 Automatic search
        13 2G ONLY
        14 3G ONLY
        16 No change
    * Order
        0 Automatic search
        1 2G first, then 3G
        2 3G first, then 2G
        3 No change
    * Band
        80 GSM DCS systems
        100 Extended GSM 900
        200 Primary GSM 900
        200000 GSM PCS
        400000 WCDMA IMT 2000
        3FFFFFFF Any band
        40000000 No change of band
    * Roaming
        0 Not supported
        1 Roaming is supported
        2 No change
    * Domain
        0 CS_ONLY
        1 PS_ONLY
        2 CS_PS
        3 ANY
        4 No change
    ```
* **AT+COPS=mode, format, operator**

    *设置网络*

    *其中 AT+COPS=? 可以用来列出所有网络(注意: 该命令执行时间较长)*

    *具体参数如下*

    ```
    Mode
        0 Automatic
        1 Manual
        4 If manual fails, try automatic
    Format
        1 Long alpha
        2 Short alpha
        3 Numeric
    Operator
        Either the long alpha name, the short operator alpha code or the numeric code
        Status
        0 unknown
        1 available
        2 current
        3 forbidden
    ```

* **AT+CUSD=1,"USSD-Command"**

    *发送 USSD 指令*

    *例如*

    ```
    AT+CUSD=1,"*100#"
    ```

    *对于某些设备你可能需要在指令最后附加上 ",15" 防止出现异常，例如：*

    ```
    AT+CUSD=1,"*100#",15
    ```

* **ATD10086;**

    *拨打10086，注意分号不能缺少，另外前提你的设备支持voice*

* **ATH**

    *挂掉电话*

* **ATA**

    *接听电话*

* **发送短信**

    ```
    首先设置成文本模式：
    AT+CMGF=1
    设置使用模块默认的国际标准字母字符集发送短信
    AT+CSCS?
    发送目标号码
    AT+CMGS=”10086″（回车）
    此时系统会出现“>”提示符，直接输入短信内容
    > YE
    这条短信的目的是发送给10086，用来查询余额。
    0x1A （16进制发送）
    发送成功以后会收到系统如下提示，后面的数字表示发送短信的编号。
    +CMGS: 115
    OK
    接收短信
    如果接收到了短信，则系统会在串口输出如下的提示，后面的数字表示短信收件箱里的短信数目：
    +CMTI: “SM”,2
    发送如下AT指令，后面的数字是短信索引号。由于使用的是IRA编码，中文短信不能显示，可以发英文短信用来测试。
    AT+CMGR=2
    ```
