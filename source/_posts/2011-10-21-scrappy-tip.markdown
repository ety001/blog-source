---
author: ety001
comments: true
layout: post
title: 零碎总结
wordpress_id: 1719
tags:
- 后端
---

**1、php页面产生数据存入数据库时，应使用**

```
header("content-type:text/html;charset=utf-8");
```

对php页面的编码格式进行强制设置，并且还需要加入一行代码

```
mysql_query("set names utf8");
```

**2、在做调试的时候，记的给自己添加进去的输出语句写一个不一样的标示性的注释，方便删除测试语句的时候查找。**

**3、这周在解决的一个bug的时候发现，**
jQuery中的$.ajax方法在chrome浏览器和IE浏览器中的执行顺序是不同的，
这还是在网络上搜索出来的。具体的表现如下：

ok.php文件中的js源代码：

```
/*for (i=1;i<15;i++)
{
	alert(i);
	$.get("test.php",{"id":i},function(data){$("#return").append(data+" ")});
}*/
for(i=1;i<15;i++)
{
	//alert(i);
	$.ajax({
		url:"/test.php",
		type:"get",
		data:"id="+i,
		dataType:"text",
		success:function(recvData){
  				$("#return").append(recvData+" ");
  			},
  			error:function(a,b,c){
  				alert("a:"+a+" b:"+b+" c:"+c);
  			},
	});
}

/*$(function(){
	$("header").click(function(){
		testajaxget(1);
	})
});*/
function testajaxget(id)
{
	if(id==15)
	return;
	$.get("test.php",{"id":id},function(data){$("#return").append(data+" ")});
	id++;
	setTimeout("testajaxget("+id+")",1000);
}
```

test.php文件的源代码如下：

```
<?php echo $_GET['id'];?>
```

通过调试运行，可以发现1到14的顺序只有IE浏览器是一直正确的，

而chrome浏览器在不加alert的时候，也是一直正确的，但是加上alert后，
顺序就开始发生变化了，并且是没有规律的。

网络上给出的一种解决方案是用类似ok.php文件中testajaxget()函数里的setTimeout函数让数据提交延时。

而我遇到的这个bug的代码如下：

```
function passAudit(id){
    $.get("/index.php?action=oa|OAContractChargesPassAudit",{"id":id}, function(data){
      if(data=='ok')  window.location.reload();
    });
}
```

问题的表现是，在chrome浏览器下点击那个触发该js函数的超链接时，页面刷新了，

但是id值并没有提交到指定的页面处理，这一点我是通过在if判断前加alert知道的。

但是在if前加alert后，执行时，alert弹出，点击确定后，id就能成功提交了，

而ie下面的表现是，在alert前id就已经提交了，因为alert中有内容出现，

但是点击确定后，却返回到了index.php页面。**这个表现我直到最后还是不明白，这就是所谓的异步吧，对于该问题持续关注……**

最后的解决方法是在if判断后加了一个alert。

**4、对于hidden属性的input不能掉以轻心，下面的几个截图就说明了一个问题：**

最初hidden属性的input在要显示的元素的上方

[![最初hidden属性的input在要显示的元素的上方]({{site.url}}/assets/img/2011/10/1.png)]({{site.url}}/assets/img/2011/10/1.png)

在IE8下的效果就是这样，chrome倒是显示的很正常

[![在IE8下的效果就是这样，chrome倒是显示的很正常]({{site.url}}/assets/img/2011/10/2.jpg)]({{site.url}}/assets/img/2011/10/2.jpg)

修改后显示效果如下

[![修改后显示效果如下]({{site.url}}/assets/img/2011/10/3.png)]({{site.url}}/assets/img/2011/10/3.png)

**5、调试PHP的时候，一定记得先检查每句话的结尾的分号是不是有加！！**

**6、javascript中的变量作用域注意事项：**

虽然在全局作用域中编写代码时可以不适用var语句，但是在声明局部变量的时候，一定要使用var语句。下面的为相关测试代码：

```
scope = "global";
function checkscope() {
    scope = "local";
    document.write(scope);
    myscope = "local";
    domcument.write(myscope);
}
checkscope();
document.write(scope);
document.write(myscope);
```

**7、关于PHP中的empty函数，**

bool **empty** ( [mixed](http://cn2.php.net/manual/zh/language.pseudo-types.php#language.types.mixed) $var )

如果 _var_ 是非空或非零的值，则 **empty()** 返回 **FALSE**。换句话说，

_""_、_0_、_"0"_、**NULL**、**FALSE**、_array()_、_var $var;_ 

以及没有任何属性的对象都将被认为是空的，如果 _var_ 为空，则返回 **TRUE**。

**注意：为空的条件，0这个值也算在其中！！！！**


**8、datediff函数在mysql下只有起始时间、结束时间2个参数。**

**9、PHP删除文件函数unlink()。**

**10、读写相关的问题是永远存在的，**

文件锁就是为了解决这个问题而做的，其实它就是个简单的信号量。读写相关性指由于同时读写文件造成文件数据的随机性冲突。
为了 明确知道在何时通过何种操作对更改或是读取了文件中的那些数据，
有必要对操作进行序列化，原子化，同步化，使用户能确知在何时文件中有什么数据。
文件锁就 是其中一个工具。

文件系统一般有两种锁，共享锁及排它锁，也可被称为读锁和写锁。

文件系统锁的特点：
一个文件打开的时候只能拥有一把锁，就是说在同时，不能给一个文件同时分配两把以上的锁。

读写已被上锁的文件的用户可以持有这把锁，即持有这把锁的用户可以对该文件进行相应的操作，如读或写。用户可以申请持有某个文件锁，如果文件开始无锁，申请持有锁之前先由系统为该文件创建了一把锁，然后该申请者持有它。

持有锁的规则：如果这个文件已拥有一个读（共享）锁，其它用户不能为该文件分配排它锁或只读锁，但可以持有这把锁，也就是说其它用户可以读文件， 但只要该文件被锁住，就没有用户可以对其进行写入。如果该文件已有一把排它锁且已为某用户持有，则没有任何用户可以再持有这把锁，除非持有者解锁。

有一个重要的概念要记住：对文件的操作本身与锁其实没有什么关系，无论文件是否被上锁，用户都可以随意对文件进行正常情况下的任何操作，但操作系 统会检查锁，针对不同的情况给予不同的处理。比如说在无锁的情况下，任何人可以同时对某文件进行任意的读写，当然这样很有可能读写的内容会出现错误——注 意只是内容出错，操作并不会出错。加锁后，某些操作在某些情况下会被拒绝。文件锁的作用并不是保护文件及数据本身，而是保证数据的同步性，因此文件锁只对 持有锁的用户才是真正有效的，也只有所有用户都使用同一种完全相同的方式利用文件锁的限制对文件进行操作，文件锁才能对所有用户有效，否则，只要有一个例 外，整个文件锁的功能就会被破坏。比如，所有人都遵循的开文件，加锁，操作读写，解锁，关闭文件的步骤的话，所有的人操作都不会出现问题，因为基于文件锁 的分配及持有原则，文件中的数据的更新是作为原子操作存在的，是不可分的，因此也是同步的，安全的。但假如某个人不是采取此步骤，那么他在读写时就会出现 问题，不是读不准就是写不进等等。

基于以上原理，对读数据是否锁定这点就值得说说。一般来说，写数据的时候排它锁定是唯一的操作，它这时保证写到文件中的数据是正确的，文件被锁 时，其它用户无法得到该锁，因此无权做任何操作。在读的时候，要视具体情况而定，大多数情况下，如果不需要特别精确或是敏感的数据，无需锁定，因为锁定要 花时间和资源，一个人申请持有锁花不了时间，人一多就有问题了，最主要的是，如果该文件需要被更新的话，假如被上了只读锁，则写入无法进行，因为那些想写 入的用户将得不到排它锁，如果同时申请持有只读锁的人过多的话，排它锁就有可能一直申请不到，这样表现就是文件可能很长时间内无法被写入，显得很慢。一般 来说，写文件的机会相对较少，也更重要，因此主要做好排它锁定，只读锁在多数情况下并无必要。那么只读锁用在何处呢？只读锁其实只对用户本身有用，只读锁 保证用户读到的数据是确实从文件中读到的真实数据，而不是被称为“dirty”的脏数据。其实，这个还是针对那些不用锁的其它用户对文件的误操作，假如文 件上锁，其它用户不一定非要通过锁对文件进行读写，如果他是直接读写的话，对上了锁的文件操作不一定有效，持有读锁的用户可以肯定在他读数据的时候读出来 的是从真实的文件中得到的，而不是同时已被覆盖掉的数据。

因此，在写入的时候上排它锁应该是天经地义的，可以保证这时数据的不会出错。如果你不申请共享锁，可能读出的数据有错误，但对文件本身没有任何影 响，影响只是对用户的，申请共享锁后读出的数据肯定是当时读的时候文件中的真实数据，如果不是为了保证数据的精确性，共享锁可以不加，充其量就是重新读一 次，如果你读它是为了写入，不如直接加排它锁，没有必要用共享锁。

还有一点要强调的是：文件锁只对使用它的用户，而且是按规则使用它的用户才有效，否则，你用你的，我用我的，有的用，有的不用，还是会乱套的，错 误还是会出现的，对同一个文件，只有大家用同一个规则用文件锁，才能保证每个用户在对该文件进行共享操作的时候不会出现读写错误。

**11、当在 Unix 平台上规定路径时，正斜杠 (/) 用作目录分隔符。而在 Windows 平台上，正斜杠 (/) 和反斜杠 (\) 均可使用。**

**12、MYSQL数据库UTF8编码使用汉字拼音第一个字母排序的方法，**

```
select * from tag order by convert(tag USING gbk) COLLATE gbk_chinese_ci limit 100
```

SQL语句里滑润油convert函数转换一下即可。

**13、在mysql中一次插入多条数据，**

```
INSERT INTO users(name, age) VALUES('姚明', 25), ('比尔.盖茨', 50), ('火星人', 600);
```

**14、在制作列表页的时候，可以使用mb_strimwidth函数限制简介字数。**

```
<?php
echo mb_strimwidth("Hello World", 0, 10, "...");
?>
```

**15、strip_tags() 函数剥去 HTML、XML 以及 PHP 的标签。**

**16、func_num_args() 获取当前函数调用时提交的参数个数。**

**17、GD库控制图片生成质量的参数是负责最后生成图片的函数的第三个参数！（我勒个去。。。害我为了实现压缩图片功能找了大半天。。。）**

**18、parse_str() 函数把查询字符串解析到变量中**

**19、file_get_contents() 函数把整个文件读入一个字符串中**

**20、stream_set_blocking() — Set blocking/non-blocking mode on a stream**

**21、imagecopyresized()，**

Note:因为调色板图像限制（255+1种颜色）有个问题。
重采样或过滤图像通常需要多于255种颜色，计算新的被重采样的像素及其颜色时采用了一种近似值。对调色板图像尝试分配一个新颜色时，如果失败我们选择了计算结果最接近（理论上）的颜色。这并不总是视觉上最接近的颜色。这可能会产生怪异的结果，例如空白（或者视觉上是空白）的图像。要跳过这个问题，请使用真彩色图像作为目标图像，例如用 imagecreatetruecolor() 创建的。

**22、解决跨域session失效问题，在php中加上**

```
header('P3P: CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"');
```

**23、touch函数**

bool **touch** ( string $filename [, int $time [, int $atime ]] )

尝试将由 filename 给出的文件的访问和修改时间设定为给出的时间。
如果没有给出可选参数 time，则使用当前系统时间。
如果给出了第三个参数 atime，则给定文件的访问时间会被设为 atime。
注意访问时间总是会被修改的，不论有几个参数。
如果文件不存在，则会被创建。成功时返回 TRUE， 或者在失败时返回 FALSE.

**24、function gethostbyname — Get the IPv4 address corresponding to a given Internet host name**

**25、FIND_IN_SET()可以用来处理类似3,6,34,67,235这样的存在某个字段中的字符串。**

**26、du --max-depth=1 -h  查目录深度为一的目录大小。**

**27、获取根目录的一种方式：**

```
//其中ntalker/install.php是当前文件
if(!defined('APP_ROOT_PATH')){
	define('APP_ROOT_PATH', str_replace('ntalker/install.php', '', str_replace('\\', '/', __FILE__)));
}
```
