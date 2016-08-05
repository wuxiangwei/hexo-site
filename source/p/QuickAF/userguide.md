---
title: User guide
date: 2016-01-30 17:43:26
layout: project
title2: project.userguide
---

整体框架采用MVC模式，Activity/Fragment为View层。XXXController为Controller层。各种请求及响应模型为model层。

## BaseActivity/BaseFragment
app中的所有activity，建议都继承BaseActivity，所有Fragment建议都继承BaseFragment。
下面对BaseActivity/BaseFragment中的界面初始化方法做简单的说明
### 初始化窗体

```java
protected void initWindowFeature() {
    requestWindowFeature(Window.FEATURE_NO_TITLE);
}
```

在此方法中，可以设置界面窗体特征，比如，标题栏是否可以，是否全屏，是否沉浸式效果，是否显示标题栏，是否悬浮标题栏等。
**BaseFragment无此方法*

### 初始化参数

```java
protected void initIntent(Bundle bundle) {

}
```

在此方法中，可以初始化参数，如activity/fragment恢复状态，或是从其它界面传入的参数。

### 初始化顶部

```java
protected void initHeaderView() {
    // 
}
```

比如左边设置一个返回的text view，中间设置一个text view用于显示标题

### 初始化主体

```java
protected void initContentView(View view) {

}
```
初始化界面主体（中间）部分

### 初始化底部

```java
protected void initBottomView() {

}
```

*BaseFragment无此方法*

### 初始化数据

```java
protected void initData() {

}
```

### 设置悬浮标题栏
void cn.ieclipse.af.app.AfActivity.setOverlay(boolean overlay)

仅在标题栏可见时有效

### 设置标题栏可见
void cn.ieclipse.af.app.AfActivity.setShowTitleBar(boolean showTitleBar)
设置是否显示标题栏
注：如果在initWindowFeature中设置为不可见，那么initHeaderView将不会被调用

## 常用控件
### TitleBar
TitleBar定义了标题栏的布局。分为左，中，右三块区域。可以根据设计方案对TitleBar进行设置。
默认情况下，BaseActivity中对TitleBar的定义为：
左侧返回TextView：mTitleLeftView
中间标题名称TextView：mTitleTextView
一般情况下，只需要设置mTitleTextView的文本即可
下面主要是对右侧菜单进行添加

- 右侧button为图片:
``` java
mTitleTextView.setText(R.string.house_title);
mMap = (ImageView) mAbTitleBar.addRightView(R.layout.layout_title_icon);
mMap.setImageResource(R.drawable.title_map);
mSearch = (ImageView) mAbTitleBar.addRightView(R.layout.layout_title_icon);
mSearch.setImageResource(R.drawable.title_search);
setOnClickListener(mMap, mSearch);
```

- 右侧button为文字:
```java
mManageTv = (TextView) mTitleBar.addRightView(R.layout.layout_title_text);
mManageTv.setText(isMyList() ? R.string.note_my_book_title_manage : R.string.note_other_book_title_change);
```

- 右侧button为图片加文字(比较少)
```java
mSubmit = (TextView) mTitleBar.addRightView(R.layout.layout_title_post_submit);
```
然后再更改drawableLeft…等.

## AppController
各个App客户端用到的接口可能不一样，定义的消息码也未必一样。所以需要针对当前接口的特性，编写具体的AppController，AppController继承Aflibrary中的Controller。用于管理接口异步请求task。工程中的所有controller必须继承AppContoller。
建议的做法：
一个接口对应一个task，一个task对应listener中的两个方法，一个onXXXSuccess方法用于监听task的成功调用，一个onXXXFailure方法用监听task的调用失败

### UploadController
用于带图片、文件上传的地方

## Model
### BaseRequest
所有网络请求模型的顶层类

### BasePostRequest
所有需要带身份信息的网络请求模型父类

4.5.3   BaseListPostRequest
带分页请求和身份信息的网络请求模型父类
4.5.4   BaseResponse
网络请求返回的大对象，如data数据为空，刚定义返回的模型为BaseResponse即可
4.5.5   BaseListInfo
响应data中带分页的响应模型
4.5.6   XxxInfo
响应data中的响应模型
需要实现java.io.Serializable接口，如果配合RefreshableListView使用，需要重写equals方法

