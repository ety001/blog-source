---
author: ety001
date: 2011-01-22 14:20:26+00:00
layout: post
title: Ubuntu下安装MySQL获得 mysql.h 建立C接口
wordpress_id: 901
tags:
- 编程语言
---

在Ubuntu下费了好长时间终于让C操作MySQL成功了，在此把方法记下来，留着以后用。先安装MySQL
代码:

```
sudo apt-get install mysql-server mysql-client
```

再装开发包
代码:

```
sudo apt-get install libmysqlclient15-dev
```

安装完以后，C代码里添加头文件

代码:
#include
编译方法：
代码:

```
gcc $(mysql_config --cflags) xxx.c -o xxx $(mysql_config --libs)
```


可以用以下代码测试一下

代码:

```
/* Simple C program that connects to MySQL Database server*/
#include
#include

main() {
MYSQL *conn;
MYSQL_RES *res;
MYSQL_ROW row;

char *server = "localhost";
char *user = "root";
char *password = ""; /* 此处改成你的密码 */
char *database = "mysql";

conn = mysql_init(NULL);

/* Connect to database */
if (!mysql_real_connect(conn, server,
user, password, database, 0, NULL, 0)) {
fprintf(stderr, "%s\n", mysql_error(conn));
exit(1);
}

/* send SQL query */
if (mysql_query(conn, "show tables")) {
fprintf(stderr, "%s\n", mysql_error(conn));
exit(1);
}

res = mysql_use_result(conn);

/* output table name */
printf("MySQL Tables in mysql database:\n");
while ((row = mysql_fetch_row(res)) != NULL)
printf("%s \n", row[0]);

/* close connection */
mysql_free_result(res);
mysql_close(conn);
}
```

会输出现有数据库和表内容。
