---
title: Eclipse RCP产品国际化
date: 2010-03-31 21:00:00
category: [Eclipse 插件]
tags: [Eclipse]
toc: true
---

对rcp的国际化主要是通过添加插件工程来完成。这一部分可以从网上或者书上找到不少的资料。在这里我主要阐述一下导出的RCP产品如何对使用的 eclipse内容及其它插件的国际化。
举个例子，你创建了一个jface对话框，确定按钮显示的是OK。如果你的rcp依赖于p2，那么检查更新的菜单显示的是Check for Updates。

<!-- more -->
国际化步骤如下：


## 一、下载并安装eclipse中文语言包
可以在download/Eclipse Technology Project/Babel 频道下载相关的语言包。
我所使用的eclipse版本为伽利略（3.5.0）。分别下了eclipse语言包和rt-equinox语言包。
下载完成之后分别解压到%eclipse_home%/dropins/eclipse_zh和%eclipse_home %/dropins/p2_zh（详细请参考eclipse插件安装方法）。
重启eclipse，如果发现eclipse里面的菜单变成中文，说明 eclipse语言包安装成功；如果帮助菜单下的检查更新也变成中文，那么p2语言包插件也安装成功。


## 二、添加feature工程
在feature.xml Plug-ins选项卡中，添加要国际化段工程，如p2.sdk.nl_zh。
**注意，添加的插件段工程不能有警告。**

*注：下载的P2国际化中文资料文件并不全，在install,update界面有中英文混合的情况出现，请使用附件中的jar文件覆盖plugins/下的同名文件。*


## 三、添加fragment工程
eclipse语言包有119个nl_zh.jar，如果我们只需要对jface进行国际化的话，而又不想在eclipse加载语言包（对于已经习惯了en_US语言包的人）。那么简单的方法就是从jface.nl_zh中提取 messages_zh.properties，并放入段工程的相同包下载。段工程的host-plugin请选择对应的 org.eclipse.jface3.5.0。

*注：如对话框的确定，取消按钮，首选项的应用等常用按钮的国际化都在org.eclipse.jface插件中。*


## 四、导出产品
如果看到eclipse的内容和依赖的p2插件显示为中文，那么到此，rcp产品的国际化已经全部完成……
