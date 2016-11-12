---
author: ety001
date: 2011-08-31 15:57:51+00:00
layout: post
title: Java作业简单拼图游戏
wordpress_id: 1514
tags:
- 编程语言
---

这是我的Java作业，一个简单的拼图游戏，源文件从这里下载：[点击这里下载源文件](http://u.115.com/file/clqajxh3)。由于是在ubuntu下压缩的，所以在windows下解压会有一个图片乱码，乱码的那张图片名称是“星座.jpg”（不含引号）。

下面直接贴代码：

```
/*
 * Author：ETY001
 * URI：http://www.domyself.me
 */
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.lang.Math;
import java.applet.Applet;

public class pintu extends Applet implements ActionListener
{
	int EmptyRow = 0;//空白图横坐标
	int EmptyCol = 0;//空白图纵坐标
	JPanel up = new JPanel();//上部面板
	JPanel down = new JPanel();//下部面板
	JButton[][] btn = new JButton[5][5];//拼图按钮
	int a[][] =new int[5][5];//记录是否重复随机数的数组
	int m,n;//记录随机数
	//JTextField tt = new JTextField(15);//调试使用

	public void init()
	{
		//上部
		ImageIcon oriPic = new ImageIcon("星座.jpg");
		JLabel oriPicLabel = new JLabel("",oriPic,JLabel.CENTER);
		JButton next = new JButton("下一局");
		up.setLayout(new BorderLayout());
		up.add(oriPicLabel,BorderLayout.WEST);
		up.add(next,BorderLayout.CENTER);
		next.addActionListener(this);

		//下部
		down.setLayout(new GridLayout(5,5));
		for(int i=0;i<5;i++) //清空记录数组
		{
			for(int j=0;j<5;j++)
			{
				a[i][j]=0;
			}
		}
		for(int i=0;i<5;i++)//产生随机的图片碎片
		{
			for(int j=0;j<5;j++)
			{
				m=(int)(Math.random() * 5);
				n=(int)(Math.random() * 5);
				while(a[m][n]==1)
				{
					m=(int)(Math.random() * 5);
					n=(int)(Math.random() * 5);
				}
				a[m][n]=1;
				if(m==0 && n==0)//记录初始时刻空白图片的位置
				{
					EmptyRow = i;
					EmptyCol = j;
				}
				//注意原素材的10和11两张图片的扩展名是大写的，这也是两张图片导入失败的原因		
				btn[i][j] = new JButton(new ImageIcon(m+""+n+".jpg"));
				down.add(btn[i][j]);
				btn[i][j].setActionCommand(i+":"+j);
				btn[i][j].addActionListener(this);
			}
		}

		//全局面板
		setLayout(new BorderLayout());
		add(up,BorderLayout.NORTH);
		add(down,BorderLayout.CENTER);
		//add(tt,BorderLayout.SOUTH);//调试使用
		setSize(275,360);
		setVisible(true);
	}

	public void PicRepeat()
	{
		for(int i=0;i<5;i++) //清空记录数组
		{
			for(int j=0;j<5;j++)
			{
				a[i][j]=0;
			}
		}
		for(int i=0;i<5;i++)
		{
			for(int j=0;j<5;j++)
			{
				m=(int)(Math.random() * 5);
				n=(int)(Math.random() * 5);
				while(a[m][n]==1)
				{
					m=(int)(Math.random() * 5);
					n=(int)(Math.random() * 5);
				}
				a[m][n]=1;
				if(m==0 && n==0)//记录初始时刻空白图片的位置
				{
					EmptyRow = i;
					EmptyCol = j;
				}
				//更新按钮上的随机图片
				btn[i][j].setIcon(new ImageIcon(m+""+n+".jpg"));
			}
		}
	}

	public void changePic(int clickRow,int clickCol,int emptyRow,int emptyCol)
	{
		if(Math.abs(clickRow-emptyRow)+Math.abs(clickCol-emptyCol)==1)
		{
			Icon tmp1 = btn[clickRow][clickCol].getIcon();
			Icon tmp2 = btn[emptyRow][emptyCol].getIcon();
			btn[clickRow][clickCol].setIcon(tmp2);
			btn[emptyRow][emptyCol].setIcon(tmp1);
			EmptyRow = clickRow;
			EmptyCol = clickCol;
		}
	}

	public void actionPerformed(ActionEvent e)
	{
		int row=0,col=0;
		if (e.getActionCommand() == "下一局")
		{
			PicRepeat();
		}
		else
		{
			String[] tmp;
			tmp = e.getActionCommand().split(":");
			row = Integer.parseInt(tmp[0]);
			col = Integer.parseInt(tmp[1]);
			changePic(row,col,EmptyRow,EmptyCol);
		}
		//tt.setText(""+btn[row][col].getIcon());//调试使用
	}
}
```
