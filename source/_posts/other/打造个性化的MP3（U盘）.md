---
title: 打造个性化的MP3（U盘）
date: 2006-04-27 10:53:00
category: [奇淫巧技]
tags: []
toc: false
---
想让你的U盘或MP3与众不同吗?现在跟我做：
新建一个文本文档
复制以下内容到U盘Autorun.inf

<!-- more -->
```
//从这开始斜体内容是必须要的........
[.ShellClassInfo]
IconFile=pic\yingmu.ico//98系统才支持吧?还可以是.EXE;DLL后缀
IconIndex=0 //可以选的啦

[.ShellClassInfo.A]
IconFile=pic\yingmu.ico
[.ShellClassInfo.W]
IconFile=I:+AFw-pic+AFxeOHUoj29O9gBcTipgJ13lUXd7sQBcaEyXYk47mJgAXGhMl2JW/mgHAFxlh072Vv5oBwBc-folder+AF8-b.ico

[.ShellClassInfo]
IconFile=pic\yingmu.ico
IconIndex=0
Infotip=

ConfirmFileOp=0
[.ExtShellFolderViews]
[{BE098140-A513-11D0-A3A4-00C04FD706EC}]
IconArea_Image=pic\she2.jpg//背景图片
IconArea_Text=0x00ff00//文件夹字体
IconArea_bgcolor=0xff0000//忘了
Attributes=1

[ExtShellFolderViews]
{BE098140-A513-11D0-A3A4-00C04FD706EC}={BE098140-A513-11D0-A3A4-00C04FD706EC}
{5984FFE0-28D4-11CF-AE66-08002B2E1262}={5984FFE0-28D4-11CF-AE66-08002B2E1262}
IconArea_Image=pic\she3.jpg // U盘显示的图片
IconArea_Text=#FF0000 // 文字颜色（红）
Attributes=1
```