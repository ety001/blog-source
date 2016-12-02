---
title: 3g无线网卡上的AT指令总结
date: 2016-12-02 01:38:43
keywords: ['asterisk', '3g dongle', 'raspberry pi', 'at command']
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
* **AT+CPIN?**

    *返回sim卡状态，返回 READY OK 即为正常*

---

以下是摘自他人的博客(<http://zhan.renren.com/cxymst?gid=3602888498030665972&from=template&checked=true>)：

```
最近在调试与 MODEM 通信相关的一个产品，主要是借助 MODEM 的链路实现数话同传（数据是专有格式）,故从网上收集于此以供学习。

AT命令集
AT命令使计算机或终端与调制解调器通讯。通讯软件是你与调制解调器间的交接口方法,请阅读这一章您可以按照自己的需要设置您的调制解调器
装入通讯软件包并进入终端或交互模式后,就可以发出工业标准AT指令了,(请参阅通讯软件手册)。所有命令行必须由ASCII字符“AT”开始并由 <Enter> 结束。除了A/指令和推出(缺省为+++)。这些将在后面讨论。字母"AT"用以提醒调制解调器注意，其后将有一条或多条命令出现, "AT"及其后的字母可以是大写或小写。
AT必须同为大写或小写。如"At"或"aT"是不允许的。
一串命令可以写在一行里。为了便于阅读可以加或不加空格。命令中或命令间的空格会被忽略，命令行的最多字符数为39(包括"AT")。在输入一条命令期间，可以用退格键(backspace)改正除"AT"以外的错误。
若命令行中任一处出现语法错误，本行其后的内容将被忽略，并返回ERROR。大数带有超出正常范围的参数的命令将不被接收并返回 ERROR.
本章列出所有设置调制解调器的命令。包括控制ACTIVE调制解调器的贺氏标准AT命令集。贺氏V系列命令集和扩展命令集
AT命令集的描述
符号 * 表明该命令的设置可用AT&Wn命令存于两个用户方案中的一个
A/        重执行命令
重执行前一AT命令行，主要用于连接时占线，无应答或号码错误。这一命令必须单独构成一命令行并由"/"字符结束,(<Enter> 不能用于结束命令)。
+++       退出字符 缺省:+
切换调制解调器从在线状态到命令状态，而不会中断数据连接。可以通过改变S寄存器S2的值来改变这一字符。
AT=x      写入被选的S寄存器
这一命令将数值x写入当前被选的S寄存器，一个S寄存器可由ATSn命令选择，若 x 是一个数字,所有S 寄存器将返回 OK 响应。
AT?       读被选的S寄存器
这一命令读并且显示被选的S寄存器的内容。一个S寄存器可由ATSn命令选择。
ATA       应答
它必须是命令行中的最后一条指令。调制解调器在应答方式下继续执行连接程序。在与远端调制解调器交换载波后进入连接状态,如果在由寄存器S7规定的时间内(缺省值=50秒)没有检测到载波, 调制解调器将挂机。在连接过程中，通过DTE输入的任何一个字母都将中断这一命令。
ATBn*     选择ITU-T或Bell模式 缺省=0
ATB0 选择在1200和300bps速率下通讯的ITU-T V.22和V.21协议
ATB1 选择在1200和300bps速率下通讯的Bell 212A和103协议
ATCn      载波控制缺省=1
包含这一命令只是为了保证兼容性，执行号只是返回一结果码而没有其它作用。
ATC1 正常传输载波切换
ATDn      拨号
它必须是命令行中的最后一条指令, ATD命令使调制解调器摘机后, 根据输入的参数拨号,以建立连接。
如果不带参数，调制解调器摘机后，不拨号进入发起方式。
使用标点可使命令更易读懂。圆括号,连字符和空格符会被忽略。拔号命令行中如果出现了非法字符，则该字符及其后的内容将被忽略。调制解调器允许的拨号命令长度为36个字符。
参数：0-9 A B C D * # L P T R ! @ W , ; ^ S=n
0-9     DTMF 符号0到9
A-D     DTMF 符号A,B,C和D。在一些国家中不使用这些符号
*       "星"号(仅用于音频拨号)
#       "#"号(仅用于音频拨号)
J       为本次呼叫执行在可提供的最高速率下的MNP10链路协商(可选)
K       使本次呼叫MNP10链路协商期间电源电平可调(可选)
L       重拨上一次拨过的号码
P       脉冲拨号
T       双音频拨号
R       逆叫方式。允许调制解调器使用应答方式呼叫只能作为发起使用的调制解调器, 必须作为命令行中的最后一个字符输入。
!       使调制解调器按照S29中规定的值挂机一段时间再摘机。
@       使调制解调器等待5秒钟的无声回答
w       按照寄存器S7中规定的时间，在拨号前等待拨号音。
,       在拨号过程中，按照寄存器S8中规定的时间,暂停
;       拨号后返回命令状态
^       打开呼叫音
()      被忽视，用于格式化号码串
-       被忽视，用于格式化号码串
<space> 被忽视,用于格式化号码串
S=n     用AT&Zn 命令存在地址n处的号码拨号
ATE*     命令回应           缺省:1
ATE0 关闭命令回应
ATE1 打开 命令回应
ATHn     摘挂机控制       缺省:0
ATH0 使调制解调器挂机
ATH1 当调制解调器处于挂机状态，使调制解调器摘机，返回响 OK，等待进一步的命令。
ATIn     识别
I0 报告产品代码
I1 报告ROM中预先计算的校验和
I2 计算校验和并与ROM中的校验和比较,返回"OK"或"ERROR"结果码
I3 报告固件修正
I4 报告OEM定义的识别串
I5 报告国家代码参数
I6 报告固件修正
I7 报告调制解调器数据泵类型
ATLn*    扬声器音量       缺省:2
ATL0 扬声器低音量
ATL1 扬声器低音量
ATL2 扬声器中音量
ATL3 扬声器高音量
ATMn*    扬声器控制       缺省:1
ATM0 关闭扬声器
ATM1 扬声器在呼叫建立握手阶段打开至检测到来自于远端调制解调器的载波后关闭
ATM2 扬声器持续开
ATM3 扬声器在应答期间打开。当检测到来自于远端的调制解调器的载波和拨号时关闭
ATNn*     调制握手       缺省:1
ATN0 要求调制解调器S37选择连接速率,若S37＝0,则连接速率必须与发出的上一条AT命令的速率相匹配。如果所选择的速率可用不止一个通讯标准实现(如Bell212A或ITU-T V.22 速率在 1200bps)调制解调器同时参考ATB 命令选择。
ATN1 允许时使用双方调制解调器都支持的任一速率握手，使能够自动检测。在这一方式下，ATB命令被忽视，调制解调器只用ITU-T方式连接。
ATOn     进入数据在现状态 缺省:0
ATO0 使调制解调器从命令在现状态直接返回数据在线状态,不经过自动均衡。
ATO1 使调制解调器从命令在现状态返回数据在状态,经过自动均衡。
ATP*     设脉冲拨号为缺省
ATQn*    结果码显示        缺省:0
ATQ0 调制解调器向DTE发送结果码
ATQ1 禁止调制解调器向DTE发送结果码
 参阅调制解调器结果码一节的详细说明
ATSn     设S寄存器n为缺省寄存器
ATSn?    读S寄存器
读S寄存器中的内容，所有的S寄存器都可以读
ATSn=x   写入S寄存器
将 x值写入指定的S寄存器n
ATT*     设音频拔号为缺省
ATVn*    结束码类型 (消息控制)        缺省:1
ATV0 发送短型 (数字型) 结果码
ATV1 发送长型 (字符型) 结果码
ATWn*    协商进程报告                缺省:0
ATW0 不报告纠错呼叫进程
ATW1 报告纠错呼叫进程
ATW2 不报告纠错呼叫进程，CONNECT xxxx指示DCE速率。
ATXn*     扩展结果码            缺省:4
ATX0 调制解调器忽视拨号音和忙音。当由盲拨建立连接时，发送CONNECT信息。
ATX1 调制解调器忽视拨号音和忙音。当由盲拨建立连接时，CONNECT XXXX 反映的是比特速率
ATX2 调制解调器忽视忙音，但在拨号前等待拨号音，如果5秒钟内检测不到拨号音，则发送NO DIAL TONE 信息，连接建立后 发送 CONNECT xxxx反映比特速率。
ATX3 调制解调器忽视拨号音,若检测到忙音,发送BUSY信息,当由盲拨建立起连接时, CONNECT XXXX 反映的是比特速率。
ATX4 如果5秒钟内检测不到拨号音，发送NO DIAL TONE 讯息,检测到忙音, 发送BUSY信息。连接建立后发送CONNECT XXXX 反映比特速率。
ATYn*     控制长间隔拆接         缺省:0
ATY0 不允许长间隔拆接
ATY1 允许长间隔拆接
ATZn      复位                缺省:0
重新调出由用户方案规定的动态配置
ATZ0 软复位并重新调出用户方案0
ATZ1 软复位并重新调出用户方案1
AT&An*    握手异常终止(备选)    缺省:1
AT&A0 在握手时禁止用户进行异常终止。当拨号或应答时，握手不能异常终止,只有DTR 信号下降。
AT&A1 用户可以在握手时进行异常终止.在接收到DTE的字符后,发起和应答可以在握手期间随时进行异常终止.
AT&Cn*     RS232-C DCD          设置缺省:1
AT&C0 DCD为ON，不论来自远端的调制解调器的数据载波的状态为何。
AT&C1 DCD 跟随来自于远端调制解调器的数据载波的状态
AT&Dn*    RS232-C DTR          设置缺省:2
决定了调制解调器与来自串口的DTR信号相关的操作。由于跟踪DTR的下降引起的操作在下表列出:

&D0
&D1
&D2
&D3
&Q0
NONE
2
3
4
&Q1
1
2
3
4
&Q2
3
3
3
3
&Q3
3
3
3
3
&Q4
1
2
3
4
&Q5
NONE
2
3
4
&Q6
NONE
2
3
4
1 调制解调器断开连接并发送结果码OK
2 若在数据状态下,则进入命令状态,并发送结果码OK
3 调制解调器断开连接并发送结果码OK, DTR 为 OFF时不能自动应答
4 调制解调器执行热启动(即与ATZ命令相同)
AT&Fn     重新调用工厂            设置缺省:0
&F0 重新调用作为V.42bis自动可靠方式的出厂缺省设置
&F1 重新调用作为MNP5自动可靠方式的出厂缺省设置
&F2 重新调用作为DIRECT方式的出厂缺省设置
&F3 重新调用作为MNP10方式自动可靠方式的出厂缺省设置(可选)
AT&Gn*    设置保护音            缺省:0
AT&G0 无保护音
AT&G1 无保护音
AT&G2 1800HZ保护音
AT&Jn*    电话插头选择          缺省:0
包含这一命令只是基于兼容性的考虑，没有任何功能
AT&J0 不操作任何功能
AT&J1 不操作任何功能
AT&Kn*    DTE/调制解调器流    控制缺省:3
AT&K0 关闭流控制
AT&K3 使用RTS/CTS流控
AT&K4 使用XON/XOFF流控
AT&K5 使用透明XON/XOFF流控
AT&K6 使用RTS/CTS和XON/XOFF流控(作为传真方式下的缺省)
AT&Ln*    传输线类型            缺省:0
AT&L0 拨号线
AT&L1 二线专线 （备选）
AT&L2 四线专线 （备选）
AT&Mn*    通讯方式
与AT&Q0-3相同
AT&Pn*    拨号脉冲占空比        缺省:0
AT&P0 39％61％占空比@10PPS
AT&P1 33％67％占空比@10PPS
AT&P2 39％61％占空比@20PPS
AT&P3 33％67％占空比@20PPS
AT&Qn*    通讯方式             缺省:5
AT&Q0 选择直接异步操作
AT&Q1 选择同步模式一操作
AT&Q2 选择同步模式二操作
AT&Q3 选择同步模式三操作
AT&Q4 选择自动同步模式操作
AT&Q5 选择纠错模式操作
AT&Q6 选择标准模式下的异步操作
AT&Rn*    RS232-C RTS/CTS   设置缺省:0
AT&R0 CTS跟踪RTS, 本地DTE发送的RTS由OFF变为ON经过由寄存器S26所规定的以10微秒为增量的延迟后,CTS变为ON
AT&R1 调制解调器忽视RTS,除非使用了AT&K3命令,CTS保持为ON
AT&Sn*    RS232-C DSR       设置缺省:0
AT&S0 DSR始终为ON
AT&S1 DSR根据EIA-232-C的规定操作
AT&Tn*    测试和诊断            缺省:4
测试只能在非纠错方式下(标准或直接模式)下的异步操作中进行，除参数7和8以外，要中止正在进行中的测试必须首先敲入退出符。若S18非零，则测试经由S18规定的时间后自动中止并显示OK。
AT&T0 终止进行中的测试
AT&T1 启动本地模拟回环
AT&T3 在本地启动远端数字回环·,若连接未建通,返回ERROR
AT&T4 允许调制解调器响应来自远端的进行远程数字环回测试的请求
AT&T5 拒绝调制解调器响应来自远端的进行远程数字环回测试的求
AT&T6 启动远端数字环回测试,若连接未通,返回ERROR
T&T7 启动远端数字环回自测试,若连接未建通,返回ERROR
AT&T8 启动本地模拟环回自测试
AT&V     看当今配置及用户参数
AT&V0 查看当前配置、用户方案和存储的电话号码
AT&V1 显示最后一次数据连接的详细情况
AT&Wn    储存用户参数              缺省：0
AT&W0 作为用户0存贮
AT&W1 作为用户1存贮
AT&Xn*    选择同步时钟源             缺省：0
AT&X0 调制解调器提供传输时钟，内部时钟。 AT&X1 DTE提供传输时钟，外部时钟。
AT&X2 由调制解调器从接外载波信号中提供传输时钟，从属接收时钟
AT&Yn*    指示缺省用户参数            缺省：0
在硬复位后可选择将使用的用户方案。
AT&Y0 选择用户方案0
AT&Y1 选择用户方案1
AT&Zn=x   储存电话号码(n=0-3)         缺省：0
将一36位数字电话号码(x)存放在一指定电话号码表中(n), 作以后拨号用(参见命令ATDS=n)
AT\An 最大MNP块的大小缺省:2
AT\A0 设最大块为64个字符
AT\A1 设最大块为128个字符
AT\A2 设最大块为192个字符
AT\A3 设最大块为256个字符
AT\Bn     发送中断信号(n=1-9)        缺省:3
当在非MNP连接期间输入此命令,调制解调器向远端调制解器发送一中断信号,中断信号长度参数为n值的100倍（以毫秒为单位）,在MNP模式下,输入此命令,调制解调器向远端调制解调器发送一链路注意码PDU
AT\Gn     调制解调器到调制解调器的流控制    缺省:0
AT\G0 关闭流控(XON/XOFF)
AT\G1 打开流控(XON/XOFF)
AT\Jn     DTE速率自动调整控制            缺省:0
AT\J0 关闭匹配线路速率的DTE速率调整功能
AT\J1 打开匹配线路速率的DTE速率调整功能
AT\Kn     中断控制                     缺省:5
在数据传输期间收到来自DTE的中断信号时,调制解调器作出如下响应
AT\K0,2,4 调制解调器进入连机命令状态,而不向远端发送中断信号
AT\K1 调制解调器清空终端的缓冲器并向远端调制解调器发送中断信号
AT\K3 调制解调器不清空终端的缓冲器,但向远端调制解调器发送中断信号
AT\K5 调制解调器随发送的数据发送中断信号. 调制解调器在连机命令状态时数据传输过程中，做如下操作
AT\K0,1 调制解调器清空终端的缓冲器，并向远端调制解调器发送中断信号
AT\K2,3 调制解调器不清空缓冲器，但向远端调制解调器发送中断信号
AT\K4,5 调制解调器随传输的数据按顺序发送中断信号 在非纠错模式下收到来自DTE的中断信号时,调制解调器做如下操作
AT\K0,1 调制解调器清除终端的缓冲器,并向本地DTE发送中断信号
AT\K2,3 调制解调器不清除缓冲器,但向本地DTE发送中断信号
AT\K4,5 调制解调器随接收的数据按顺序发送中断信号
AT\Ln     MNP块传输控制                 缺省:0
AT\L0 对于MNP链路连接使用流模式
AT\L1 对于MNP链路连接使用块模式
AT\Nn     操作模式控制                 缺省:3
AT\N0 选择标准速度缓存模式(无纠错)
AT\N1 选择直接模式(等效于&M0,&Q0)
AT\N2 选择可靠模式,可靠连接失败会使调制解调器挂机
AT\N3 选择自动可靠模式
AT\N4 选择LAPM纠错模式,LAPM纠错连接失败会使调制解调器挂机
AT\N5 选择MNP纠错模式,MNP纠错连接失败会使调制解调器挂机
AT\Vn     单线连接信息                 缺省：0
AT\V0 关闭单线连接信息。
AT\V1 打开单线连接信息。
AT％C*    压缩控制                    缺省: 3
AT%C0 关闭数据压缩 AT%C1 打开MNP5数据压缩
AT%C2 打开V.42bis数据压缩
AT%C3 打开MNP5和V.42bis数据压缩
AT％En    开/关自动均衡                缺省：2
控制是使调制解调器自动监听线路质量并请求均衡(％E1)还是当线路质量不好时降速，线路质量好时升速。
AT%E0 关闭线路质量监听和自动均衡。
AT%E1 打开线路质量监听和自动均衡。
AT%E2 打开线路质量监听和速率自动调整上升或下降。
AT%E3 打开线路质量监听和采用快速挂机的自动均衡。
AT％L     报告接收灵敏度
返回接收信号的电平值,提供以下数值
001=-1dBm接收电平
002=-2dBm接收电平
: :
043=-43dBm接收电平
AT%On     选择应答或呼叫模式             缺省：1
AT%O0 选择应答式模
AT%O1 选择发起式模
AT%Rn     选择接收灵敏度 (适用於专线型号) 缺省：0
AT%R0 -43dBm
AT%R1 -33dBm
备选：适用於拔号线型号,JP2跳线：-33dBM 连接1-2 针；-43 连接2-3针
AT％Q     显示线路信号质量
返回眼图指标(EQM)值的高字节,该字节的表示范围为0到127,当这一数值为70DC±10(依赖于线路速率)或更大时,若已使用了AT％E1命令则调制解调器将自动均衡,标准连接时这一数在0到15之间。到60时则为较差连接。
AT#CIDn   呼叫者身份鉴定                 缺省：0
AT#CID=0关闭呼叫者身份鉴定
AT#CID=1打开DTE格式化形式的呼叫者身份鉴定
AT#CID=2打开DTE非格式化形式的呼叫者身份鉴定
AT#CID? 从调制解调器中恢复当前呼叫者身份鉴定方式
AT#CID=? 返回调制解调器允许模式的列表,表中各部分间用逗号隔开
AT-SDR=n  鉴别性振铃                    缺省：0
AT-SDR=0 允许任何振铃、并报告"RING"
AT-SDR=1 允许一类型振铃
AT-SDR=2 允许二类型振铃
AT-SDR=3 允许一及二类型振铃
AT-SDR=4 允许三类型振铃
AT-SDR=5 允许一及三类型振铃
AT-SDR=6 允许二及三类型振铃
AT-SDR=7 允许一、二及三类型振铃
振铃类型
振铃时段模式
1
响2秒、停4秒
2
响0.8秒、停0.4秒、响0.8秒、停4秒
3
响0.4秒、停0.2秒、响0.4秒、停0.2秒、响0.8秒、停4秒
AT+MS*     选择线路调制方式
命令格式为（336型号）:
AT+MS=<模式>,<自动模式>,<最小速率>,<最大速率>
缺省值为 AT+MS=11,1,300,33600 （336型号）
命令格式为（560型号）:
AT+MS=<模式>,<自动模式>,<最小速率>,<最大速率>,
<x_law>,<rb_signal>,<maxup_rate>
缺省值为 AT+MS=12,1,300,56000,33600 （560型号）
AT+MS?  向包含所选选项的DTE发送一信息流
AT+MS=? 向包含所提供选项的DTE发送一信息流
自动模式
选 项
0
关闭自动模式
1
打开自动模式

模式
调制方式选择
可能 波特率(bps) <最小 波特率> <最大 波特率>
0
V.21
300
1
V.22
1200
2
V.22bis
2400或1200
3
V.23
1200
9
V.32
9600或4800
10
V.32bis
14400,12000,9600,7200 或4800
11

V.34
33600,31200,28800,26400,24000,21600,19200, 16800,14400,12000,  
9600,7200,4800或2400
12

V.90
56000,54667,53333,52000,50667,49333,48000,46667,45333,42667,
41333,40000,38667,37333,36000,34667,33333,32000,30667,29333,
28000 (560型号适用)
56

K56flex
56000,54000,52000,50000,48000,46000,44000,42000,40000,38000,
36000,34000,32000 (560型号适用)
64
Bell 103
300
69
Bell 212
1200
<x_law> 是一个可选的数字，用来确定码类型，选择是：
0 = u-Law 1 = A-Law
注意：ATZ命令将复位<x_law>值为0 (u-Law)。
<rb_signaling> 是一个可选的数字，用于配置一个发送数据的调制解调器产生“丢失位”信号或不产生“丢               失位”信号；或配置一台接收数据的调制解调器检测“丢失位”信号或不检测“丢失位”信               号。选择是：
0 = 发送数据的调制解调器产生丢失位信号。接收数据的调制解调器检测丢失位信号。
1= 发送数据的调制解调器不产生丢失位信号。接收数据的调制解调器不检测丢失位信号。
注意：ATZ命令将复位<rb_signaling>值为0。
Maxup_rate : 连接速率的最大值。
AT COMMAND的命令集
MODEM AT COMMAND 指令集
-------------------------------------------------------------------
Modem RS-232C 说明 :
接脚      名称      功能      方向
----------------------------------------------------
1          AGND      安全接地
2          TD        传送资料  PC TO MODEM
3          RD        接收资料  MODEM TO PC
4          RTS        控制线    PC TO MODEM
5          CTS        控制线    MODEM TO PC
7          DGND      信号接地
8          DCD        信号侦测  MODEM TO PC
12        HI        高速指示  MODEM TO PC
15        TXC        传送时脉  MODEM TO PC *
17        RXC        接收时脉  MODEM TO PC *
20        DTR        控制线    PC TO MODEM
22        RI        铃声指示  MODEM TO PC
----------------------------------------------------
注 : * 号为同步传输时才使用
MODEM 灯号
PWR : 电源指示             亮时表示电源接通
MR  : 数据机备妥指示       亮时表示数据机在备用状态 (MODEM READY)
DTR : 电脑连线指示          亮时表示电脑与数据机连线 (DATA TERMINALREADY)
DCD : 数据机接通指示       亮时表示两台数据机连线成功(DATA CARRIER                      DETECTOR)
OH  : 占线指示              亮时表示数据机占用电话线 (OFF HOCK)
HS  : 高速指示              亮时表示数据机在高速状态 (HIGH SPEED)
AA  : 应答指示              亮时表示数据机自动应答  (AUTO ANSWER)
TD  : 传输指示 (TXD)        亮时表示数据机传送资料  (TRANSMITTERDATA)
RD  : 接收指示 (RXD)        亮时表示数据机接收资料  (RECEIVED DATA)
MODEM AT 指令说明:
AT指令除了指令本身以外尚包括S-Register及Result code
S-Register是用来记录Modem的参数的暂存器,与有关的指
令执行完毕後,Modem会去改变这些参数,但Modem由指令状
态进入连线时,Modem会依照这些参数而决定Modem的功能,
S-Register可由指令之执行而改变,或者也可以由直接改变
S-Register而改变其内容.
Modem的基本指令如下:
AT指令可以为下列几款:(1)非同步指令(2)立即动作指令
(3)MNP错误修正指令(4)拨号修饰指令
.
非同步指令:
B  BELL/CCITT协定设定
B0:设定Modem为CCITT协定
B1:设定Modme为BELL协定
E  回应指令:
此指令可以让使用者选择是否把输入的指令回应显示在
萤幕上.
E0:不回应指令
E1:回应指令
L  喇叭音量控制
L指令控制喇叭的音量
L0:喇叭不响
L1:低音量
L2:中音量
L3:高音量
M  喇叭控制
此指令控制喇叭的开关
M0:喇叭不响
M1:Modem在拨号时,喇叭打开,在连线後,喇叭关掉
M2:喇叭永远ON
Q  Result code 控制指令
Q指令决定Modem要不要送出Result code 到电脑上
Q0:显示Result code
Q1:不显示Result code
Sr= 写入S暂存器
Sr=n 把 n 数据写入第 r 个S暂存器内
Sr? 读取S暂存器
Sr?读取第 r 个S暂存器
V  决定Result code 的格式
V指令选择Result code 的格式
V0:选择数字式的Result code
V1:选择文字式的Result code
X  控制拨号的过程及结果显示
X指令用来控制Modem在拨号过程中是否要辨识拨号音,
忙音及显示结果是否包括速度显示等
X0:Modem在拨号时不辨识号音及忙音,结果也只显示
CONNECT,不显示Modem的速度
X1:Modme拨号时不辨识拨号音及忙音,但结果显示速度,如
CONNECT 1200,CONNECT 2400等
X2:Modem拨号时辨识拨号音,但不辨识忙音,结果显示速度
X3:Modem不辨识拨号音,但是辨识忙音及结果显示速度
X4:Modem辨识拨号音,忙音及结果显示速度
Y  Long Space Break 中止连线
Y指令指使Modem在收到Long Space Break 信号时是否
要中止Modem连线
Y0:在收到Long Space Break时,不中止连线
Y1:在收到Long Space Break时,中止连线
&C 设定RS-232C介面DCD Pin的状态
&C0:设定RS-232C介面DCD Pin(第八Pin)永远ON
&C1:RS-232C介面DCD Pin由信号来决定,当侦测到信号时
DCD ON,否则OFF
.
&D 设定RS-232C介面DTR Pin的状态
&D0:DTR Pin(20pin)永远ON，不理会DTR的控制
&D1:DTR由ON变到OFF时，Modem由连线状态回到到指令状态
&D2:DTR由ON变到OFF时，Modem切断电话线，取消自动回
答及回到指令状态
&D3:DTR由ON变到OFF时，Modem切断电话线，取消自动回
答，并且回到Modem的起始状态
&G Guard Tone的设定
&G0:Modem不送出Guard Tone
&G1:选择Guard Tone为550HZ
&G2:选择Guard Tone为1800HZ
&L 选择拨接或者专线的工作模式
&L0选择Modem为拨接式工作模式
&L1选择Modem为专线式工作模式
&P 选择脉冲式拨号的M/B值
&P0:M/B值为40/60
&P1:M/B值为33/67
&S 控制RS-232C介面DSR Pin的状态
&S0:RS-232C介面DSR Pin(第六Pin)始终为ON
&S1:RS-232C介面DSR Pin由DCD Pin(第八Pin)来决定
.
立即动作指令
A  立即回答
当Modem执行此指令以後，Modem开始侦测Carrier，如果
Carrier侦测到，则进入连线状态
A/ 重覆执行指令
A/指令是唯一前面下必加"AT"的指令.Modem执行此
指令以後，Modem执行上一次已经执行过而且尚暂存在
Command Buffer的指令
D  拨号指令
Modem执行此指令，Modem会依跟在D指令之後的拨号修饰
指令来拨号
H  电话线切换控制
H0:指使Modem切断电话线
H1:指使Modem连线
O  回到连线状态
当Modem因执行ESC code 而回到指令状态时，Modem 可以
由O指令而回到连线状态
Z  重置指令 (RESET)
此指令用来Reset Modem的现行状态
Z指令会使Modem回复到开机起始状态
&F 读取出厂组态设定
&F用来存在ROM中的出厂设定的，载入到Modem的动作组态
区域，而使Modem会执行出厂设定的状态
&W 将动作组态写入非挥发性记忆体中
&W把现在的动作组态写入非挥发性(NN-RAM)记忆体中
等下次开机时，Modem会执行此动作组态
&Z 储存电话号码
此指令是用来将电话号码储存到非挥发性记忆体中，
下次拨号时，可以由S指令而把此电话号码重拨出去
***此指令勿用,以免导至错误动作***
.
拨号修饰指令
P  脉冲拨号
P 指令选择拨号为脉冲式拨号(即转盘式拨号)
T  在复频式拨号
T 指令选择拨号方式为复频式拨号(接键式拨号)
R  在拨号後处於Answer mode
R 指令使Modem在拨号以後进入Answer mode
原来 D 指令使 MODEM 在拨号以後进入 Originate mode,但是
有些Modem的频道只有一个频道,不论拨号或回答皆
只有Originate mode，所以如此种Modem连线即只有用
Answer mode ，在拨号时加入 R 指令，可以使Modem在拨号以
後进入Answer mode.
语法:ATRDT3910324(CR)
W  拨号前等待拨号音
W 指令使Modem在拨号前等待号音，其等待时间由S7来决定.语法:ATDT3210324W123(CR)Modem 在拨123数字之前会先等待拨号音，在等到了拨号音以後才继续拨123，不然会送出"NODIALTONE"，表示等不到拨号音.
@  拨号前等待静音
@指令使Modme在拨号以後,开始等待回铃声,在侦测到回铃声以後,再等5秒钟的静音,然後再继续执行指令,等待回铃声的时间由S7来决定语法:ATDT30221234@123(CR)Modem在拨号302123以後,等待回铃声,在侦测到回铃声以後,再等5秒钟的静音,侦测等5秒钟的静音以後再继续拨号123.
!  闪动
!指令使Modem断线0.5秒,然後再继续拨号
;  拨号後回到指令状态
; 指令使Modem在拨完电话号码以後回到指令状态,继续接受下一个指令.
S  拨存在记忆中的电话号码
S 指令和拨号指令一起用,使Modem拨上次由&Z指令存起来的电话号码
语法:ATDS(CR)
.
主要S暂存器摘要:
暂存器    出厂设定值    范围    单位    功能
--------------------------------------------------------
S0            0        0-255    RING    设定铃响次数回应电话
S1            0        0-255    RING    计算铃响次数
S2          43        0-127  ASCII    ESC code
S3          13        0-127  ASCII    输入字元(CarriageReturn)
S4          10        0-127  ASCII    跳行字元
S5            8        0-127  ASCII    退回字元 (Backspace)
S6            2        0-255    秒      等侯拨号音时间
S7          30        1-60    秒      拨号後等待信时间
S8            2        0-255    秒      逗号暂停时间
S9            6        0-255    0.1秒  信号侦测反应时间
S10          14        0-255    0.1秒  信号消失至挂断电话反应时间
S11        保 留
S12          50        20-255    0.02秒  ESC code前後
S13        保 留
S14至S27 Modem内部状态设定
.
回应码
AT指令相容Modem在执行完指令以後会回应一个码,告诉使用者执行的结果,使用者也只有在收到Modem的回应以後才能继续下达下一个指令,或者继续下一步的动作,所以回应码也是指使使用者下一步要如何进行的指标,如CONNECT及CONNECT 1200就可以告欣使用者须在Modem是在300BPS或者1200BPS传输速度,使用者必须依照此指示送出资料,不然资料传输会发生错误.
回应码摘要:
英 文          代号      意义
-----------------------------------------------------
OK            0      指令执行无误
CONNECT        1      X1状态下表示两台Modem连线成功X2,X3.X4状态下,表示两台MODEM连线成功,而且速度为300BPS
RING          2      铃声进来
NO CARRIER    3      两台 MODEM 连线失败
ERROR          4      指令错误或指令行太长超过40个字
CONNECT 1200  5      两台 MODEM 连线成功,而且速度为1200BPS
NO DIALTONE    6      未侦测到拨号音
BUSY          7      电话线忙碌
NO ANSWER  8  在 @ 指令下, MODEM 在侦测到回铃声以後未侦测到5秒钟的静音
CONNECT 2400  10    两台 MODEM 2400BPS连线成功
一、 一般命令
1、 AT+CGMI 给出模块厂商的标识。
2、 AT+CGMM 获得模块标识。这个命令用来得到支持的频带（GSM 900，DCS 1800 或PCS 1900）。当模块有多频带时，回应可能是不同频带的结合。
3、 AT+CGMR 获得改订的软件版本。
4、 AT+CGSN 获得GSM模块的IMEI（国际移动设备标识）序列号。
5、 AT+CSCS 选择TE特征设定。这个命令报告TE用的是哪个状态设定上的ME。ME于是可以转换每一个输入的或显示的字母。这个是用来发送、读取或者撰写短信。
6、 AT+WPCS 设定电话簿状态。这个特殊的命令报告通过TE电话簿所用的状态的ME。ME于是可以转换每一个输入的或者显示的字符串字母。这个用来读或者写电话簿的入口。
7、 AT+CIMI 获得IMSI。这命令用来读取或者识别SIM卡的IMSI（国际移动签署者标识）。在读取IMSI之前应该先输入PIN（如果需要PIN的话）。
8、 AT+CCID 获得SIM卡的标识。这个命令使模块读取SIM卡上的EF-CCID文件。
9、 AT+GCAP 获得能力表。（支持的功能）
10、 A/ 重复上次命令。只有A/命令不能重复。这命令重复前一个执行的命令。
11、 AT+CPOF 关机。这个特殊的命令停止GSM软件堆栈和硬件层。命令AT+CFUN=0的功能与+CPOF相同。
12、 AT+CFUN 设定电话机能。这个命令选择移动站点的机能水平。
13、 AT+CPAS 返回移动设备的活动状态。
14、 AT+CMEE 报告移动设备的错误。这个命令决定允许或不允许用结果码“+CME ERROR:<xxx>”或者“+CMS ERROR:<xxx>”代替简单的“ERROR”。
15、 AT+CKPD 小键盘控制。仿真ME小键盘执行命令。
16、 AT+CCLK 时钟管理。这个命令用来设置或者获得ME真实时钟的当前日期和时间。
17、 AT+CALA 警报管理。这个命令用来设定在ME中的警报日期/时间。（闹铃）
18、 AT+CRMP 铃声旋律播放。这个命令在模块的蜂鸣器上播放一段旋律。有两种旋律可用：到来语音、数据或传真呼叫旋律和到来短信声音。
19、 AT+CRSL 设定或获得到来的电话铃声的声音级别。
二、 呼叫控制命令
1、 ATD 拨号命令。这个命令用来设置通话、数据或传真呼叫。
2、 ATH 挂机命令。
3、 ATA 接电话。
4、 AT+CEER 扩展错误报告。这个命令给出当上一次通话设置失败后中断通话的原因。
5、 AT+VTD 给用户提供应用GSM网络发送DTMF（双音多频）双音频。这个命令用来定义双音频的长度（默认值是300毫秒）。
6、 AT+VTS 给用户提供应用GSM网络发送DTMF双音频。这个命令允许传送双音频。
7、 ATDL 重拨上次电话号码。
8、 AT%Dn 数据终端就绪（DTR）时自动拨号。
9、 ATS0 自动应答。
10、 AT+CICB 来电信差。
11、 AT+CSNS 单一编号方案。
12、 AT+VGR，AT+VGT 增益控制。这个命令应用于调节喇叭的接收增益和麦克风的传输增益。
13、 AT+CMUT 麦克风静音控制。
14、 AT+SPEAKER 喇叭/麦克风选择。这个特殊命令用来选择喇叭和麦克风。
15、 AT+ECHO 回音取消。
16、 AT+SIDET 侧音修正。
17、 AT+VIP 初始化声音参数。
18、 AT+DUI 用附加的用户信息拨号。
19、 AT+HUI 用附加的用户信息挂机。
20、 AT+RUI 接收附加用户信息。
三、 网络服务命令
1、 AT+CSQ 信号质量。
2、 AT+COPS 服务商选择。
3、 AT+CREG 网络注册。获得手机的注册状态。
4、 AT+WOPN 读取操作员名字。
5、 AT+CPOL 优先操作员列表。
四、 安全命令
1、 AT+CPIN 输入PIN。
2、 AT+CPIN2 输入PIN2。
3、 AT+CPINC PIN的剩余的尝试号码。
4、 AT+CLCK 设备锁。
5、 AT+CPWD 改变密码。
五、 电话簿命令
1、 AT+CPBS 选择电话簿记忆存储。
2、 AT+CPBR 读取电话簿表目。
3、 AT+CPBF 查找电话簿表目。
4、 AT+CPBW 写电话簿表目。
5、 AT+CPBP 电话簿电话查询。
6、 AT+CPBN 电话簿移动动作。这个特殊命令使电话簿中的条目前移或后移（按字母顺序）
7、 AT+CNUM 签署者号码。
8、 AT+WAIP 防止在下一次重起时初始化所有的电话簿。
9、 AT+WDCP 删除呼叫电话号码。
10、 AT+CSVM 设置语音邮件号码。
六、 短消息命令
1、 AT+CSMS 选择消息服务。支持的服务有GSM-MO、SMS-MT、SMS-CB。
2、 AT+CNMA 新信息确认应答。
3、 AT+CPMS 优先信息存储。这个命令定义用来读写信息的存储区域。
4、 AT+CMGF 优先信息格式。执行格式有TEXT方式和PDU方式。
5、 AT+CSAS 保存设置。保存+CSAS和+CSMP的参数。
6、 AT+CRES 恢复设置。
7、 AT+CSDH 显示文本方式的参数。
8、 AT+CNMI 新信息指示。这个命令选择如何从网络上接收短信息。
9、 AT+CMGR 读短信。信息从+CPMS命令设定的存储器读取。
10、 AT+CMGL 列出存储的信息。
11、 AT+CMGS 发送信息。
12、 AT+CMGW 写短信息并存储。
13、 AT+CMSS 从存储器中发送信息。
14、 AT+CSMP 设置文本模式的参数。
15、 AT+CMGD 删除短信息。删除一个或多个短信息。
16、 AT+CSCA 短信服务中心地址。
17、 AT+CSCB 选择单元广播信息类型。
18、 AT+WCBM 单元广播信息标识。
19、 AT+WMSC 信息状态（是否读过、是否发送等等）修正。
20、 AT+WMGO 信息覆盖写入。
21、 AT+WUSS 不改变SMS状态。在执行+CMGR或+CMGL后仍保持UNREAD。
七、 追加服务命令
1、 AT+CCFC 呼叫继续。
2、 AT+CLCK 呼叫禁止。
3、 AT+CPWD 改变追加服务密码。
4、 AT+CCWA 呼叫等待。
5、 AT+CLIR 呼叫线确认限制。
6、 AT+CLIP 呼叫线确认陈述。
7、 AT+COLP 联络线确认陈述。
8、 AT+CAOC 费用报告。
9、 AT+CACM 累计呼叫计量。
10、 AT+CAMM 累计呼叫计量最大值。
11、 AT+CPUC 单价和货币表。
12、 AT+CHLD 呼叫相关的追加服务。
13、 AT+CLCC 列出当前的呼叫。
14、 AT+CSSN 追加服务通知。
15、 AT+CUSD 无组织的追加服务数据。
16、 AT+CCUG 关闭的用户组。
八、 数据命令
1、 AT+CBST 信差类型选择。
2、 AT+FCLASS 选择模式。这个命令把模块设置成数据或传真操作的特殊模式。
3、 AT+CR 服务报告控制。这个命令允许更为详细的服务报告。
4、 AT+CRC 划分的结果代码。这个命令在呼叫到来时允许更为详细的铃声指示。
5、 AT+ILRR 本地DTE-DCE速率报告。
6、 AT+CRLP 无线电通信线路协议参数。
7、 AT+DOPT 其他无线电通信线路参数。
8、 AT%C 数据压缩选择。
9、 AT+DS 是否允许V42二度数据压缩。
10、 AT+DR 是否报告V42二度数据压缩。
11、 AT\N 数据纠错选择。
九、 传真命令
1、 AT+FTM 传送速率。
2、 AT+FRM 接收速率
3、 AT+FTH 用HDLC协议设置传真传送速率。
4、 AT+FRH 用HDLC协议设置传真接收速率。
5、 AT+FTS 停止特定时期的传送并等待。
6、 AT+FRS 接收沉默。
十、 第二类传真命令
1、 AT+FDT 传送数据。
2、 AT+FDR 接收数据。
3、 AT+FET 传送页标点。
4、 AT+FPTS 页转换状态参数。
5、 AT+FK 终止会议。
6、 AT+FBOR 页转换字节顺序。
7、 AT+FBUF 缓冲大小报告。
8、 AT+FCQ 控制拷贝质量检验。
9、 AT+FCR 控制接收传真的能力。
10、 AT+FDIS 当前会议参数。
11、 AT+FDCC 设置DCE功能参数。
12、 AT+FLID 定义本地ID串。
13、 AT+FPHCTO 页转换超时参数。
十一、V24-V25命令
1、 AT+IPR 确定DTE速率。
2、 AT+ICF 确定DTE-DCE特征结构。
3、 AT+IFC 控制DTE-DCE本地流量。
4、 AT&C 设置DCD（数据携带检测）信号。
5、 AT&D 设置DTR（数据终端就绪）信号。
6、 AT&S 设置DST（数据设置就绪）信号。
7、 ATO 回到联机模式。
8、 ATQ 决定手机是否发送结果代码。
9、 ATV 决定DCE响应格式。
10、 ATZ 恢复为缺省设置。
11、 AT&W 保存设置。
12、 AT&T 自动测试。
13、 ATE 决定是否回显字符。
14、 AT&F 回到出厂时的设定。
15、 AT&V 显示模块设置情况。
16、 ATI 要求确认信息。这命令使GSM模块传送一行或多行特定的信息文字。
17、 AT+WMUX 数据/命令多路复用。
十二、特殊AT命令
1、 AT+CCED 电池环境描述。
2、 AT+CCED 自动RxLev指示。
3、 AT+WIND 一般指示。
4、 AT+ALEA 在ME和MSC之间的数据密码模式。
5、 AT+CRYPT 数据密码模式。
6、 AT+EXPKEY 键管理。
7、 AT+CPLMN 在PLMN上的信息。
8、 AT+ADC 模拟数字转换度量。
9、 AT+CMER 移动设备事件报告。这个命令决定是否允许在键按下时是否主动发送结果代码。
10、 AT+WLPR 读取语言偏好。
11、 AT+WLPW 写语言偏好。
12、 AT+WIOR 读取GPIO值。
13、 AT+WIOW 写GPIO值。
14、 AT+WIOM 输入/输出管理。
15、 AT+WAC 忽略命令。这个特殊命令允许忽略SMS、SS和可用的PLMN。
16、 AT+WTONE 播放旋律。
17、 AT+WDTMF 播放DTMF旋律。
18、 AT+WDWL 下载模式。
19、 AT+WVR 配置信差的声音速率。
20、 AT+WDR 配置数据速率。
21、 AT+WHWV 显示硬件的版本。
22、 AT+WDOP 显示产品的出厂日期。
23、 AT+WSVG 声音增益选择。
24、 AT+WSTR 返回指定状态的状态。
25、 AT+WSCAN 扫描。
26、 AT+WRIM 设置或返回铃声指示模式。
27、 AT+W32K 是否允许32kHz掉电方式。
28、 AT+WCDM 改变缺省旋律。
29、 AT+WSSW 显示内部软件版本。
30、 AT+WCCS 编辑或显示订制性质设置表。
31、 AT+WLCK 允许在特定的操作符上个性化ME。
32、 AT+CPHS 设置CPHS命令。
33、 AT+WBCM 电池充电管理。
34、 AT+WFM 特性管理。是否允许模块的某些特性，如带宽模式、SIM卡电压等。
35、 AT+WCFM 商业特性管理。是否允许Wavecom特殊特性。
36、 AT+WMIR 允许从当前存储的参数值创建定制的存储镜像。
37、 AT+WCDP 改变旋律的缺省播放器。
38、 AT+WMBN 设置SIM卡中的不同邮箱号码。
十三、SIM卡工具箱命令
1、 AT+STSF 配置工具箱实用程序。
2、 AT+STIN 工具箱指示。
3、 AT+STGI 获得从SIM卡发来的预期命令的信息。
4、 AT+STCR 主动提供的结果：工具箱控制反应。
```
