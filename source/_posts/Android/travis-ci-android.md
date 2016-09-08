---
title: 使用Travis-CI构建Android应用
date: 2016-09-06 21:00:00
category: [Android]
tags: [Android, CI]
toc: true
description: 使用Travis-CI构建github上的Android应用
---

## 简介
注册Travis-CI都N长时间了，但是一直没有使用它来构建。今天先使用它构建了两个小的node.js项目，还算顺序，然后使用它来构建[QuickAF]，没有想到竟然是一条如此艰辛的路！特地将构建过程记录如下。

<!-- more -->

## 配置
参考官方文档[https://docs.travis-ci.com/user/languages/android/]的配置，稍做改动就提交构建了。还以为能像node.js那样顺风顺水，没有想到竟然是一次又一次的失败。

## gradle版本
```

FAILURE: Build failed with an exception.

* Where:

Build file '/home/travis/build/Jamling/QuickAF/library/build.gradle' line: 12

* What went wrong:

A problem occurred evaluating project ':af-library'.

> Failed to apply plugin [id 'com.android.library']

   > Minimum supported Gradle version is 2.14.1.  Current version is 2.2.1. If using the gradle wrapper, try editing the distributionUrl in /home/travis/build/Jamling/QuickAF/gradle/wrapper/gradle-wrapper.properties to gradle-2.14.1-all.zip

* Try:

Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output.

BUILD FAILED

Total time: 42.348 secs
```

## SDK设置
sdk的配置一定要对应

## jdk设置
好像build tool 24以上的版本需要使用jdk8

## 

通常，BaseActivity/BaseFragment中已经对TitleBar初始化过了，所以子页面的初始化主要的就是控制TitleBar的右侧区域以及设置标题文字。设置标题文字调用`setTitle("titleName")`就可以了，下面主要描述对TitleBar右侧区域的初始化。

TitleBar提供了一个`addRightView()`的API来添加右侧菜单项。参数类型可以是layout resource或View对象。如此，用户可以自由控制菜单项的属性，比如设置图片，设置文字，添加onClick事件等。

- 右侧button为图片：
``` java
mTitleTextView.setText(R.string.house_title);
mMap = (ImageView) mAbTitleBar.addRightView(R.layout.layout_title_icon);
mMap.setImageResource(R.drawable.title_map);
mSearch = (ImageView) mAbTitleBar.addRightView(R.layout.layout_title_icon);
mSearch.setImageResource(R.drawable.title_search);
setOnClickListener(mMap, mSearch);
```

- 右侧button为文字：
```java
mManageTv = (TextView) mTitleBar.addRightView(R.layout.layout_title_text);
mManageTv.setText(isMyList() ? R.string.note_my_book_title_manage : R.string.note_other_book_title_change);
```

- 右侧button为图片加文字(比较少)
```java
mSubmit = (TextView) mTitleBar.addRightView(R.layout.layout_title_post_submit);
```

## 设置

### 对齐方式
TitleBar在垂直方向默认是居中对齐的，在水平方向，提供两种对齐方式：左对齐与居中对齐（默认）。可以通过`TitleBar#setGravity(int gravity)`方法设置TitleBar的对齐方式，一般来说只需要设置水平对齐即可

- `Gravity.CENTER_HORIZONTAL`，水平居中对齐（默认） ，TitleBar中间区域（标题）会居中显示
- `Gravity.LEFT`，水平左对齐，TitleBar中间区域（标题）会在左侧区域后面显示

不同的水平对齐方式，中间区域的显示空间是不一样子，如果不能满足需求，还可以通过`TitleBar.setConfig()`来设置TitleBar参数。

### 隐藏标题栏
TitleBar可以通过`View.setVisibility()`来控制显示或隐藏，如果是页面不需要标题栏，建议是在`initWindowFeature()`方法中通过`setShowTitleBar(false)`来设置。

### 悬浮标题栏
TitleBar支持设置其是否悬浮在页面上（不随页面滚动），可以在`initWindowFeature()`方法中通过`setOverlay(false)`来设置。

## PopupMenu
TitleBar内部未实现popup menu，如果需要使用下拉菜单，可以在特定的页面中结合PopupWindowUtils或自己实现一个下拉菜单

## 关于

[QuickAF]是一个Android平台上的app快速开发框架，欢迎读者在github star或fork。本人写作水平有限，欢迎广大读者指正，如有问题，可与我直接联系或在我的官方博客中给出评论。

## 参考
QuickAF: https://github.com/Jamling/QuickAF
https://docs.travis-ci.com/user/languages/android/

[QuickAF]: https://github.com/Jamling/QuickAF
[https://docs.travis-ci.com/user/languages/android/]: https://docs.travis-ci.com/user/languages/android/

