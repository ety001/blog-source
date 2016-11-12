---
author: ety001
date: 2011-09-17 08:28:55+00:00
layout: post
title: 40条优化php代码的小实例
wordpress_id: 1619
tags:
- 编程语言
- 后端
---

1、如果一个方法能被静态，那就声明他为静态的，速度可提高1/4；

2、echo的效率高于print,因为echo没有返回值，print返回一个整型；

3、在循环之前设置循环的最大次数，而非在在循环中；

4、销毁变量去释放内存，特别是大的数组；

5、避免使用像`__get`, `__set`, `__autoload`等魔术方法；

6、requiere_once()比较耗资源；
<!-- more -->
7、在includes和requires中使用绝对路径，这样在分析路径花的时间更少；

8、如果你需要得到脚本执行时的时间，`$_SERVER['REQUSET_TIME']`优于time()；

9、能使用字符处理函数的，尽量用他们，因为效率高于正则；

10、str_replace字符替换比正则替换preg_replace快，但strtr比str_replace又快1/4；

11、如果一个函数既能接受数组又能接受简单字符做为参数，例如字符替换，并且参数列表不是太长，可以考虑多用一些简洁的替换语句，一次只替换一个字符，而不是接受数组做为查找和替换参数。大事化小，1+1>2；

12、用@掩盖错误会降低脚本运行速度；

13、$row['id']比$row[id]速度快7倍，建议养成数组键加引号的习惯；

14、错误信息很有用；

15、在循环里别用函数，例如For($x=0； $x < count($array)； $x), count()函数在外面先计算；

16、在方法里建立局部变量速度最快，几乎和在方法里调用局部变量一样快；

17、建立一个全局变量要比局部变量要慢2倍；

18、建立一个对象属性（类里面的变量）例如（$this->prop++）比局部变量要慢3倍；

19、建立一个未声明的局部变量要比一个初始化的局部变量慢9-10倍；

20、声明一个未被任何一个函数使用过的全局变量也会使性能降低（和声明相同数量的局部变量一样），PHP可能去检查这个全局变量是否存在；

21、方法的性能和在一个类里面定义的方法的数目没有关系，因为我添加10个或多个方法到测试的类里面（这些方法在测试方法的前后）后性能没什么差异；

22、在子类里方法的性能优于在基类中；

23、只调用一个参数并且函数体为空的函数运行花费的时间等于7-8次$localvar++运算，而一个类似的方法（类里的函数）运行等于大约15次$localvar++运算；

24、Surrounding your string by ‘ instead of ” will make things interpret a little faster since php looks for variables inside “…” but not inside ‘…’. Of course you can only do this when you don’t need to have variables in the string.

25、当输出字符串时用逗号代替点分割更快些。注意：这只对echo起作用，这个函数能接受一些字符串作为参数；

26、在apache服务器里一个php脚本页面比相应的HTML静态页面生成至少要多花2-10倍的时间，建议多用些静态HTML页面和少量的脚步；

27、除非你的安装了缓存，不然你的php脚本每次被访问都需要被重编译。建议安装个php缓存程序，这样通过去除一些重复的编译来很明显的提高你20-100%的性能；

28、建议用memcached，高性能的分布式内存对象缓存系统，提高动态网络应用程序性能，减轻数据库的负担；

29、使用ip2long()和long2ip()函数把IP地址转成整型存放进数据库而非字符型。这几乎能降低1/4的存储空间。同时可以很容易对地址进行排序和快速查找；

30、使用checkdnsrr()通过域名存在性来确认部分email地址的有效性，这个内置函数能保证每一个的域名对应一个IP地址；

31、如果你在使用php5和mysql4.1以上的版本，考虑使用mysql_*的改良函数mysqli_*；

32、试着喜欢使用三元运算符（？：）；

33、在你想在彻底重做你的项目前，看看PEAR有没有你需要的。PEAR是个巨大的资源库，很多php开发者都知道；

34、使用highlight_file()能自动打印一份很好格式化的页面源代码的副本；

35、使用error_reporting(0)函数来预防潜在的敏感信息显示给用户。理想的错误报告应该被完全禁用在php.ini文件里。可是 如果你在用一个共享的虚拟主机，php.ini你不能修改，那么你最好添加error_reporting(0)函数，放在每个脚本文件的第一行（或用 require_once()来加载）这能有效的保护敏感的SQL查询和路径在出错时不被显示；

36、使用 gzcompress() 和gzuncompress()对容量大的字符串进行压缩（解压）在存进（取出）数据库时。这种内置的函数使用gzip算法能压缩到90%；

37、通过参数变量地址得引用来使一个函数有多个返回值。你可以在变量前加个“&”来表示按地址传递而非按值传递；

38、Fully understand “magic quotes” and the dangers of SQL injection. I’m hoping that most developers reading this are already familiar with SQL injection. However, I list it here because it’s absolutely critical to understand. If you’ve never heard the term before, spend the entire rest of the day googling and reading.

39、使用strlen()因为要调用一些其他操作例如lowercase和hash表查询所以速度不是太好，我们可以用isset()来实现相似的功能，isset()速度优于strlen()；

40、When incrementing or decrementing the value of the variable $i++ happens to be a tad slower then ++$i. This is something PHP specific and does not apply to other languages, so don’t go modifying your C or Java code thinking it’ll suddenly become faster, it won’t. ++$i happens to be faster in PHP because instead of 4 opcodes used for $i++ you only need 3. Post incrementation actually causes in the creation of a temporary var that is then incremented. While pre-incrementation increases the original value directly. This is one of the optimization that opcode optimized like Zend’s PHP optimizer. It is a still a good idea to keep in mind since not all opcode optimizers perform this optimization and there are plenty of ISPs and servers running without an opcode optimizer.
