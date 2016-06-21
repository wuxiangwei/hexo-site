---
title: 使用ADB连接手机
date: 2016-05-14 15:34:08
category: [软件技术, 奇淫巧技]
tags:
toc: true
---

## 简介
使用ADB连接手机进行调试，开发、文件传输

使用adb文件传输优点：无需卸载或挂载SD卡

<!-- more -->

## 官方指南
请访问http://developer.android.com/tools/device.html配置你的设备，也可以下载驱动

## 操作实践
### 在Win7上连接手机。

1. 使用USB线将PC与手机连接起来
2. 打开cmd，输入adb devices查看设备状态
  
 {% asset_img image001.jpg %}
 
 注：adb 命令找不到，将先配置系统环境变量
 
从上图可以看到，目前adb识别到的设备数为0。为什么呢？因为缺少驱动。需要安装驱动。不信，可以在设备管理器查看一下，如下图所示：

<p>{% asset_img image002.jpg %}</p>

显示黄色！图标的表示我的手机没有相应的驱动，不能被电脑识别。
 
### 安装驱动
下载Android SDK，启动SDK Manager，在Extras中勾选Google USB Driver并点击“Install packages…”安装。

<p>{% asset_img image004.jpg %}</p>

如果你不是专业的Android开发人员，请自行百度并下载Google USB驱动。下载好驱动之后，进入驱动所在的目录，如我的电脑存放在：
`D:\adt-bundle-windows-x86\sdk\extras\google\usb_driver`
在此目录下，有一个<kbd>android_winusb.inf</kbd>文件，使用像记事本等文本编辑器打开它。

<p>{% asset_img image005.jpg %}</p>
 
文件内容如下图，像Google的亲儿子Nexus系统手机，它都配置好了VID和PID，可以直接安装驱动。但是好多手机，需要我们自己配置，谁叫你买的不是Google的产品呢~

{% asset_img image006.jpg %}

回到设备管理器，右键点击自己手机->属性，点击第三个选项卡：“详细信息”，在属性下拉列表中设备硬件Id，OK，看到了吧，你手机的VID，及PID信息都在这呢。选择这两项，右键copy。
{% asset_img image007.jpg %}
回到android_winusb.inf文件，先将硬件PID，VID粘贴到空白处，copy一个原有的配置，再将VID，PID剪切替换一下，如下图所示：
{% asset_img image009.jpg %}
最后，别忘了保存。然后在设备管理器中，右键选择没有驱动的手机设备，选择“更新驱动程序”，然后选择本地驱动（点击“从计算机的…”这一项），点击“浏览”选择驱动所在的目录。按下一步继续。
{% asset_img image011.jpg %}
如果弹出驱动验证警告，不管它，点击始终安装就是。
{% asset_img image012.jpg %}
安装完毕之后，在设备管理器中，会多出一个Android Phone的组，下面有Android ADB Interface 这一项，即表示驱动安装成功，基本上你的电脑就能连上手机了。如果还是不行，建议将跟你手机名字相关的设备按上述方法 （查看VID，PID，写入inf，再更新驱动）
{% asset_img image013.jpg %}

连接成功之后，我们就可愉快的使用adb来连接手机啦

{% asset_img image014.jpg %}

运行monitor查看手机
{% asset_img image016.jpg %} 


 

 


