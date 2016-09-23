---
title: Android ADB连接海马玩模拟器
date: 2016-09-19 21:00:00
category: [奇淫巧技]
tags: [Android]
toc: false
description: Android ADB连接海马玩模拟器的方法, 海马玩模拟器连接不上, ADB devices offline
---

使用海马玩模拟器来调试Android还是挺方便的。最近因为真机连接不稳定，又想到了海马玩，不知道怎么回事，竟然运行不了模拟器了，只好下载了一个新版本，然后重新安装。安装完毕之后，竟然找不到devices。我记得，以前可是好好的呢。搜索了一下。说是要手动连接

```bash
adb connect 127.0.0.1:53001
```
可是，出现了`unable to connect错误`。后来在官方论坛里找到了原因。原来是自从0.8.5版本之后，海马玩的adb端口不是固定的。我下载的是新版本（0.10.5），当然连接不上了。官方论坛帖子中有说明需要下载修改器修改。存放在网盘上的文件，下载还要注册。懒得搞。因为海马玩经常在待机时无响应，所以对它的进程还是蛮熟悉的（VBoxHeadless.exe），于是自己动手查找它的端口号。再使用adb connect指令连接，果然又成功地连接上了。

步骤如下：
1. 查找海马玩的进程ID，可以通过任务管理器查看（查看->选择列->把PID（进程标识符）勾上），也可以通过命令查看
```bash
tasklist | findstr VBox*
C:\Users\Jamling>tasklist | findstr VBox*
VBoxSVC.exe                   6536 Console                    1     13,332 K
VBoxHeadless.exe              6616 Console                    1    106,572 K
```
注意大小写，6616就是PID了。
2. 通过netstat指令来查看端口号
```bash
C:\Users\Jamling>netstat -o | findstr 6616
  TCP    127.0.0.1:26941        lijiaming-PC:54961     ESTABLISHED     6616
  TCP    127.0.0.1:26941        lijiaming-PC:56864     ESTABLISHED     6616
  TCP    127.0.0.1:26942        lijiaming-PC:56905     ESTABLISHED     6616
  TCP    127.0.0.1:26943        lijiaming-PC:56920     ESTABLISHED     6616
  TCP    127.0.0.1:26944        lijiaming-PC:56934     ESTABLISHED     6616
  TCP    127.0.0.1:26945        lijiaming-PC:56980     ESTABLISHED     6616
  TCP    127.0.0.1:26946        lijiaming-PC:54962     ESTABLISHED     6616
  TCP    127.0.0.1:26947        lijiaming-PC:54963     ESTABLISHED     6616
  TCP    127.0.0.1:26948        lijiaming-PC:54610     ESTABLISHED     6616
  TCP    192.168.133.15:55467   103.28.9.11:http       ESTABLISHED     6616
  TCP    192.168.133.15:57223   115.239.210.246:5287   ESTABLISHED     6616
  TCP    192.168.133.15:60100   183.131.26.108:http    CLOSE_WAIT      6616
  TCP    192.168.133.15:60298   ti-in-f100:https       SYN_SENT        6616
```
看第2列就是VBoxHeadless本机的TCP地址与端口号。（其实，一开始只有26941, 26946, 26947, 26948这4个），但是`adb connect 127.0.0.1:26941`之后，提示成功，但设备状态却是offline，然后，从26941开始到26945试了个遍。没想到真正的端口是26944。
```bash
C:\Users\Jamling>adb devices
List of devices attached
127.0.0.1:26945 offline
127.0.0.1:26944 device
127.0.0.1:26943 offline
127.0.0.1:26942 offline
127.0.0.1:26941 offline
```


