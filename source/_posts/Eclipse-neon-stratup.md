---
title: Eclipse 4.6.0 Neon启动问题
date: 2016-06-06 12:06:31
category: [软件技术, Eclipse 插件]
tags: Eclipse
toc: true
---
## 简介
Eclipse 4.6.0 Neon无法启动问题，先占个坑。
环境如下：
Windows 7 64位, JDK 1.8
之前Mars版本安装运行均无问题。

<!-- more -->

## 无法启动
前几天收到邮件，Eclipse 4.6 Neon版本将于2016/06/22执行新的Marketplace策略，所以去下载了eclipse新版本：Neon。

下载安装都很顺利，但是在运行的时候，竟然直接跳出一个错误：

```
---------------------------
Eclipse
---------------------------
An error has occurred. See the log file C:\Users\Jamling\.p2\pool\configuration\1465180452260.log.
---------------------------
确定   
---------------------------
```

日志内容如下：

```
!SESSION 2016-06-06 10:59:03.958 -----------------------------------------------
eclipse.buildId=unknown
java.version=1.8.0_45
java.vendor=Oracle Corporation
BootLoader constants: OS=win32, ARCH=x86_64, WS=win32, NL=zh_CN
Framework arguments:  -product org.eclipse.epp.package.android.product
Command-line arguments:  -os win32 -ws win32 -arch x86_64 -product org.eclipse.epp.package.android.product

!ENTRY org.eclipse.osgi 4 0 2016-06-06 10:59:04.315
!MESSAGE Application error
!STACK 1
java.lang.IllegalStateException: Unable to acquire application service. Ensure that the org.eclipse.core.runtime bundle is resolved and started 

(see config.ini).
	at org.eclipse.core.runtime.internal.adaptor.EclipseAppLauncher.start(EclipseAppLauncher.java:78)
	at org.eclipse.core.runtime.adaptor.EclipseStarter.run(EclipseStarter.java:388)
	at org.eclipse.core.runtime.adaptor.EclipseStarter.run(EclipseStarter.java:243)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:497)
	at org.eclipse.equinox.launcher.Main.invokeFramework(Main.java:673)
	at org.eclipse.equinox.launcher.Main.basicRun(Main.java:610)
	at org.eclipse.equinox.launcher.Main.run(Main.java:1519)
```

### 解决方案
参考：http://stackoverflow.com/questions/2493415/unable-to-acquire-application-service-error-while-launching-eclipse

在<var>ecipse.ini</var>或configuration/<var>config.ini</var>中添加`org.eclipse.core.runtime`
我尝试了一下，发现在<var>eclipse.ini</var>中添加有效。
```ini
-Dosgi.bundles=org.eclipse.equinox.simpleconfigurator@1:start,org.eclipse.equinox.common@2:start,org.eclipse.equinox.ds@2:start,org.eclipse.equinox.event@2:start,org.eclipse.update.configurator@3:start,org.eclipse.core.runtime@start
```
如此，eclipse终于可以成功运行了。

## 无法创建workspace
运行eclipse之后，首次创建workspace，没想到又一个错误：

```
---------------------------
Eclipse
---------------------------
An error has occurred. See the log file
E:\eclipse\android-neon\workspace\.metadata\.log.
---------------------------
确定   
---------------------------
```
日志内容如下：
```
!SESSION 2016-06-06 14:03:47.781 -----------------------------------------------
eclipse.buildId=unknown
java.version=1.8.0_45
java.vendor=Oracle Corporation
BootLoader constants: OS=win32, ARCH=x86_64, WS=win32, NL=zh_CN
Framework arguments:  -product org.eclipse.epp.package.android.product
Command-line arguments:  -os win32 -ws win32 -arch x86_64 -product org.eclipse.epp.package.android.product

!ENTRY org.eclipse.m2e.logback.appender 2 0 2016-06-06 14:04:00.570
!MESSAGE Could not resolve module: org.eclipse.m2e.logback.appender [385]
  Unresolved requirement: Fragment-Host: ch.qos.logback.classic


!ENTRY org.eclipse.osgi 4 0 2016-06-06 14:04:00.570
!MESSAGE Application error
!STACK 1
java.lang.NullPointerException
	at org.eclipse.e4.ui.internal.workbench.ModelServiceImpl.<init>(ModelServiceImpl.java:121)
	at org.eclipse.e4.ui.internal.workbench.swt.E4Application.createDefaultContext(E4Application.java:510)
	at org.eclipse.e4.ui.internal.workbench.swt.E4Application.createE4Workbench(E4Application.java:203)
	at org.eclipse.ui.internal.Workbench$5.run(Workbench.java:626)
	at org.eclipse.core.databinding.observable.Realm.runWithDefault(Realm.java:336)
	at org.eclipse.ui.internal.Workbench.createAndRunWorkbench(Workbench.java:604)
	at org.eclipse.ui.PlatformUI.createAndRunWorkbench(PlatformUI.java:148)
	at org.eclipse.ui.internal.ide.application.IDEApplication.start(IDEApplication.java:138)
	at org.eclipse.equinox.internal.app.EclipseAppHandle.run(EclipseAppHandle.java:196)
	at org.eclipse.core.runtime.internal.adaptor.EclipseAppLauncher.runApplication(EclipseAppLauncher.java:134)
	at org.eclipse.core.runtime.internal.adaptor.EclipseAppLauncher.start(EclipseAppLauncher.java:104)
	at org.eclipse.core.runtime.adaptor.EclipseStarter.run(EclipseStarter.java:388)
	at org.eclipse.core.runtime.adaptor.EclipseStarter.run(EclipseStarter.java:243)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:497)
	at org.eclipse.equinox.launcher.Main.invokeFramework(Main.java:673)
	at org.eclipse.equinox.launcher.Main.basicRun(Main.java:610)
	at org.eclipse.equinox.launcher.Main.run(Main.java:1519)
```
尝试了许多办法，仍然还是个这错误。

已向eclipse提问求助。期待他们能够尽量回复给出解决方案

### 解决方案
原来是eclipse installer的bug，需下载新版本再安装。

{% blockquote Eclipse https://www.eclipse.org/forums/index.php/m/1734197/#msg_1734197 Forums %}
Sorry, there was a bug in the RC3 installer. I've just created an RC3a
build to fix it. Until they update the link on the website

https://bugs.eclipse.org/bugs/show_bug.cgi?id=495523

you could get the fixed version from here:

https://hudson.eclipse.org/oomph/job/integration/lastSuccessfulBuild/artifact/products/

Or you could switch to Advance mode and use the button at the bottom of
the wizard to update your installer to the fixed version.
{% endblockquote %}

## 配置启动问题汇总

{% blockquote EclipseWiki https://wiki.eclipse.org/Eclipse4/RCP/FAQ#Why_won.27t_my_application_start.3F %}

## Problems on Configuration, Start-Up, and Shutdown
### Why won't my application start?
E4AP products require having the following plugins:

org.eclipse.equinox.ds (must be started)
org.eclipse.equinox.event (must be started)
Note that org.eclipse.equinox.ds and org.eclipse.equinox.event must be explicitly started. In your product file, you should have a section like the following:

```xml
  <configurations>
     <plugin id="org.eclipse.core.runtime" autoStart="true" startLevel="2" />
     <plugin id="org.eclipse.equinox.ds" autoStart="true" startLevel="3" />
     <plugin id="org.eclipse.equinox.event" autoStart="true" startLevel="3" />
  </configurations>
```
Failure to set the auto-start levels usually manifest as runtime errors like

```
  Unable to acquire application service. Ensure that the org.eclipse.core.runtime bundle is resolved and started (see config.ini)
```
{% endblockquote %}