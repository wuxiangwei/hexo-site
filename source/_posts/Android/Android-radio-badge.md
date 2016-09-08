---
title: Android底部栏添加消息提醒小红点功能
date: 2016-08-02 21:00:00
category: [Android]
tags: [Android, QuickAF]
toc: true
description: Android底部栏显示小红点, Android RadioButton添加BadgeView
---

目前许多Android App都带有一个底部栏，通过底部栏可以切换Tab，比如微信，QQ都是这种风格。对于像小红点之类的醒目提醒，用得最多的就是BadgeView了，不过，如果底部栏是RadioGroup的话，那么不好意思BadgeView可不支持哦（如果使用BadgeView，RadioGroup就不能愉快地工作了）。那么如何即保留使用RadioGroup又能添加BadgeView的功能呢？请接着阅读本文。

本文阐述的是使用[QuickAF]的RadioBadgeView来解决RadioButton与BadgeView的冲突。在RadioButton上显示Badge消息提醒，需要将原来的RadioButton替换成RadioBadgeView。

## RadioBadgeView

RadioBadgeView继承自RadioButton，可以视为RadioButton的加强版。与RadioButton不同的时，它在初始化时会生成一个BadgeView2对象（BadgeView2用于展现小红点，后文有详细介绍）。在onDraw时，调用BadegView2的draw方法将小红点画到界面上。

```java
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawBadge(canvas);
    }
    
    private void drawBadge(Canvas canvas) {
        Point p = getBadgePosition();
        canvas.save();
        canvas.translate(p.x, p.y);
        badgeView.draw(canvas);
        canvas.restore();
    }

    /**
     * Calculate the badge view position, default is the top-right of the radio
     * button with a top drawable.
     *
     * 
     * @return the position of badge view relative to target
     */
    protected Point getBadgePosition() {
        int offw = getMeasuredWidth() >> 1;
        int offh = getMeasuredHeight() >> 1;
        // 注意这里不考虑复杂的布局
        Drawable d = getCompoundDrawables()[1]; // top drawable;
        if (d != null) {
            offw += d.getIntrinsicWidth() >> 1;
            offh -= (getCompoundDrawablePadding() + d.getIntrinsicHeight()
                    + (getPaint().descent() - getPaint().ascent())) / 2;
            offh -= badgeView.getMeasureHeight() / 2;
            if (offh < 0) {
                offh = 0;
            }
        }
        return new Point(offw, offh);
    }
```

从上面的代码可以看到，`drawBadge`用来画BadgeView, `getBadgePosition()`用于获取BadgeView的位置。注意了，这个位置坐标位于top drawable的右上角，如果你的页面要求小红点位于其它地方，比如右下角，那么需要参考本类的实现，重写`getBadgePosition()`方法。

如何控制显示的数目呢？

请看以下代码：

```java
    public BadgeView2 getBadgeView() {
        return badgeView;
    }
    
    public int getBadgeCount() {
        return badgeView.getBadgeCount();
    }
    
    public void setBadgeCount(int count) {
        badgeView.setBadgeCount(count);
    }
    
    public void incrementBadgeCount(int increment) {
        int count = getBadgeCount();
        setBadgeCount(increment + count);
    }
    
    public void decrementBadgeCount(int decrement) {
        incrementBadgeCount(-decrement);
    }
```

像常用的对BadgeView数目的操作，都委托<var>badgeView</var>去执行了。更多的操作，需要通过`getBadgeView()`返回<var>badgeView</var>来执行。

那么可以认为RadioBadgeView相当于一个Decorator。真正的玄机还在BadgeView2类中。

## BadgeView2

BadgeView2与BadgeView很像，熟悉BadgeView的同学阅读BadgeView2的代码应该很容易，由于BadgeView2的代码较长，这里只讲部分重点功能。

### 设置显示Style
BadgeView2提供三种显示风格

- 显示背景，背景一般都是一个小圆点
- 显示数字，比如QQ的消息数目，有最大值限制，可以自定义
- 都显示（显示背景+显示数字）

代码如下：

```java
    /**
     * Set badge view display style
     * 
     * @param badgeStyle combined value of {@link #STYLE_BACKGROUND}, {@link #STYLE_TEXT}
     * @see BadgeView2#STYLE_BOTH
     * @see BadgeView2#STYLE_BACKGROUND
     * @see BadgeView2#STYLE_TEXT
     *      
     */
    public void setBadgeStyle(int badgeStyle) {
        if (this.badgeStyle != badgeStyle) {
            this.badgeStyle = badgeStyle;
            requestLayout();
        }
    }
```

### 设置背景
提供两个API来设置背景

- 通过指定背景半径(radius)和背景色(bgColor)来设置（背景为ShapeDrawable）
- 通过设置背景图片（png或9.png）

详细代码如下：

```java
    /**
     * <p>
     * Set shape drawable as background. If set
     * {@link BadgeView2#STYLE_BACKGROUND} style the background will displayed
     * as circle with assigned radius.
     * 
     * </p>
     * <p>
     * <b><em>Note </em></b>
     * If badge count less than 10 or {@link #badgeStyle} set to
     * {@link #STYLE_BACKGROUND} the background will display as circle
     * </p>
     * If radius assigned, set a default horizontal padding of radius also.
     * 
     * @param radius
     *            the radius of circle background under
     *            {@link BadgeView2#STYLE_BACKGROUND} style, px unit
     * @param bgColor
     *            background color, ARGB format
     */
    public void setBadgeBackground(int radius, int bgColor) {
        float[] radiusArray = new float[] { radius, radius, radius, radius,
                radius, radius, radius, radius };
        padding = new Rect(radius, 0, radius, 0);
        RoundRectShape roundRect = new RoundRectShape(radiusArray, null, null);
        ShapeDrawable bgDrawable = new ShapeDrawable(roundRect);
        bgDrawable.getPaint().setColor(bgColor);
        bgDrawable.setPadding(padding);
        this.badgeBackground = bgDrawable;
        requestLayout();
    }

    /**
     * Set badge background, may be a .9.png, to get well display effect, you
     * may call {@link BadgeView2#setBadgePadding(int, int, int, int)} to set
     * paddings
     * 
     * 
     * @param d
     *            background drawable
     * @see BadgeView2#setBadgePadding(int, int, int, int)
     */
    public void setBadgeBackground(Drawable d) {
        if (this.badgeBackground != d) {
            badgeBackground = d;
            requestLayout();
        }
    }    
```

其它的API就不详细介绍了，有兴趣可以查看[QuickAF]源代码。

### 使用方法
在[QuickAF]的sample app中，底部的导航栏使用的就是RadioBageView，另外，在示例中还包含RadioBadgeView的三种使用方式

```java
   int r = AppUtils.dp2px(view.getContext(), 4);
   int ts = AppUtils.sp2px(view.getContext(), 12);
   
   rb1 = (RadioBadgeView) findViewById(R.id.radio_badge1);
   rb2 = (RadioBadgeView) findViewById(R.id.radio_badge2);
   rb3 = (RadioBadgeView) findViewById(R.id.radio_badge3);
   
   rb1.getBadgeView().setBadgeBackground(ts >> 1, 0xffff0000);
   rb1.getBadgeView().setTextSize(ts);
   rb1.getBadgeView().setMax(10, null);
   
   rb2.getBadgeView().setBadgeBackground(
           getResources().getDrawable(android.R.drawable.btn_radio));
   rb2.getBadgeView().setTextColor(0xff00ff00);
   rb2.getBadgeView().setTextSize(ts * 3 / 2);
   rb2.getBadgeView().setBadgePadding(r, 0, r, 0);
   
   rb3.getBadgeView().setBadgeBackground(
           getResources().getDrawable(R.mipmap.logo));
   rb3.getBadgeView().setTextColor(0xff0000ff);
   rb3.getBadgeView().setTextSize(ts * 2 / 3);
```

layout中有三个RadioBadgeView，分别为rb1, rb2和rb3。

- **rb1**：使用ShapeDrawable作背景，最大数目显示10
- **rb2**：使用9.png作背景
- **rb3**：使用png图片作背景

布局Layout如下：

```xml
<RadioGroup
    android:id="@+id/radioGroup2"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_marginTop="20dp"
    android:background="#ffeeeeaa"
    android:gravity="center_vertical"
    android:minHeight="55dp"
    android:orientation="horizontal" >

    <cn.ieclipse.af.view.RadioBadgeView
        android:id="@+id/radio_badge1"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:button="@null"
        android:drawableTop="@android:drawable/ic_menu_camera"
        android:gravity="center"
        android:padding="8dp"
        android:text="Shape bg" />

    <cn.ieclipse.af.view.RadioBadgeView
        android:id="@+id/radio_badge2"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:button="@null"
        android:drawableTop="@android:drawable/ic_menu_save"
        android:gravity="center"
        android:padding="8dp"
        android:text="9png bg" />

    <cn.ieclipse.af.view.RadioBadgeView
        android:id="@+id/radio_badge3"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:button="@null"
        android:drawableTop="@android:drawable/ic_menu_manage"
        android:gravity="center"
        android:padding="8dp"
        android:text="png bg" />
</RadioGroup>
```

大家可以在[QuickAF]的sample app中修改显示风格，设置padding，增加或减少数目来查看效果。

## 关于

[QuickAF] 是一个Android平台上的app快速开发框架，欢迎读者在github star或fork。本人写作水平有限，欢迎广大读者指正，如有问题，可与我直接联系或在我的官方博客中给出评论。


## 参考
BadgeView: https://github.com/stefanjauker/BadgeView
QuickAF: https://github.com/Jamling/QuickAF

[QuickAF]: https://github.com/Jamling/QuickAF

