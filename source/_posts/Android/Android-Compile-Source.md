---
title: 编译Android源代码
date: 2015-01-01 12:48:31
category: [Android]
tags: [Android]
toc: true
---
编译Android源代码
本文介绍的是如何在linux环境下获取、编译源代码，并在编译之后运行。使用的操作系统为Ubuntu11.04
<!-- more -->

## 获取源代码
Android源代码仓库是分布式的，叫做git，所以在获取代码之前先安装git。git与常用的svn，cvs不一样，但不必担心，android为了简化操作，使用python脚本语言写了一个简化程序叫做curl。只需要按以下步骤一步一步操作就行了。

### 安装git及curl
 ``` bash
 $ sudo apt-get install git-core curl
 ```
在此之前我已经安装了git, gitg（git的图形化工具）

### 安装repo脚本
```
$ curl http://android.git.kernel.org./repo >~/repo
```
### 授权并建立本地仓库
```
$ chmod a+x ~/repo
$ mkdir android-source
$ cd android-source
```
### 初始化repo客户端
```
$ ~/repo init -u git://android.git.kernel.org/platform/manifest.git
```
但是使用git协议我连接不上服务器，使用http能够访问，所以我修改了repo文件
```
REPO_URL='http://android.git.kernel.org/tools/repo.git'
```
并输入下面的指令来初始化git
```
$ ~/repo init -u http://android.git.kernel.org/platform/manifest.git
```
如果你想取分支版本的话，那么请使用-b选项，如取2.2使用以下指令
```
$ ~/repo init -u git://android.git.kernel.org/platform/manifest.git -b froyo
```
注：froyo是2.2的版本名称
### 检出源代码
```
$ ~/repo sync
```
到这里，可以休息一下了，慢慢下吧。然后接着去做一些编译前的准备工作吧。

## 初始化编译环境
### 安装jdk
我机器上的JDK早就装好了。所以这里copy官网的安装指南
对于Android 2.3及其更高版本，需要安装jdk1.6
```
$ sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
$ sudo add-apt-repository "deb-src http://archive.canonical.com/ubuntu lucid partner"
$ sudo apt-get update
$ sudo apt-get install sun-java6-jdk
```
对于Android 2.2及其以下版本，需要安装jdk1.5
```
$ sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu dapper main multiverse"
$ sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu dapper-updates main multiverse"
$ sudo apt-get update
$ sudo apt-get install sun-java5-jdk
```
### 安装一些必备包
在安装之前，首先看一下，你的系统是多少位的。不同位的系统安装的包不一样
64位系统
```
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev
  lib32ncurses5-dev ia32-libs x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev libgl1-mesa-dev
```
32位系统
```
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev
  libncurses5-dev x11proto-core-dev libx11-dev libreadline5-dev libz-dev libgl1-mesa-dev
```
官网原文注：如果在64位的系统中编译2.2或之前的版本，可能需要安装以下额外的包来构造32的编译环境。
```
$ sudo apt-get install gcc-multilib g++-multilib libc6-i386 libc6-dev-i386
```
NND，我编译的是2.3，所以没有安装这些包。所以我直接去make了。但是make失败了。有个错误是/usr/bin/ld: cannot find -lstdc++ 
url is : http://ubuntuforums.org/showthread.php?t=15120
郁闷，后来google了一下，有大侠也遇到过这问题，安装g++-multilib就好了。
所以我又安装了g++
```
$ sudo apt-get install g++ g++-multilib
```
### 配置USB的访问
在GUN／LINUX（尤其是Ubuntu),默认情况是不允许用户直接访问USB设备的。需要以下配置来允许访问USB
推荐的方式是在/etc/udev/rules.d/目录下建立一个51-android.rules的文件（注意了，必须以root用户），并将以下内容写入到文件中
```
# adb protocol on passion (Nexus One)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e12", MODE="0600", OWNER="<username>"
# fastboot protocol on passion (Nexus One)
SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0fff", MODE="0600", OWNER="<username>"
# adb protocol on crespo (Nexus S)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e22", MODE="0600", OWNER="<username>"
# fastboot protocol on crespo (Nexus S)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e20", MODE="0600", OWNER="<username>"
```
注：username必须替换为此文件的所有者。

我使用的是sudo gedit创建文件，然后查看了一下属性，拥有者为root，所以把<username>替换为root了。

## 编译
### 初始化环境
使用build/setupenv.sh脚本来初始化编译环境。使用
```
$ source build/envsetup.sh
```
或
```
$ . build/envsetup.sh
```
都可以
### 选择目标版本
例如
```
$ lunch full-eng
```
是一个开启所有调试的编译
详细的目标版本选择请见官网。
### 编译
```
$ make
```
以上准备工作做好了之后，终于到了最紧张的时刻了，以致于都没把-jN参数加上去，我电脑双CPU，4核双线程，加个-j16是不是会编译快些呢？我都写好这文档了，还在编译中呢。唉。不过还是挺高兴的。前天还刚接触linux系统，基本的linux指令都不会呢。

## 小结
公司有网络就是好哇，在以前公司，都是封闭式办公的，有时候遇到一个小问题，搞不好会阻塞一整天。不过网络信息量太大。如何找到权威而全面的资料是很重要的。我优先是参考官网相关的文档的。对于具体问题，先静下心来分析，然后一步步解决。当然也可以问前辈，可以省去不少时间。
## 参考资料

http://source.android.com
