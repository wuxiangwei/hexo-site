---
title: Scratch源代码编译小记
date: 2016-08-18 15:34:08
category: [其它]
tags: Gradle
toc: true
---

这几天搞Scratch源代码的编译，遇到不少坑，特此记录一下。

<!-- more -->

## 准备工具
官方提供了两种编译方式：Ant和Gradle，我是使用Gradle编译的，需要准备的工具如下：
- Java JDK，用于执行gradle
- Gradle，用于编译
- Git，用于下载源代码，同时gradle脚本中也会用到git命令（可注释掉不用）

## 下载源代码
请访问https://github.com/LLK/scratch-flash 下载Scratch源代码，下载到本地后之后，在我大天朝，先不要急着编译，首先得修改一下编译脚本，不然编译时有些依赖包无法下载。

- 下载apache-flex-sdk
参考`scratch.gradle`中ivy仓库配置
```gradle
repositories {
    ivy {
        name 'Apache Flex'
        // artifactPattern 'http://archive.apache.org/dist/flex/[revision]/binaries/[module]-[revision]-bin.[ext]'
    artifactPattern 'http://127.0.0.1/flex/[module]-[revision]-bin.[ext]'
    }
    ivy {
        name 'Player Globals'
        artifactPattern 'http://fpdownload.macromedia.com/get/flashplayer/installers/archive/[module]/[module][revision].[ext]'
    }
}
```
先下载apache-flex-sdk，版本必须高于4.10.0，这个sdk比较大，有70多M，建议使用其它工具下载好，放到本地。我下载的是4.15.0，具体的下载路径地址为：http://archive.apache.org/dist/flex/4.15.0/binaries/apache-flex-sdk-4.15.0-bin.zip

- 下载swfobject
下载好swfobject\_2\_2.zip。同样放入本地服务器上

- 下载OSMF
下载好OSMF\_1.0.zip，同样放入本地服务器上

修改apache-flex-sdk中的`frameworks/downloads.xml`内容，将swfobject和osmf的下载地址改为本地地址。

```xml
    <target name="download-osmf-zip" unless="osmf.zip.exists">
        <mkdir dir="${download.dir}"/>
        <get src="http://127.0.0.1/flex/OSMF_1.0.zip" 
            dest="${download.dir}/OSMF_1.0.zip" 
            verbose="false"/>
    </target>
    
    <!-- swfobject.js (Version 2.2) -->
    <!-- Because this requires a network connection it downloads SWFObject only if it doesn't already exist. -->
    <target name="swfobject-check" description="Checks if SWFObject has been downloaded.">
        <available file="${basedir}/../templates/swfobject/swfobject.js" property="swfobject.js.present"/>
    </target>

    <target name="swfobject-download" depends="swfobject-check" unless="swfobject.js.present" 
        description="Copies SWFObject from code.google.com">
        
        <mkdir dir="${download.dir}"/>
        <get src="http://127.0.0.1/flex/swfobject_2_2.zip" 
            dest="${download.dir}/swfobject_2_2.zip" 
            verbose="false"/>
        ...
    </target>
```

如此这般，编译时，依赖包应该能够全部下载好，如果有不能下载的依赖包，可以查看gradle日志输出，参考上面的方法修改gradle编译脚本或apache-flex-sdk的依赖脚本以保证依赖包能够正确下载。

## 编译
参考官方文档，打开git终端，键入编译命令
```bash
$ ./gradlew build -Ptarget=11.6
Defining custom 'build' task when using the standard Gradle lifecycle plugins has been deprecated and is scheduled to be removed in Gradle 3.0
Target is: 11.6
Commit ID for scratch-flash is: latest
:copyresources
:compileFlex
WARNING: The -library-path option is being used internally by GradleFx. Alternative: specify the library as a 'merged' Gradle dependendency
:copytestresources
:test
Skipping tests since no tests exist
:build

BUILD SUCCESSFUL

Total time: 15.691 secs

```

以上是我最终编译通过的输出。编译后输出的Scratch2.swf在`build/11.6/`目录下。

## 源代码修改

具体的源代码修改，请参考我github上fork的scratch-flash项目。地址为https://github.com/ieclipsecn/scratch-flash/
代码提交在jamling分支下。大致讲下修改的地方

- ifOffline 设置为true，默认是false，然后编译的swf不能好好工作。用离线即可。
- 默认语言为zh_CN，但是不起作用，猜测应该要写zh-cn值。
- 跨域crossdomain.xml路径修改为http://cdn.assets.scratch.mit.edu ，这个地址允许所有的域访问
- 加载媒体库和缩略图片库地址，都改为本地地址，且为相对路径。不然会出现跨域问题，导致编译之后的swf无法加载背景库或角色库。

修改完毕之后，重新编译，如果有错误，根据日志提示，修正错误后再次编译就好了。编译成功之后，会输出Scratch.swf。我修改的代码，输出为Scratch2.swf。

 
## 测试
可以直接从官网将官网的网页另存为->保存全部，得到一个基本的html再编辑修改。修改好了。再通过本地服务器测试。此时，你会发现还有许多问题。主要是一大堆的404。可以自行写个爬虫脚本，将官网的一些资源抓到本地。其它的问题，自己再根据具体的错误修复即可。
 
最后放上最终的演示地址：http://ot.ieclipse.cn/flex/Scratch.html

[branch]: https://github.com/ieclipsecn/scratch-flash/commit/0e1a43680b4ded359e8ec0fd1b67ffba739994ed
