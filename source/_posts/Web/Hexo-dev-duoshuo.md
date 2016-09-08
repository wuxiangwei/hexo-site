---
title: Hexo高级教程之多说评论
date: 2016-07-28 21:30:30
category: [Web]
tags: [Hexo, js]
toc: true
---

## 引言

Hexo的评论系统在国内一般选用多说或友言，在我的博客主题中，早期使用的是友言，在0.1.0版本之后，我在主题中将其替换成了多说。为什么要替换呢？因为友言对于评论数，转发数等支持不好，而且也不开放API。

## 多说配置

### 登录
直接访问http://duoshuo.com 登录，多说支持QQ，微博等多种方式登录。

### 创建二级域名

登录多说后，先创建一个xxx.duoshuo.com的二级域名，比如我创建的ieclipse.duosuo.com，然后在管理台中做相应的配置。因为都是中文，就不详细说了。特别提一下的是以下几点：

- 域名白名单，在设置中，在域名白名单中添加本地地址，如127.0.0.1，不然有可能本地测试时，发现评论框不显示。
- 审核规则，最好选择游客发布的评论，不然会有许多非法的评论，比如色情广告。
- 在个人设置中心，修改主页，如果你出现在别人博客的最近访问中，别人可以点击你的头像进入你的主页。可以提高访问量。

### 获取代码
在管理台->工具中，可以获取评论，热评文章等代码。按官方的文档来配置即可。注意的是data-thread-key的配置，在你的文章页面中，data-thread-key必须唯一。在列表页，可以设置相同的data-thread-key，以合并评论。

## 多说组件

### 获取评论数
在首页，获取文章的评论数等信息。通过AJAX调用多说API来实现。注意，这里有个坑，就是ajax的跨域问题。使用jsonp，必须指定callback。代码（`layout/post/index_script_ds.swig`）如下：

```
  // load comments/likes count 
  function ds_load_comments(selector, options) {
    var o = options || {};

    var tkeys;
    $(selector).each(function(i) {
      var tkey = $(this).data('tkey');
      if (tkeys) {
        tkeys += ',' + tkey;
      }
      else {
        tkeys = tkey;
      }
    });
    var url = "http://api.duoshuo.com/threads/counts.jsonp";
    var label = {

    };
    $.ajax({
      url : url,
      dataType : "jsonp",
      type : 'get',
      data : {
        short_name : ds_short_name,
        threads : tkeys
      },
      jsonp : 'callback',
      success : function(data) {
        var r = data.response;
        $(selector).each(function(i) {
          var tkey = $(this).data('tkey');
          $(this).data("tid", r[tkey].thread_id);
          if (o.p) {
            for ( var key in o.p) {
              var c = '' + r[tkey][key] + '';
              $(this).find(o.p[key]).html(c);
            }
          }
        });
      }
    });//end ajax;
  }
```

通过在主题中给文章html标签添加data-tkey属性，然后通过ajax请求多说API，将指定thread-key的文章信息返回。当请求成功之后，再将likes, comments等数目更新到相应的html中。

### 获取最近访客

官方有示例，稍做修改即可使用，代码（`layout/post/widget_ds_recent_visitors.swig`）如下：
```
    <div class="panel panel-primary">
      <div class="panel-heading">
        <h3 class="panel-title">{{ __('widget.recent_visitors') }}</h3>
      </div>
      <ul class="ds-recent-visitors" data-num-items="12"><li class="text-center">{{__('ajax.loading')}}</li></ul>
    </div>
```

我的博客稍微修改了一下css，点击头像时，可以360旋转头像。

### 获取热评文章
前面的组件，在多说官网文档中心都可以找到示例。本着爱学习，爱折腾，爱装逼的精神，我当然不会仅限于使用别人开发好的组件，怎么也得自己亲自动手，通过多说API来实现一个组件吧。

html代码（`layout/post/widget_ds_hot.swig`）如下：
``` htmlbars
    <div class="panel panel-primary">
      <div class="panel-heading">
        <h3 class="panel-title">{{ _p('widget.hot', 2) }}</h3>
      </div>
      <div  class="list-group" id="top-threads" data-range="weekly" data-num-items="5">
        <div class="text-center">{{__('ajax.loading')}}</div>
      </div>
    </div>
```
跟官方的差不多，只不过，class不是`ds-top-threads`，如果使用官方的`ds-top-threads`class那么官方的js脚本会运行，然后生成热评文章列表。由于官方生成的html不好修改样式。所以，我使用自己的脚本来生成html，js代码（`layout/post/widget_ds_hot.swig`）如下：

```js
      var ds_top_url = 'http://api.duoshuo.com/sites/listTopThreads.jsonp';
      var ds_top_dom = $('#top-threads');
      var ds_top_param = ds_top_dom.data();
      ds_top_param.short_name = '{{theme.comments.ds.short_name}}';
      $.ajax({
        url : ds_top_url,
        dataType : "jsonp",
        type : 'get',
        data : ds_top_param,
        jsonp : 'callback',
        success : function(data) {
          if (data.code==0) {
            var arr = data.response;
            if (arr.length == 0) {
              ds_top_dom.html('{{_p("widget.hot", 0)}}');  
            } else {
              ds_top_dom.html('');  
              for(var i =0; i<arr.length;i++){
                var a = $('<a></a>').text(arr[i].title).attr('href', arr[i].url).addClass('list-group-item');
                ds_top_dom.append(a);
              }
            }
          }
        },
        error: function (xhr, msg, e) {
          ds_top_dom.html('<div class="text-center">{{__("ajax.error")}}</div>');
        }
      });
```
组件初始化时，显示*加载中...*，接口调用成功之后，生成热评文件列表html，接口调用失败，则显示*加载失败*。


## 参考
多说评论: http://duoshuo.com
Nova主题: http://github.com/Jamling/hexo-theme-nova

[Hexo]: https://hexo.io
[Nova]: http://github.com/Jamling/hexo-theme-nova
[LeanClound]: http://www.leanclound.cn
