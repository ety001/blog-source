---
author: ety001
date: 2010-12-31 17:04:10+00:00
layout: post
title: 自动换行 word-break:break-all和word-wrap:break-word
wordpress_id: 801
tags:
- 前端
---

word-break:break-all和word-wrap:break-word都是能使其容器如DIV的内容自动换行。

它们的区别就在于：

1，word-break:break-all 例如div宽200px，它的内容就会到200px自动换行，如果该行末端有个英文单词很长（congratulation等），它会把单词截断，变成该行末端为conra(congratulation的前端部分)，下一行为tulation（conguatulation）的后端部分了。

2，word-wrap:break-word 例子与上面一样，但区别就是它会把congratulation整个单词看成一个整体，如果该行末端宽度不够显示整个单词，它会自动把整个单词放到下一行，而不会把单词截断掉的。

3，word-break;break-all 支持版本：IE5以上 该行为与亚洲语言的 normal 相同。也允许非亚洲语言文本行的任意字内断开。该值适合包含一些非亚洲文本的亚洲文本。 WORD-WRAP:break-word 支持版本：IE5.5以上 内容将在边界内换行。如果需要，词内换行( word-break )也将发生。表格自动换行，避免撑开。 word-break : normal | break-all | keep-all 参数： normal : 依照亚洲语言和非亚洲语言的文本规则，允许在字内换行 break-all : 该行为与亚洲语言的normal相同。也允许非亚洲语言文本行的任意字内断开。该值适合包含一些非亚洲文本的亚洲文本 keep-all : 与所有非亚洲语言的normal相同。对于中文，韩文，日文，不允许字断开。适合包含少量亚洲文本的非亚洲文本 语法： word-wrap : normal | break-word 参数： normal : 允许内容顶开指定的容器边界 break-word : 内容将在边界内换行。如果需要，词内换行（word-break）也行发生说明：设置或检索当当前行超过指定容器的边界时是否断开转行。

对应的脚本特性为wordWrap。请参阅我编写的其他书目。 语法： table-layout : auto | fixed 参数： auto : 默认的自动算法。布局将基于各单元格的内容。表格在每一单元格读取计算之后才会显示出来。速度很慢 fixed : 固定布局的算法。在这算法中，水平布局是仅仅基于表格的宽度，表格边框的宽度，单元格间距，列的宽度，而和表格内容无关说明：设置或检索表格的布局算法。对应的脚本特性为tableLayout。

建议：word-break 用3C检测会显示问题的，导致百度快照也会出问题-这个属性OPERA FIREFOX 浏览器也不支持 word-break属性可以用white-space:normal;来代替，这样在FireFox和IE下就都能正确换行，而且要注意，单词间的空格不能用 来代替，不然不能正确换行。
