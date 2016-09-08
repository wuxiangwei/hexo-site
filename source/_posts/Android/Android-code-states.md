---
title: Android使用代码来实现StateListDrawable
date: 2016-08-02 21:01:00
category: [Android]
tags: [Android, QuickAF]
toc: true
description: 
---

相信大家在做Android开发的时候，一定遇到以下问题：

- 界面A上有一个按钮B1，点击时，需要变换背景颜色
- 界面B的按钮B2与界面A的按钮B1外观一样，只是颜色不同

通常我们的解决办法是向UI要按钮的背景图，不同的状态是一张图片。以上为例，我们需要向美工索取4张图片。
按钮B1（常态与点击态），按钮B2（常态与点击态），然后再定义selector drawable xml，如果美工给的不是9.png，我们还要使用nine-patch工具将其转为9.png图片。
大家可以想象一下，如果状态更多，而页面上的按钮又各不相同的话，天啊！那该有多少图片，多少个selector啊，得花多少时间啊！有没有快捷的解决办法呢？答案当然是有！

<!-- more -->

-  在Android的5.0之后，Android提供了一个Tint着色功能，允许你修改背景图片的颜色来达到复用功能。不过只能在Android5.0以上的系统中使用。
- 使用[QuickAF]的RoundedColorDrawable和RoundButton来实现

## RoundedColorDrawable

RoundedColorDrawable继承自Drawable，不仅可以设置Drawable的背景和圆角，还可以设置边框。

### 构造函数
常用的构造函数如下：

```java
    /**
     * Creates a new instance of RoundedColorDrawable.
     *
     * @param radius
     *            of the corners in pixels
     * @param color
     *            of the drawable
     */
    public RoundedColorDrawable(float radius, int color) {
        this(color);
        setRadius(radius);
    }
```

构造时传入圆角半径和默认的背景颜色。

### 设置边框
如果需要设置边框，需要单独调用setBorder来实现。

```java
    /**
     * Sets the border
     * 
     * @param color
     *            of the border
     * @param width
     *            of the border
     */
    public void setBorder(int color, float width) {
        if (mBorderColor != color) {
            mBorderColor = color;
            invalidateSelf();
        }
        
        if (mBorderWidth != width) {
            mBorderWidth = width;
            updatePath();
            invalidateSelf();
        }
    }
```

`setBorder()`方法可以对RoundedColorDrawable设置框架厚度和颜色。

### 设置状态

核心的设置状态及其对应的颜色代码如下：

```java
    private StateListDrawable sld;
    public RoundedColorDrawable setStateColor(int[][] stateSets, int[] colors){
        if (stateSets != null && colors != null) {
            int len = Math.min(stateSets.length, colors.length);
            for (int i = 0; i < len; i++) {
                RoundedColorDrawable self = new RoundedColorDrawable(mRadii, colors[i]);
                self.setBorder(mBorderColor, mBorderWidth);
                sld.addState(stateSets[i], self);
            }
        }
        return this;
    }

    public RoundedColorDrawable addStateColor(int[] stateSet, int color, int borderColor){
        if (sld == null) {
            sld = new StateListDrawable();
        }
        RoundedColorDrawable self = new RoundedColorDrawable(mRadii, color);
        self.setBorder(borderColor > 0 ? borderColor : mBorderColor, mBorderWidth);
        sld.addState(stateSet, self);
        return this;
    }

    public RoundedColorDrawable addStateColor(int[] stateSet, int color){
        return addStateColor(stateSet, color, 0);
    }

    public RoundedColorDrawable addStateColor(int state, int color){
        return addStateColor(new int[]{state}, color);
    }
```

通过上面的代码可以知道，给RoundedColorDrawable添加状态集对应的drawable，其实都是调用StateListDrawable的addState()方法。而我们定义的selector drawable xml，其实也是生成一个StateListDrawable。RoundedColorDrawable不过是提供类似的方法罢了。

### 示例代码

回到本文开篇的例子，按钮B1定义如下：

```xml
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@drawable/b1_pressed" android:state_selected="true"/>
    <item android:drawable="@drawable/b1_pressed" android:state_pressed="true"/>
    <item android:drawable="@drawable/b1_normal"/>
</selector>
```
`b1_pressed.9.png`为点击时或选中时的背景，颜色假设为`#ffff0000`(红色)，`b1_nromal.9.png`为默认的背景，颜色假设为`#ff00ff00`(绿色)。如果使用RoundedColorDrawable，那么代码如下：

```java
 Button btn2 = (RoundButton)view.findViewById(R.id.btn2);
 // btn2 bg
int r = AppUtils.dp2px(this, 4); // 圆角半径
RoundedColorDrawable normal = new RoundedColorDrawable(r, 0xffff0000); // 默认背景
normal.addStateColor(new int[]{ android.R.attr.state_pressed}, 0xff00ff00); // pressed时的背景
normal.addStateColor(new int[]{ android.R.attr.state_selected}, 0xff00ff00); // selected时的背景

normal.applyTo(btn2); // 将背景应用到btn2上
```

注意顺序，如果Android判断当前的状态符合，则不会继续向下查找状态。在selector xml中，顺序要按状态的范围从小到大写。而java代码中则相反，顺序按状态的范围从大到小add。

## RoundButton

RoundButton是Button+RoundedColorDrawable的综合体，它的内部有一个类型为RoundedColorDrawable的mRoundBg对象作为背景。像半径和圆角可以在xml中配置，如下：

```xml
<cn.ieclipse.af.view.RoundButton
    android:id="@+id/btn3"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="center"
    android:background="@color/colorPrimary"
    android:text="Normal button"
    android:padding="8dp"
    android:radius="8dp"
    android:textColor="@color/white"
    android:textSize="14sp"
    app:borderColor="@color/black_alpha_60"
    app:borderWidth="1dp"
    android:layout_marginTop="20dp" />
```
其中`android:radius`、`app:borderColor`和`app:borderWidth`分别指定的Button的圆角半径，边框颜色和边框厚度。

RoundButton对于状态的操作更为简单。如下：

```java
RoundButton btn3 = (RoundButton)view.findViewById(R.id.btn3);
btn3.setPressedBgColor(0xff3F51B5);
btn3.setSelectedBgColor(0xff333333);
btn3.apply();
```

## 关于

[QuickAF] 是一个Android平台上的app快速开发框架，欢迎读者在github star或fork。本人写作水平有限，欢迎广大读者指正，如有问题，可与我直接联系或在我的官方博客中给出评论。

## 参考
QuickAF: https://github.com/Jamling/QuickAF

[QuickAF]: https://github.com/Jamling/QuickAF

