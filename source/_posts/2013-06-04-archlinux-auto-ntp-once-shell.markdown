---
author: ety001
comments: true
date: 2013-06-04 23:30:46+00:00
layout: post
slug: archlinux-auto-ntp-once-shell
title: Archlinux开机自动同步时间脚本
wordpress_id: 2391
tags:
- Server&OS
---

Write a _oneshot_ [systemd](https://wiki.archlinux.org/index.php/Systemd) unit:


    /usr/lib/systemd/system/ntp-once.service
    [Unit]
    Description=Network Time Service (once)
    After=network.target nss-lookup.target

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/ntpd -q -g -u ntp:ntp ; /sbin/hwclock -w

    [Install]
    WantedBy=multi-user.target


and enable it:


    # systemctl enable ntp-once
