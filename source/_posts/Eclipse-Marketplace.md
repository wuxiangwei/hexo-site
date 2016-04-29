---
title: Eclipse Marketplace介绍（译）
date: 2015-01-03 12:48:31
category: [软件技术, Eclipse 插件]
tags: Eclipse
toc: true
---
## 简介
Eclipse Marketplace是为了提供基于Eclipse解决方案、产品和附加特性。每月有成千上万的开发者访问Marketplace，基本上是寻找新的创新解决方案。受此驱动，解决方案提供商在Marketplace发布他们的产品以供Eclipse开发者社区使用。
2010年6月，作为Helios版本的一部分，Eclipse内置了Marketplace客户端，带给Eclipse“应用商店”一样的体验。Marketplace客户端允许开发者直接在Eclipse中浏览和安装基于Eclipse的产品。
<!-- more -->

## 在Eclipse Marketplace发布您的产品
1. 首先，在发布之前，您需要创建一个账号并登陆，Marketplace账号可以和Eclipse Bugzilla共用同一账号，如果您有需求，请点击这里创建账号。
2. 只要您登陆到Eclipse Marketplace，您将可以在网站上方的导航栏中看到“Add Content"连接。
Eclipse Marketplace允许发布内容有两种类型
 * 解决方案－可以被下载和安装的产品，可以是完整的产品、RCP应用程序或者插件。
 * 培训＆咨询－为公司提供的培训及咨询服务，期望在Eclipse Marketplace中做广告。
3. 如果您已经将你的产品提交发布，它将出现在缓冲队列中，在之后的24小时内，通过审批后，将出现在Eclipse Marketplace中。
4. 如果您想编辑产品，请访问面页上方导航栏上的“My Marketplace"链接

## 为Eclipse Marketplace客户端做准备
Eclipse Marketplace是2010年6发布的Eclipse Helios版本中的新特性。它带给开发者一种“应用商店”式的体验。旨在帮助开发者搜寻他们期望的Eclpse解决方案。上百万的Eclipse用户现在可以直接在Eclipse中看到Marketplace解决方案提供商。
Marketplace客户端列出的解决方案包含Eclipse基金会会员的商业化解决方案和所有的开源解决方案。为确保您的产品能够出现Marketplace客户端中，请遵循以下步骤：

1. 如果您有商业化的产品，您需要提供免费版本，Eclipse Marketplace中没有任何需要付费使用的商业化产品。
2. 您的产品必须能够在某个Eclipse中安装，有点遗憾的是，Marketplace客户端不提供安装产品所信赖的Eclipse下载和安装。
3. 为确保您的产品可以在Marketplace中出现和安装，有两个信息，您必须填写完整。
 1. 产品能够支持从Eclipse p2更新站点下载，所以更新站点（Update Site) url必须填写正确。
 2. 必须定义产品的默认安装，默认安装包含1个或多个可安装的特性,特性具有唯一标识ID。所以您需要指定默认特性的ID。如果提供特性信息，请详见后面的说明。
4. 我们推荐您使用当前版本的Marketplace客户端测试您的产品，Eclipse3.6及其之后版本都内置了Marketplace客户端，您可以通过Help->Eclipse Marketplace打开客户端。

＊更多信息请访问Marketplace客户端内容包容策略
