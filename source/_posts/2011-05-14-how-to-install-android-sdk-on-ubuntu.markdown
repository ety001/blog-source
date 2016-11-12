---
author: ety001
date: 2011-05-14 08:39:11+00:00
layout: post
title: 如何在ubuntu上安装Android SDK
wordpress_id: 1369
tags:
- 翻译
---

这是一篇从softpedia.com翻译过来的文章（只翻译了下载安装部分），原文章出处：[http://news.softpedia.com/news/How-to-Run-Android-Applications-on-Ubuntu-115152.shtml](http://news.softpedia.com/news/How-to-Run-Android-Applications-on-Ubuntu-115152.shtml)（How to Run Android Applications on Ubuntu）

因为这是ETY001第一次翻译外文文章，所以不准确或者错误的地方，还请老鸟能够指正，谢谢！

当google在2008年10月发布Android系统原来，每个人都知道这将会是手机上最好的操作系统，这不仅仅因为他是一个开源的操作系统，更重要的是他同样是一个可以为开发者提供必要的API接口和实用工具的软件开发工具包，而这些可以使开发者更加轻松的制作出给力的Android应用。下面的文章的目的就是为了告诉那些想要在安装有Ubuntu操作系统的电脑上测试Android平台及其应用的人们如何实现你们的这一想法的。OK，让我们开始吧……

从domyself.me获取Android SDK，并把他放到你的主目录下，下载地址：http://www.domyself.me/android.tgz。


**Step 1**** - ****安装必要****的环境**

下载结束前，你需要再确定一下你是否已经安装Java和32位库（64位用户是64位库）。如果你还没有安装这两项，那么选择 系统->系统管理->新立得软件包管理器
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_001.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_001.jpg)
</td>
</tr>
</tbody>
</table>

...在搜索框中输入 **openjdk** 然后双击选择 **openjdk-6-jre** 这项...
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_002.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_002.jpg)
</td>
</tr>
</tbody>
</table>

...然后再在搜索框中输入 ia32-libs (这一项只针对64位用户)，选择 **ia32-libs** 项双击选中...
<table cellpadding="2" width="501" cellspacing="0" >
<tbody >
<tr >

<td width="497" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_003.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_003.jpg)
</td>
</tr>
</tbody>
</table>

现在，点击“应用”按钮开始安装这些包。当这些安装结束后，即可关闭新立得软件包管理器了。

**Step 2**** - ****Android ****SDK****的安装**

下载完 Android SDK 后，右击该压缩包，选择解压到这里一项（ETY001插话：你也可以选择一个别的目录进行解压，不过建议是在你的主目录里，因为你不用再考虑权限问题）...
<table cellpadding="2" width="441" cellspacing="0" >
<tbody >
<tr >

<td width="437" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_004.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_004.jpg)
</td>
</tr>
</tbody>
</table>

进入已解压的文件目录，然后进入tools目录双击 **android** ，这时系统会询问你想要做什么，你点击"运行"按钮就可以打开 Android SDK and AVD 管理器啦...
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_020.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_020.jpg)
</td>
</tr>
</tbody>
</table>

进入"Settings"选项卡确认一下 "Force https://..."这一项是否是选中状态，如果没有则选中，然后点击"Save & Apply"按钮....
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_021.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_021.jpg)
</td>
</tr>
</tbody>
</table>

接下来进入"Installed Packages"选项卡然后点击"Update All"按钮，一个窗口会出现，里面显示了所有可用的升级内容，点击"Install Accepted"按钮（ETY001插话：我在实际操作的时候，点击Update All按钮后其实是先弹出了一个窗口，貌似是进行升级列表的更新，有点像Ubuntu更新的时候先更新列表然后提示你可选的升级包。还有就是列表更新的时候，我这边连接貌似是三星的一个android镜像站超时了）...
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_022.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_022.jpg)
</td>
</tr>
</tbody>
</table>

...然后等待升级包的下载和安装。整个过程将花费一段时间，这取决于你的带宽，所以你现在可以去看个电影或者做点别的（ETY001插话：开始下载安装升级包的确需要很长的时间，比如说我从开始下载安装升级包就在这里翻译这篇文章，写到这里了才刚刚更新完……）
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_023.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_023.jpg)
</td>
</tr>
</tbody>
</table>

更新结束后关闭更新窗口，你将会在"Installed Packages" 选项卡中的列表里看到所有已安装的SDK。

现在让我们来创建虚拟设备。选择"Virtual Device"选项卡，然后点击"New"按钮，在打开的新窗口中有以下几项：

- 输入虚拟设备的名字（Name）;
- 选择一个Android system（Target）;
- 设置SD卡的容量或者指定一个已有的SD卡;
- 在你当前正在建立的虚拟设备中添加更多硬件功能;

- 如果你的SDK版本比较新，可能还会有一项Snapshot（截屏）.

下面的截图是个示例...
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_024.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_024.jpg)
</td>
</tr>
</tbody>
</table>

当你配置完虚拟设备后，点击"Create AVD"按钮，稍等片刻即可完成配置。整个过程可能会花费大约1分钟，之后会有个窗口弹出通知你完成...
<table cellpadding="2" width="524" cellspacing="0" >
<tbody >
<tr >

<td width="520" valign="TOP" >[![](http://i1-news.softpedia-static.com/images/extra/LINUX/small/androidubuntu-small_025.png)](http://i1-news.softpedia-static.com/images/extra/LINUX/large/androidubuntu-large_025.jpg)
</td>
</tr>
</tbody>
</table>

备注**：** 在上面的配置过程中，我们创建了一个Android2.0.1系统加一个2GB SD卡的虚拟设备，另外其他的硬件配置有：**SD Card, GPS, Accelerometer, Track-ball ****和**** touch-screen.**

现在点击"Start"按钮，然后再接下来的对话框里选择"Launch"按钮，好了设备开启啦～
