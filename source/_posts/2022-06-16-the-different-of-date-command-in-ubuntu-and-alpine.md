---
author: ety001
date: 2022-06-16 13:25:31+00:00
layout: post
title: The different of date command in Ubuntu and Alpine
tags:
- Server&OS
---

Today I found the `date` command has different performance when I develop a bash shell.

In Ubuntu OS:

```
-> % date -d '2022-06-16T23:21:03' +%s
1655421663
```

The same command in Alpine OS. This will give an error message:

```
/ # date -d '2022-06-16T23:21:03' +%s
date: invalid date '2022-06-16T23:21:03'
```

We have to remove the letter `T` from the time string.
```
/ # date -d '2022-06-16 23:21:03' +%s
1655421663
```
