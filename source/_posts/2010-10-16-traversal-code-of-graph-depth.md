---
author: ety001
comments: true
date: 2010-10-16 16:16:23+00:00
layout: post
slug: 'traversal-code-of-graph-depth'
title: 图的深度遍历源代码
wordpress_id: 318
tags:
- 编程语言

---

对于图的深度遍历相信学过数据结构的人都不会陌生吧，有时间，所以写了个图的深度遍历源代码，拿出来给大家分享一下。

```
#include <stdio.h>
#include <malloc.h>
#define INFINITY 32767
#define MAX_VEX 20 //最大顶点个数
bool *visited;  //访问标志数组

//图的邻接矩阵存储结构
typedef struct{
  char *vexs; //顶点向量
  int arcs[MAX_VEX][MAX_VEX]; //邻接矩阵
  int vexnum,arcnum; //图的当前顶点数和弧数
}Graph;

//图G中<!-- more -->查找元素c的位置
int Locate(Graph G,char c){
  for(int i=0;i<G.vexnum;i++)
  if(G.vexs[i]==c) return i;
  return -1;
}

//创建无向网

void CreateUDN(Graph &G){
  int i,j,w,s1,s2;
  char a,b,temp;
  printf("输入顶点数和弧数:");
  scanf("%d%d",&G.vexnum,&G.arcnum);
  temp=getchar(); //接收回车
  G.vexs=(char *)malloc(G.vexnum*sizeof(char)); //分配顶点数目
  printf("输入%d个顶点.\n",G.vexnum);
  for(i=0;i<G.vexnum;i++){ //初始化顶点
    printf("输入顶点%d:",i);
    scanf("%c",&G.vexs[i]);
    temp=getchar(); //接收回车 
  }

  for(i=0;i<G.vexnum;i++) //初始化邻接矩阵
    for(j=0;j<G.vexnum;j++)
      G.arcs[i][j]=INFINITY;

  printf("输入%d条弧.\n",G.arcnum);
  for(i=0;i<G.arcnum;i++){ //初始化弧
    printf("输入弧%d:",i);
    scanf("%c %c %d",&a,&b,&w); //输入一条边依附的顶点和权值
    temp=getchar(); //接收回车
    s1=Locate(G,a);
    s2=Locate(G,b);
    G.arcs[s1][s2]=G.arcs[s2][s1]=w;
  }
}

//图G中顶点k的第一个邻接顶点
int FirstVex(Graph G,int k){
  if(k>=0 && k<G.vexnum){ //k合理
    for(int i=0;i<G.vexnum;i++)
      if(G.arcs[k][i]!=INFINITY) return i;
  }
  return -1;
}

//图G中顶点i的第j个邻接顶点的下一个邻接顶点
int NextVex(Graph G,int i,int j){
  if(i>=0 && i<G.vexnum && j>=0 && j<G.vexnum){ //i,j合理
    for(int k=j+1;k<G.vexnum;k++)
      if(G.arcs[i][k]!=INFINITY) return k;
  }
  return -1;
}

//深度优先遍历
void DFS(Graph G,int k){
  int i;
  if(k==-1){ //第一次执行DFS时,k为-1
    for(i=0;i<G.vexnum;i++)
      if(!visited[i]) DFS(G,i); //对尚未访问的顶点调用DFS
  }
  else{ 
    visited[k]=true;
    printf("%c ",G.vexs[k]); //访问第k个顶点
    for(i=FirstVex(G,k);i>=0;i=NextVex(G,k,i))
      if(!visited[i]) DFS(G,i); //对k的尚未访问的邻接顶点i递归调用DFS
  }
}

//主函数
void main(){
  int i;
  Graph G;
  CreateUDN(G);
  visited=(bool *)malloc(G.vexnum*sizeof(bool)); 
  printf("\n深度优先遍历: ");
  for(i=0;i<G.vexnum;i++)
  visited[i]=false;
  DFS(G,-1);
  printf("\n程序结束.\n");
}
```

输出结果为（红色为键盘输入的数据，权值都置为1）：

```
输入顶点数和弧数:8 9

输入8个顶点.

输入顶点0:a

输入顶点1:b

输入顶点2:c

输入顶点3:d

输入顶点4:e

输入顶点5:f

输入顶点6:g

输入顶点7:h

输入9条弧.

输入弧0:a b 1

输入弧1:b d 1

输入弧2:b e 1

输入弧3:d h 1

输入弧4:e h 1

输入弧5:a c 1

输入弧6:c f 1

输入弧7:c g 1

输入弧8:f g 1

深度优先遍历: a b d h e c f g 

程序结束.
```

