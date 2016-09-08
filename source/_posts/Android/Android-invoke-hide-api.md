---
title: 使用反射調用隱藏或內部API
date: 2015-12-26 21:00:00
category: [Android]
tags: [Android, Java]
toc: true
description: 在Android中有些类、接口、方法没有向SDK开放，在此介绍使用Java反射技术，来实现Android隐藏API或内部API
---
## 內部API定義

供Android内部使用，不向SDK开放的类、接口、方法等

内部API出现的形式
- Hide
在public类，方法，（静态）常量使用了/** @hide */注释的java元素。如android.os.ServiceManager类
- internal
包名中带有internal标记的所有类或包，如com.android.internal.*
<!-- more -->
## 使用優缺點

为什么不开放？
- 版本复杂
- 本身不稳定
- 兼容性差

优点：在特定的条件下使用，会产生意想不到的效果

缺点：兼容性差

**使用需谨慎**


## 調用方式

1. 和源代码一起编译
2. 修改eclipse adt规则
3. 使用java反射机制


## Java反射簡介
- 動態語言：允許程序在運行時改變程序結構及變量類型
- Java反射：加載在運行時才知道的class及獲取/調用此類的所有屬性/方法。

## Java反射API
Class Class#forName(String className);
Constructor Class#getConstructor();
Object Class#newInstance();
Constructor Class#getConstructor(Class<?>... constructorTypeParameters);
Object Constructor#newInstance(Object... constructorParameterValues);
Method Class#getDeclaredMethod(String name, Class<?>... parameterTypes);
Object Method#invoke(Object target, Object... parameterValues);

## 示例
獲取apk運行統計信息
```java
        // IBinder oRemoteService = ServiceManager.getService("usagestats")
        Class<?> cServiceManager = Class.forName("android.os.ServiceManager");
        Method mGetService = cServiceManager.getMethod("getService", java.lang.String.class);
        Object oRemoteService = mGetService.invoke(null, "usagestats");
        // IUsageStats oIUsageStats = IUsageStats.Stub.asInterface(oRemoteService)
        Class<?> cStub = Class.forName("com.android.internal.app.IUsageStats$Stub");
        Method mUsageStatsService = cStub.getMethod("asInterface", android.os.IBinder.class);
        Object oIUsageStats = mUsageStatsService.invoke(null, oRemoteService);
        // PkgUsageStats[] oPkgUsageStatsArray = mUsageStatsService.getAllPkgUsageStats();
        Class<?> cIUsageStatus = Class.forName("com.android.internal.app.IUsageStats");
        Method mGetAllPkgUsageStats = cIUsageStatus.getMethod("getAllPkgUsageStats", (Class[]) null);
        Object[] oPkgUsageStatsArray = (Object[]) mGetAllPkgUsageStats.invoke(oIUsageStats, (Object[]) null);
        Class<?> cPkgUsageStats = Class.forName("com.android.internal.os.PkgUsageStats");
        for (Object pkgUsageStats : oPkgUsageStatsArray) {
            // get pkgUsageStats.packageName, pkgUsageStats.launchCount,
            // pkgUsageStats.usageTime
            String packageName = (String) cPkgUsageStats.getDeclaredField("packageName").get(pkgUsageStats);
            int launchCount = cPkgUsageStats.getDeclaredField("launchCount").getInt(pkgUsageStats);
            long usageTime = cPkgUsageStats.getDeclaredField("usageTime").getLong(pkgUsageStats);
            System.out.println(packageName + ":" + launchCount + ":" + usageTime);
        }
```


                    