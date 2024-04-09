---
author: ety001
comments: true
date: 2013-10-10 18:58:57
layout: post
slug: pxelinux-default-config-comment
title: pxelinux中default配置文件的注释
wordpress_id: 2500
tags:
- Server&OS
---

```
# 默认启动的是 'label linux' 中标记的内核
default linux

# 显示 'boot: ' 提示符。
# 为 '0' 时则不提示，将会直接启动 'default' 参数中指定的内容。
prompt 1

# 在用户输入之前的超时时间，单位为 1/10 秒。
timeout 600

# 显示某个文件的内容，注意文件的路径。默认是在 /tftpboot 目录下。
# 也可以指定位类似 'install/rhel4.4-inst/boot.msg' 这样的，路径+文件名。
display boot.msg

# 按下 'F1' 这样的键后显示的文件。注意路径。默认是 /tftpboot。
# 注：syslinux 官方网站上说目前只能使用 F1-F10。
F1 install/rhel4.4-inst/boot.msg
F2 install/rhel4.4-inst/options.msg
#...
F10 install/rhel4.4-inst/snake.msg

# 'label' 指定你在 'boot:' 提示符下输入的关键字。
# 比如：
#     boot: linux[ENTER]
# 这个会启动 'label linux' 下标记的 kernel 和 initrd.img 文件。
# 这里还定义了其它几个关键字：
#     boot: text
#     boot: ks
#
# kernel 参数指定要启动的内核。同样要注意路径，默认是 /tftpboot 目录。
# append 指定追加给内核的参数，能够在 gurb 里使用的追加给内核的参数，在这里也
#        都可以使用。
label linux
  kernel install/rhel4.4-inst/vmlinuz
  append initrd=install/rhel4.4-inst/initrd.img ramdisk_size=8192

label text
  kernel vmlinuz
  append initrd=install/rhel4.4-inst/initrd.img text ramdisk_size=8192
label expert
  kernel vmlinuz
  append expert initrd=install/rhel4.4-inst/initrd.img ramdisk_size=8192

# 使用 kickstart 安装。
# 可以在 ks 参数后直接指定 kickstart 文件的位置。
# 关于 kickstart 的更多参数和设置，请参考各版本的 RHEL 的 Installation Guide：
# * http://www.redhat.com/docs/manuals/enterprise/
#     Installation Guide --> Advanced Installation and Deployment

label ks basic
  kernel install/rhel4.4-inst/vmlinuz
  append ks=ftp://192.168.10.251/install/rhel4.4_basic.cfg initrd=install/rhel4.4-inst/initrd.img ramdisk_size=8192

label lowres
  kernel vmlinuz
  append initrd=install/rhel4.4-inst/initrd.img lowres ramdisk_size=8192
label local
  localboot 1
label memtest86
  kernel memtest
  append -
```

