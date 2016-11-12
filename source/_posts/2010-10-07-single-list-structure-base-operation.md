---
author: ety001
date: 2010-10-07 10:27:06+00:00
layout: post
title: 单链表的基本操作
wordpress_id: 136
tags:
- 编程语言
- 后端
---

对于已建立的链表，通过头指针可访问整个链表，输出链表中所有结点，统计链表结点个数及插入、删除结点。

下面以刚才建立的单链表为例进行分析，给出相应操作的实现函数。

    注意两点：
    (1)将链表传递进函数，只需将链表头指针传递进函数。函数的形参对应实参头指针。
    (2)对链表的访问用条件循环控制，循环的条件是结点的指针域非空。

1．**输出链表中所有结点**

```
void print(struct linklist*head)/*输出链表所有结点*/
{
    struct linklist*P;
    p=head;/*P指向链表第一个结点*/
    while(p!=NULL)
    {
        printf("％d", p-->data);
        p=p->next
    }/*P指向下一个结点*/
}
```

2．**统计链表中结点个数**

只需将上述输出结点改成计数即可。

```
int count(struct linklist*head)/*统计链表中结点个数*/
{
    int n=0;
    struct linklist*P;
    p=head;
    while(p!=NULL)
    {
        n++;
        P=P->nextl;
    }
    return(n);
}
```

3．**插入操作**

仅讨论将X插入到第i个结点之后的情况，其它情形请读者分析。

先找到第i个结点，然后为插入数据申请一个存储单元，并将插入结点链接在第i个结点后，再将原第i+1个结点链接在插入结点后，完成插入操作。

```
void ins(struct linklist*head，int i，int x)/*插入结点*/
{
    int j;
    struct linklist*P, *q;
    p=head;
    j=1;
    while( (pj=NULL) && (j < i) )/*找插入位置*/
    {
        P=p->next;
        j++;
    }
    q=(struet linklist*)malloc(sizeof(struet linklist));/*产生插入结点*/
    q->data=x;
    q->next=p->next;/’q插入P之后*/
    p->next=q;
}
```

本函数可作一些修改，插入成功返回函数值1，插入不成功返回函数值0。

4．**删除操作**

假设删除链表中第i个结点，先找到第i—1个结点和第i个结点，然后将第i+1个结点链接在第i一1个结点后，再释放第i个结点所占空间，完成删除操作。

```
void del(struct linklist*head, int i)/*删除结点*/
{
    int j;
    struct linklist*P, *q;
    P=head;
    j=1;
    while((p != NULL)&& (j < i))/*找第i-1个结点和第i个结点指针q、P*/
    {
        q=p;
        p=p->next;
        j++;
    }
    if(p==NULL)printf(”找不到结点!”)；
    else
    {
        q->next=p->next;/*删除第i个结点*/
        free(p);
    }
}
```

双链表有两个指针域，一个指针指向左边结点，一个指针指向右边结点，用头指针表示开始结点，用尾指针表示结尾结点。例如：

```
struct linklist
{
    int data;
    struct linklist*Uink，*rlink;
};
struct linklist*head *rear;
```

