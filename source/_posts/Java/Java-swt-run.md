---
title: 也谈SWT的运行
date: 2011-04-14 21:00:00
category: [Java]
tags: [Java, SWT]
toc: false
---

前一段时间，写了两个关于j2me打包签名的工具，界面技术使用的是SWT。在eclipse测试OK之后，将src打包为jar。其中META-INF/MENIFEST.MF中指定Main-Class为 我的main类，并且classpath等也加进去了。但在双击jar并不能成功运行。

没办法，只好写bat文件来启动swt。但惊奇的发现，竟然找不到某些类。主要还是swt包中的。刚开始还以为是java.library.path的问题，最后确定不是，当时还懵了一下子，不知道怎么解决。

后来去eclipse swt网站查看swt example的运行。才恍然大悟，原来要这样运行。兹记之

原文请参考：http://www.eclipse.org/swt/examples.php

简而言之，就是将你要运行的jar也加入classpath，然后将要运行的类，使用全称附在java 命令后面。如
`java -cp \lib\swt.jar;mypackager.jar; org.melord.swt.packager.Main` 
表示运行 org.melord.swt.packager.Main类。

<!-- more -->
