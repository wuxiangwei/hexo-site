---
title: Hexo高级教程之文章阅读计数
date: 2016-07-28 22:30:30
category: [Web]
tags: [Hexo, js]
toc: true
---

## 引言

Hexo的NexT主题非常流行，之前看过某博友的博客，使用的就是NexT主题，在文章列表页面，竟然还显示了文章的阅读次数！Hexo是静态博客，像阅读次数的实现必须借助第三方工具。早期[Nova]主题使用的是友言评论，不像多说评论开放了许多API，所以，从版本0.1.0开始，本站使用的[Nova]主题就换成了多说。在多说的[获取文章评论、转发数API](http://dev.duoshuo.com/docs/50615732a834c63c56004257)中，`views`即为文章阅读数，不过好像多说对非官方的网站不开放此字段，`views`返回的一直为0。昨天阅读了一下博友的[为NexT主题添加文章阅读量统计功能](https://notes.wanghao.work/2015-10-21-%E4%B8%BANexT%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E9%98%85%E8%AF%BB%E9%87%8F%E7%BB%9F%E8%AE%A1%E5%8A%9F%E8%83%BD.html#%E9%85%8D%E7%BD%AELeanCloud)这篇文章，原来NextT的阅读数是借助云API来实现了。所以，立即动手，也为本站的[Nova]主题添加阅读计数功能。

如果有使用非NexT主题，也想实现文章阅读计数的博主们，不妨跟我一起折腾，一起来修改主题吧！再次声明，本系列需要一定的前端基础知识。

## LeanClound配置

### 注册验证
如果还没有[LeanClound]账号，先去[LeanClound]上注册账号，并通过邮箱验证。

### 创建应用

{% asset_img lc_console.png %}

登录后，在控制台创建一个应用，比如ieclipse.cn，然后在应用->设置->应用Key->下将App ID和App Key配置到主题`_config.yml`配置文件中。

```yaml
lc:
  enable: true # true|false
  class: Counter # leanclound上的class名称
  app_id: rYUER9KxmGUXSpfEtu7wCFMo-gzGzoHsz
  app_key: k7hzTkcS0blxgry4VT9rJjYj
```

### 应用安全
在控制台应用->设置->安全中心->Web 安全域名项，将网站的安全域名写全，每行一个域名，换行分隔，协议、域名和端口号都需严格一致（3 分钟后生效）。注，如开发调试阶段，可以将本地的Hexo地址(http://127.0.0.1:4000)写上，但开发调试完毕之后记得删除。
```
http://ieclipse.cn
http://www.ieclipse.cn
http://jamling.github.io
http://jamling.github.com
http://jamling.coding.me
```
配置完毕之后点击保存。

### 创建Class
我们要使用[LeanClound]的数据保存功能，将文章的阅读次数及相关信息保存到[LeanClound]

在控制台应用->存储选项，创建一个Class（Class相当于数据库中的表），注意创建Class时，弹出的对话框中**设置数据条目的默认 ACL 权限 **要勾选**无限制**（所有人可读可写）。因为，每个访客点击文章，均需要更新数据库，请阅读自增1。

{% asset_img lc_storage.png %}

如果不想修改主题配置，则创建的Class名称须为**Counter**，如果名字不为主题默认的**Counter**，记得在主题配置中修改。

Counter表创建成功之后，无需添加数据库字段。点击博客文章进去之后，会自动将博客文章的信息写入此Class。除了`views`字段，还有

- `pageId` 用于标识文章唯一ID，使用[Nova]主题，可以使用`page_uid()`方法来生成。如果访问的文章`pageId`相同，那么`views`则加1。
- `url` 文章页面的url，主题中可以使用`page.permalink`来写入
- `title` 文章页面的标题，如`page.title`

关于更多信息，可以参考[为NexT主题添加文章阅读量统计功能]

### 创建索引
待成功生成第一条数据之后，需要对`Counter` Class生成唯一索引，以防止出现对同一文章出现多次统计的错误。如下图所示：

{% asset_image lc_index.png %}

点击“其它”->“索引”，在弹出的对话框中选择`pageId`，再点击“创建”按钮，如果Class中的数据`pageId`唯一的话，那么将会成功创建索引。否则，需要手动删除重复数据再创建索引。

## 功能实现
上面的准备工作做完之后，就可以在主题中实现文章阅读计数功能了。

### 阅读计数
我的思想是，当hexo页面加载的时候，使用AJAX向[LeanClound]查询当前页面信息，如果不存在，则创建一条新记录；存在则对计数器加1后再更新到数据库。[LeanClound]有javascript sdk，使用官方SDK来执行相关操作。代码（`layout/partial/lc.swig`）如下：


```js
{%- if theme.lc %}
<!-- LeanClound官方Javascript SDK -->
<script src="https://cdn1.lncld.net/static/js/av-min-1.2.1.js"></script>
<script>
  AV.init({
    appId : '{{theme.lc.app_id}}',
    appKey : '{{theme.lc.app_key}}'
  });

  var lc_config = {
    pageId : '{{page_uid()}}',
    url : '{{page.permalink}}',
    title : '{{page_title()}}'
  };
  
  var lc_table = '{{theme.lc.class}}' || 'Counter';

  (function() {

    var query = new AV.Query(lc_table);
    query.select(['-ACL']);
    query.equalTo('pageId', lc_config.pageId);
    query.first().then(function(data) {
      if (!data) {
        insert(data);
        return;
      }
      update(data);
    });

    function insert(data) {
      if (!data) {
        console.log('data is null new object');
        var M = AV.Object.extend(lc_table);
        data = new M();
        data.set('views', 1);
      }
      for ( var key in lc_config) {
        data.set(key, lc_config[key]);
      }
      data.save().then(function(data) {
        console.log('created objectId is ' + data.id);
      }, function(error) {
        console.log("create object failed");
        console.log(error);
      });
    }

    function update(data) {
      data.increment('views', 1);
      data.save().then(function(data) {
        console.log("update to " + data.get('views'));
      }, function(error) {
        console.log("update object failed");
        console.log(error);
      });
    }
  })();
</script>
{%- endif %}
```

以上代码，`lc_config`和`lc_table`如果使用的不是[Nova]主题，请根据当前主题做出相应的修改。

### 获取计数

在文章首页，需要获取计数。代码（`layout/post/index_script_lc.swig`）如下：

``` js
{%- if theme.lc.enable %}
<script>
  $(document).ready(function() {
    // load views count from leanclound
    // make sure you are created Counter table on leanclound
    function lc_load_views(selector, options) {
      var o = options || {};
      var tkeys = [];
      $(selector).each(function(i) {
        var tkey = $(this).data('tkey');
        tkeys.push(tkey);
      });

      var query = new AV.Query(lc_table);
      query.select([ '-ACL', '-createdAt', '-updatedAt', '-url' ]);
      query.containedIn('pageId', tkeys);
      query.find().then(function(results) {
        $(selector).each(function(i) {
          var tkey = $(this).data('tkey');
          for (var i = 0; i < results.length; i++) {
            var t = results[i];
            if (t.get('pageId') === tkey) {
              var c = t.get('views') + '';
              $(this).find(o.p.views).html(c);
            }
          }
        });
      }, function(error) {
      });
    }

    lc_load_views('.card-action', {
      style : 'hidden-xs',
      p : {
        views : '.nova-eye .count'
      }
    });
  });
</script>
{%- endif %}

```

以上代码需要在文章列表项底部div中添加`data-tkey`属性，值为`pageId`，非[Nova]主题，需要修改`lc_load_views()`方法的选项或自定义。

## 参考
JavaScript 数据存储开发指南: https://leancloud.cn/docs/leanstorage_guide-js.html
LeanClound REST API详解: https://leancloud.cn/docs/rest_api.html

## 文档历史

- 2016-07-29 添加[创建索引](#创建索引)一节 

[Hexo]: https://hexo.io
[Nova]: http://github.com/Jamling/hexo-theme-nova
[LeanClound]: http://www.leanclound.cn
[为NexT主题添加文章阅读量统计功能]: https://notes.wanghao.work/2015-10-21-%E4%B8%BANexT%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E6%96%87%E7%AB%A0%E9%98%85%E8%AF%BB%E9%87%8F%E7%BB%9F%E8%AE%A1%E5%8A%9F%E8%83%BD.html#%E9%85%8D%E7%BD%AELeanCloud
