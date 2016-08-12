---
title: Android 无法接收推送的问题
date: 2016-08-12 09:16:41
tags: [Android]
category: [软件技术, Android]
toc: false
---

Android 无法接收推送的问题总的来说，分为两大类：

1. 代码问题
2. 系统问题

代码问题通常开发者自己查阅相关的集成文档都能解决。比如联网权限是否加了，推送接收器的AppID和AppKey是否设置正确，这类问题好解决，开发者自己逐步排查基本都能自行解决。

而系统问题主要是第三方ROM的问题，有些初学者经常会困惑，我常常被样问：我的App在XX手机上收不到推送，该如何解决？

<!-- more -->

其实，这类问题根本的原因是App被杀死了，才导致推送接收不到，那怎么让App被杀死后，能够自动重启呢？不好意思，我的回答是：不能，除非用户允许该应用自启动！

大部分国产手机比如小米，华为往往在安装App的时候，该App的自启动是禁止的。一般来说Android App的Service都是可以重新启动的，不过被系统禁止了自启动，那么就导致服务被杀死后无法重新启动，服务（推送服务）是未启动状态，当然无法接收接送了。

那么微信被杀死怎么还可以接收到消息呢？我估计微信可能被第三方ROM列入白名单了吧，默认是允许自启动的。不信，在手机的**授权管理**中把微信的自启动关闭掉，再最近程序列表中把微信强行杀死，你看还能不能收到消息！

如何判定程序有没有启动呢？这很简单，进入**设置**在**应用程序管理**中，找到该应用，如果那个**强行停止**是灰化的，表示没有启动，如果是可以点击的，则表示该应用存在后台的Receiver或Service，这也是为什么你没有桌面上点开应用程序，而应用程序仍然接收消息的原因。

所以，这类问题还真不好解决。不过仍然存在一些蹊径。一般推送SDK会有一个守护服务。如果该服务在App内被开启的话，意味着该App允许被其它使用相同推送SDK的App拉起。举个例子，App A和App B都使用了极光推送，两个App都开启了守护服务，那么A和B都停止的状态下，如果用户手动点开了A，那么B的推送就会被A拉起来。

以极光推送为例，守护服务的配置如下：

```xml
        <!-- since 1.8.0 option 可选项。用于同一设备中不同应用的JPush服务相互拉起的功能。 -->
        <!-- 若不启用该功能可删除该组件，将不拉起其他应用也不能被其他应用拉起 -->
        <service
            android:name="cn.jpush.android.service.DaemonService"
            android:enabled="true"
            android:exported="true">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.DaemonService"/>
                <category android:name="com.yourcorp.package"/>
            </intent-filter>
        </service>
```
