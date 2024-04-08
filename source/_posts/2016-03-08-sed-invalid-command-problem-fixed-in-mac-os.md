---
title: 解决MacOS的Sed报invalid command错误
author: ety001
tags:
- Server&OS
layout: post
---

这两天再更换博客的主题，顺便把博客内的文章分类重新整理下。

由于有一部分的tag的更改具有重复性，为了省力气，就用sed来完成批量替换。
进入`_post`文件件后执行下面的命令，遇到了`invalid command`的错误,

```
➜  _posts git:(new_theme) sed -i "s/categories/tags/g" `grep "categories" -rl ./`

sed: 1: ".//2010-11-19-16-days-r ...": invalid command code .
```

对命令修改了好几个样子，都是报`invalid command code`，最后在stackoverflow找到了答案，
<http://stackoverflow.com/a/7573438/2086146>，原来是需要再增加个参数来选择是否备份源文件。

即命令可以修改成下面的样子：

```
➜  _posts git:(new_theme) sed -i.back "s/categories/tags/g" `grep "categories" -rl ./`
```

这样，`sed`命令会把源文件备份出一个后缀为`.back`的文件，然后在源文件里进行修改。
如果想直接替换源文件，可以修改成下面的样子：

```
➜  _posts git:(new_theme) sed '' -i "s/categories/tags/g" `grep "categories" -rl ./`
```

最后打印了下`sed`的`help`，的确是有个参数，不过没有写怎么用。。

```
➜  ety001.github.io git:(master) ✗ sed --help
sed: illegal option -- -
usage: sed script [-Ealn] [-i extension] [file ...]
       sed [-Ealn] [-i extension] [-e script] ... [-f script_file] ... [file ...]
```

