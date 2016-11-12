---
author: ety001
layout: post
title: 从Thinkphp框架Sae版Log中提取ERR日志
tags:
- Server&OS
---

今天线上遇到一个bug无法解决，于是去查Log，发现Thinkphp的Log设置的全开，很详细。
但是里面掺杂着很多无用的信息，于是需要写个脚本提取下，也为了日后高效处理日志。

脚本如下：

```
#!/bin/bash
read -p "Enter Filename: " filename
read -p "Enter Output Filename: " outputfilename
awk 'BEGIN{
    linestart=1;
    lineend=0;
    iserr=0;
    total=0;
}
{
    arr[NR]=$0;
    if($0 ~/ERR/){
        iserr=1;
    }
    if($9 ~/^###/){
        lineend=NR-1;
        if(lineend!=0){
            if(iserr==1){
                for(i=linestart;i<=lineend;i++){
                    print arr[i];
                    delete arr[i];
                }
                print "";
                total++;
                iserr=0;
            } else {
                for(i=linestart;i<=lineend;i++){
                    delete arr[i];
                }
            }
            linestart=NR;
        }
    }
}
END{
    if(iserr==1){
        for(i=linestart;i<=NR;i++){
            print arr[i];
            delete arr[i];
        }
        print "";
        total++;
    } else {
        for(i=linestart;i<=NR;i++){
            delete arr[i];
        }
    }
    print "Total ERR:",total;
}' $filename > $outputfilename

```

样例数据：

[点击这里下载样例数据](/upload/20150314/samplefile)

