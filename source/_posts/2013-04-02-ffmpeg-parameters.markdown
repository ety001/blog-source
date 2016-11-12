---
author: ety001
comments: true
date: 2013-04-02 08:38:28+00:00
layout: post
slug: ffmpeg-parameters
title: ffmpeg参数
wordpress_id: 2347
tags:
- 理论
---

下列为较常使用的参数。

主要参数
    -i 设定输入档名。
    -f 设定输出格式。
    -y 若输出档案已存在时则覆盖档案。
    -fs 超过指定的档案大小时则结束转换。
    -ss 从指定时间开始转换。
    -title 设定标题。
    -timestamp 设定时间戳。
    -vsync 增减Frame使影音同步。

影像参数
    -b 设定影像流量，默认为200Kbit/秒。（ 单位请参照下方注意事项 ）
    -r 设定FrameRate值，默认为25。
    -s 设定画面的宽与高。
    -aspect 设定画面的比例。
    -vn 不处理影像，于仅针对声音做处理时使用。
    -vcodec 设定影像影像编解码器，未设定时则使用与输入档案相同之编解码器。

声音参数
    -ab 设定每Channel （最近的SVN 版为所有Channel的总合）的流量。（ 单位 请参照下方注意事项 ）
    -ar 设定采样率。
    -ac 设定声音的Channel数。
    -acodec 设定声音编解码器，未设定时与影像相同，使用与输入档案相同之编解码器。
    -an 不处理声音，于仅针对影像做处理时使用。
    -vol 设定音量大小，256为标准音量。(要设定成两倍音量时则输入512，依此类推。)

注意事项
以-b及ab参数设定流量时，根据使用的ffmpeg版本，须注意单位会有kbits/sec与bits/sec的不同。（可用ffmpeg -h显示说明来确认单位。）
例如，单位为bits/sec的情况时，欲指定流量64kbps时需输入‘ -ab 64k ’；单位为kbits/sec的情况时则需输入‘ -ab 64 ’。
以-acodec及-vcodec所指定的编解码器名称，会根据使用的ffmpeg版本而有所不同。例如使用AAC编解码器时，会有输入aac与 libfaac的情况。此外，编解码器有分为仅供解码时使用与仅供编码时使用，因此一定要利用ffmpeg -formats 确 认输入的编解码器是否能运作。

范例
将MPEG-1影片转换成MPEG-4格式之范例
ffmpeg -i inputfile.mpg -f mp4 -acodec libfaac -vcodec mpeg4 -b 256k -ab 64k outputfile.mp4

将MP3声音转换成MPEG-4格式之范例
ffmpeg -i inputfile.mp3 -f mp4 -acodec libaac -vn -ab 64k outputfile.mp4

将DVD的VOB档转换成VideoCD格式的MPEG-1档之范例
ffmpeg -i inputfile.vob -f mpeg -acodec mp2 -vcodec mpeg1video -s 352x240 -b 1152k -ab 128k outputfile.mpg
将AVI影片转换成H.264格式的M4V档之范例
ffmpeg -i inputfile.avi -f mp4　-acodec libfaac -vcodec libx264 -b 512k -ab 320k outputfile.m4v
将任何影片转换成东芝REGZA可辨识的MPEG2格式之范例
ffmpeg -i inputfile -target ntsc-svcd -ab 128k -aspect 4:3 -s 720x480 outputfile.mpg
连接复数的AVI影片档之范例（在此范例中须一度暂时将AVI档转换成MPEG-1档(MPEG-1, MPEG-2 PS
DV格式亦可连接)、

ffmpeg -i input1.avi -sameq inputfile_01.mpg

ffmpeg -i input2.avi -sameq inputfile_02.mpg

cat inputfile_01.mpg inputfile_02.mpg > inputfile_all.mpg

ffmpeg -i inputfile_all.mpg -sameq outputfile.avi
