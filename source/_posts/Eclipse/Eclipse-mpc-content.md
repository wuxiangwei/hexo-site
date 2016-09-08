---
title: Eclipse MPC内容管理策略（译）
date: 2015-01-03 12:48:31
category: [Eclipse 插件]
tags: Eclipse
toc: true
---
## 简介
Eclipse Marketplace Client(MPC)，是Eclipse新插件，它允许Eclipse用户在Marketplace上搜寻和安装基于Eclipse的产品。MPC的目的旨在为Eclipse社区提供AppStore式的体验。MPC将做为Eclipse的内置插件，在eclipse.org下载界面中列出的所有的Eclipse安装包都会包含此插件。
<!-- more -->

同时，Eclipse基金会用MPC来高亮Eclipse会员的解决方案。本文档的目的旨在描述哪些内容可以包含在MPC中的策略。

## 声明
* Eclipse Marketplace：托管于Eclipse基金会的Marketplace产品Marketplace：第三方的Marketplace产品
* MPC：Eclipse中内置的客户端工具。

## 使用
1. 任何基于Eclipse的解决方案，可以在Eclipse Marketplace网站中列出。解决方案包含商业产品或开源License的产品／项目。解决方案提供商可以是非Eclipse Marketplace榜单中的Eclipse基金会会员。用户也可以通过浏览器来浏览Eclipse Marketplace中的所有解决方案。
2. MPC有两种工作模式
 1. MPC向导和MPC内置浏览器。MPC向导需要从Eclipse启动，并展现给终端用户。出现在MPC向导中的内容为：
  1. 任何使用开源license的解决方案。
  2. 与Eclipse基金会成员(不包含Eclipse准会员)公司有关的解决方案。在MPC向导中列出的初始特性列表，全都来源于基金会会员公司。搜索结果和展开目录的结果会包含所有的开源解决方案。
3. MPC内置浏览器，在用户点击MPC中的“Browser More Solution"时启动，在内置的浏览器中，展现的是所有的特性列表，就像使用正规的浏览器浏览Eclipse Marketplace时所看到的一样。

用户可以在MPC中指定可选的Marketplace提供商。这些可选的提供商一般都包含一个可以在MPC中查看基于Eclipse解决方案的目录，终端用户可以自由切换Marketplace提供商。

## 预加载
Eclipse基金会预先加载了Eclipse基金会战略成员的marketplace提供商。可选的提供商有义务做到以下几点：
1. 提供与发布包一致的培训计划表
2. 充分测试发布包并且能够提供相关支持
3. 完全实现MPC定义的api和协议
4. 相关资源所在的url必须7*24小时可访问，Eclipse基金会保留删除那些不可访问的提供内容的权利

MPC允许指定可选的market，终端用户可以选择market。它是Eclipse战略合作成员预加载托管在基金会上的eclipse包的唯一可选市场

[原文](https://marketplace.eclipse.org/content/marketplace-client-content-inclusion-policy)
