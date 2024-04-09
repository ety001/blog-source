---
author: ety001
date: 2011-06-22 02:37:58
layout: post
title: Html5本地数据库实例
wordpress_id: 1393
tags:
- 编程语言
- 前端
---

```
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="gb2312" />
        title>HTML5 WebDatabase</title>
        <script>
            var db=""
            window.onload=function(){
                if(window.openDatabase){
                    //打开数据库，不存在数据库则会自动创建
                    db = window.openDatabase("test", "1.0", "HTML5 Database API example", 200000);
                    //创建表
                    db.transaction(
                        function(tx){
                            tx.executeSql(
                                "create table oo(id REAL UNIQUE, text TEXT)",
                                [],
                                function(tx){alert("创建表成功");},
                                function(tx, error){alert("创建表失败，错误信息:"+error.message );}
                            );
                        }
                    );
                }
                else{
                    alert("不支持WebDatabase");
                }

            }

            //删除数据库表
            function drop(){
                db.transaction(
                    function(tx){
                        tx.executeSql(
                            "drop table oo",
                            [],
                            function(tx){alert('删除数据库表成功');},
                            function(tx,error){alert("删除数据库表失败，错误信息:"+error.message);}
                        );
                    }
                );

                //释放资源
                db = null;
            }

            function add(){
                var num = Math.round(Math.random() * 10000); // random data
                var value = document.getElementById("text").value;
                db.transaction(
                    function(tx){
                        tx.executeSql(
                            "insert into oo(id,text) values(?,?)",
                            [num,value],
                            function(tx){alert("添加成功");},
                            function(tx, error){alert("添加数据失败，错误信息:"+error.message);}
                        );
                    }
                );
            }

            function show(){
                db.transaction(
                    function(tx){
                        tx.executeSql(
                            "select * from oo",
                            [],
                            function(tx, result){
                                for(var i = 0; i < result.rows.length; i++){
                                    var item = result.rows.item(i);
                                    alert(item['id']+":"+item['text']);
                                }
                            },
                            function(tx,error){alert("查询数据失败，错误信息:"+error.message);}
                        );
                    }
                );

            }
        </script>
    </head>

    <body>
        <input  type="text" id="text"/><br/>
        <input type="button" value="增加" onclick="add()"/><br/>
        <input type="button" value="查询" onclick="show()"/><br/>
        <input type="button" value="删除表" onclick="drop()"/><br/>
    </body>

    </html>
```

