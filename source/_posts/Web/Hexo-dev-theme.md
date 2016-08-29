---
title: Hexo高级教程之主题开发
date: 2016-07-14 20:48:30
category: [软件技术, Web]
tags: [Hexo]
toc: true
---

## 引言

有感于[hexo]高级教程实在太少，当初本人在开发[Nova]主题时，曾遇到过不少坑，为填这些坑，较为深入地学习了[hexo]源码，又自学了不少[node.js]知识，才总算将这些坑基本填完。本着人人为我，我为人人的分享精神，特开一[hexo]高级教程专题，希望广大[hexo]爱好者拍砖~

本系列的定位为高级教程，所以要求读者具备以下知识或技能：

- 前端技术：前端基础知识不用说了，必须要具备的比如HTML，CSS，Javascript，Node.js。如果知识储备不足，推荐去[W3C School]好好学习。
- [hexo模板]：[hexo]中的layout模板都是使用某个具体的模板引擎写的，模板引擎有`swig`,`ejs`，`jade`等。layout可以视为MVC模式中的`View`层，用于负责具体页面的展示。
- [hexo变量]：[hexo]内置了不少常用的变量，例如<var>site.posts</var>是站点所有的博客文章， <var>config</var>为[hexo]博客设置，<var>page</var>为[hexo]页面对象。[hexo变量]可以视为MVC模式中的`Model`层，负责给`View`提供要展示的数据。
- [辅助函数]：hexo中内置了不少[辅助函数]，这些辅助函数可以在模板中直接使用，用于快速地插入要展现的变量内容。辅助函数与MVC中的Controller有点类似，负责数据`Model`的获取以及如何在`View`中展示。
- Hexo基础知识：基础知识可以自行度娘或谷歌。PS：个人建议还是看官方文档，有简体中文版本，遗憾的是，官方网站在国内访问有点慢☺。

## 主题修改
在讲到主题开发之前，不得不讲一下主题修改。目前[hexo]已有许多成熟的主题。但是未必完全符合博主的要求。灵活性好一些的主题，可能通过修改主题配置可以达到博主的目的，有些则需要修改主题模板或CSS甚至是辅助函数。不过与开发全新的主题相比，工作量还是少了许多。个人建议，如无必要，没有必要开发全新的主题。毕竟博客网站重的是内容，而不是外观。大多数主题，都具备了博客该有的功能，就不必像我如此折腾。当然做为极客的人们则另当别论。

### 主题配置修改
这部分相对简单，因为主题一般有相关的文档来告诉你如何修改。

以主题[Nova]为例，[Nova]主题在菜单配置上，有项导航菜单叫做捐赠墙，捐赠墙是http://www.ieclipse.cn 特有的模块，对于其它博客站点并不适用，那么，只需要将它删除或使用#将其注释即可。这样，它就不会出现在菜单栏中了。

### 主题风格修改
个人推荐在已有主题样式的基础上，新建一个新的CSS文件，并做为引入样式的最后一个。因为CSS按加载的顺序，如果发现有相同选择器的样式，则后面的CSS规则会合并或覆盖原有的规则。举个例子，原来主题中的链接(a标签)颜色为蓝色（`#00f`），可以重写链接（a标签）的CSS。

原来的css：
```css 
a {
color: #00f;
}
```
追加的css：
```css
a {
color: #f96;
text-decoration: none;
}
```
color规则会覆盖原来的color规则，而text-decoration则会作为新规则引入。CSS查看器，基本上浏览器都自带此功能。调试相对来说比较简单。

### 主题模板修改
在此，还是以[Nova]主题为例，如果站点不考虑国际化，只做单语言站点，则没有必要保留语言选择功能。遗憾的是，想要不显示，则不能通过修改主题配置来实现，需要修改主题的模板文件。[Nova]主题的导航栏菜单位于`layout/partial/header.swig`中，使用记事本之类的编辑打开它，将

```htmlbars
        <ul class="nav navbar-nav navbar-right">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">{{__('page.language')}} <span class="caret"></span></a>
            <ul class="dropdown-menu">
              {%- for lang in get_langs() %}
              <li><a href="{{switch_lang(lang)}}">{{ lang_name(lang) }}</a></li>
              {%- endfor %}
            </ul>
          </li>
        </ul>
```
这一段html删除或注释即可

### 辅助函数修改
以官方的辅助函数list_archives为例，虽然此函数可以设置class参数，不过它的内部在生成ul和li时，都使用了动态的class，自动给class加了后缀。如下所示：
```js
if (style === 'list') {
    result += '<ul class="' + className + '-list">';

    for (i = 0, len = data.length; i < len; i++) {
      item = data[i];

      result += '<li class="' + className + '-list-item">';

      result += '<a class="' + className + '-list-link" href="' + link(item) + '">';
```
这样css中必须使用.xxx-list作为ul，.xxx-list-item为作li的样式，本着精减html的原则，修改后的代码为：
```js
  if (style === 'list'){
    result += '<div class="' + className + '">';

    for (i = 0, len = data.length; i < len; i++){
      item = data[i];

      result += '<a class="' + className + '-item" href="' + link(item) + '">';
      result += transform ? transform(item.name) : item.name;
```
使用div和a来简化布局。

## 主题开发
有了前面的主题修改经验，相信博主们对hexo主题已经有一定的了解了。在这里，我把主题开发分为两种
1. 主题迁移，除了hexo之外，还有许多其它的优秀博客系统，比如Wordpress，它们也有自己的主题。其中不乏一些优秀的主题。hexo中有不少主题就是迁移自其它博客系统的优秀主题。此种方式，可以最大方式的利用成熟主题的布局和样式甚至模板。比如，主页博客文章列表，原有的主题可能是将数据库查询结果集遍历输出为html，而迁移之后的主题，则需要对site.posts遍历并输出为html。

2. 全新开发，全新开发是本文介绍的重点，但是个人并不推荐，除非具备一定的设计能力，它需要从零开始对博客进行设计，比如排版，布局，功能等等。本人开发[Nova]主题，主要是因为目前的主题+插件，不能解决我github项目文档页的展示问题，其次，也为能够更好更深入地学习前端技术☺。

### 主题设计
以[Nova]为例，我将博客站点分为3模块

1. 博客文章
与其它主题的博客文章一样，博客文章有：首页、标签、分类、归档、分页等基本功能模块。
在版面上，它是一个2栏布局，主栏显示文章列表或文章详情，侧边栏用于放置窗口小部件或者文章目录。

2. 单页
普通单页也采用主－侧边栏布局，主栏显示文章详情，侧边栏显示文章目录。 对于特别的单页，则使用单独的layout。
 
3. 项目
项目模块作为[Nova]主题一大特色，采用三栏布局方式，左侧边栏显示项目导航，主栏显示项目文档内容，右侧边栏则放置文档目录。为处理项目相关的页面，[Nova]引入一个名为`project`的layout。

### 主题模板
在使用主题模板之前，先确定一种模板引擎，[Nova]主题使用的是`swig`模板，这也是hexo默认的渲染模板。

所有的主题模板文件须放在主题`layout`目录下，其中index模板与layout模板必不可少。不然运行会报错。在layout模板，可以将html主体结构写入其中。
```htmlbars
<!DOCTYPE html>
<html lang="{{ page.lang }}">
<head>
  <meta charset="utf-8">
  <title>{{ head_title() }}</title>
  <!--设置浏览器兼容模式 -->
  <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
  <!--支持响应式 -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- 网站关键字，影响SEO -->
  <meta name="keywords" content="{{ head_keywords() }}">
  <!--网站描述，影响SEO -->
  <meta name="description" content="{{ head_description() }}"> 
  <!-- Canonical links -->
  <link rel="canonical" href="{{ url }}">
  <!--加载全局js或css -->
  {{ head_jscss() }}
  <!-- RSS -->
  {{ feed_tag('atom.xml') }}
</head>
<!--Html主体 -->
<body>
  <!-- header -->
  {{ partial('partial/header') }}
  <!-- main -->
  {{ body }}
  <!-- footer -->
  {{ partial('partial/footer') }}
  <!-- fixed action bar -->
  {{ partial('partial/fab') }}
  <!-- after footer, 第三方脚本放在最后，以免影响网页内容加载 -->
    {{ js('js/script.js')}}
    {{ partial('partial/baidu_analytics') }}
    {{ partial('partial/jiathis_share') }}
</body>
</html>
```

index模板作为博客首页的渲染页，其实也是属于post模板的一种。除了layout模板外，我将其它的模板都做了归类，跟博客文章相关的，都在post子目录中；跟单页相关的放置在page子目录中；跟项目相关的，都放置在project子目录中。详细介绍，请访问[nova layout]

下面详细介绍博客文章中的首页和详情页模板

#### 文章首页
首页即文章列表页，主栏主要显示文章列表。文章列表项显示标题，日期，分类，标签，文章摘要等信息及分享，评论等操作项，核心代码如下：
```
<main> 
{%- for post in page.posts %}
<div class="card hoverable">
  <div class="card-content">
    <h3 class="card-title">
      <a href="{{ url_for_lang(post.path) }}" class="article-title">{{ post.title }}</a>
    </h3>
    <div class="divider"></div>
    <div class="section post-header">
      <!-- sub element must be span -->
      <span class="icon nova-calendar">{{ time_tag(post.date) }}</span>
      {{ post_cates(post) }} {{ post_tags(post) }}
    </div>
    <div class="excerpt">{{ page_excerpt(post) }}</div>
  </div>
  <div class="divider"></div>
  <div class="card-action">
    <!--  评论，分享，阅读全文等链接 -->
  </div>
</div>
{%- endfor %}
<nav>{{ nova_paginator({total:page.total, class:'pagination'}) }}</nav>
</main>
```
输出结果预览：
{% raw %}
<main>
          {%- for post in page.posts %}
          <div class="card hoverable">
            <div class="card-content">
              <span class="h3 card-title"><a href="{{ url_for_lang(post.path) }}" class="article-title">{{ post.title }}</a></span>
              <div class="divider"></div>
              <div class="section post-header">
                <!-- sub element must be span -->
                <span class="icon nova-calendar">{{ time_tag(post.date) }}</span>
                {{ post_cates(post) }} 
                {{ post_tags(post) }}
              </div>
              <div class="excerpt">
              {{ page_excerpt(post) }}
              </div>
            </div>
            <div class="divider"></div>
            <div class="card-action">
              <a class="icon nova-share action-item" href="{{page_share_jiathis(post)}}" data-toggle="modal" data-target="#share-modal" target="_blank">{{__('sns.share')}}</a>
              <a class="icon nova-bubbles action-item" href="{{ url_for_lang(post.path) }}#comment" id="uyan_count_unit" du="{{ page_uid(post) }}"><span class="hidden-xs">0 {{__('sns.comment')}}</span></a>
              <a class="icon nova-heart2-full action-item" href="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_likeurl" target="_blank"><span class="hidden-xs">{{__('sns.like')}}</span></a>
              <a class="icon nova-hand-right action-item" href="{{ url_for_lang(post.path) }}" >{{__('page.more')}}</a>
            </div>
          </div>
        {%- endfor %}
    <nav> {{ nova_paginator({total:page.total, class:'pagination'}) }} </nav>
</main>
{% endraw %}
侧边栏，侧边栏主要由窗口小部件组成。如文章分类

```
    <div class="panel panel-primary" id="category">
      <div class="panel-heading">
        <h3 class="panel-title">{{ _p('category.name') }}</h3>
      </div>
      <!-- use category tree -->
      {{ nova_list_categories(site.categories, {class:'list-group', depth: 10, children_indicator: 'category'}) }}
    </div>
```
页面预览：
{% raw %}
    <div class="panel panel-primary" id="category">
      <div class="panel-heading">
        <span class="h3 panel-title">{{ __('category.name') }}</span>
      </div>
      <!-- use category tree -->
      {{ nova_list_categories(site.categories, {class:'list-group', depth: 10, children_indicator: 'category'}) }}
    </div>
    
{% endraw %}

#### 文章详情页
文章详情页，主栏显示文章内容、评论、上一页和下一页导航。
```
<article class="article post" itemscope itemtype="http://schema.org/Article">
  <header class="article-header">
    <div class="page-path"><span class="post-category">{{ page_path(post)}}</span></div>
    <div class="divider"></div>
      {%- if is_post() %}
      <h1 class="article-title" itemprop="name">{{ post.title }}</h1>
      {%- else %}
      <h1>
        <a href="{{ url_for_lang(post.path) }}" class="article-title" itemprop="name">{{ post.title }}</a>
      </h1>
      {%- endif %}
    <div class="post-header">
      <span class="icon nova-calendar"><span class="hidden-xs">{{__('page.written_on')}}</span>{{ time_tag(post.date) }}</span>
      {{ post_tags(post, {class: 'tag-item-simple'}) }}
      <span class="post-share right">
        <a href="#share" class="icon nova-share"><span class="hidden-xs">{{__('sns.share')}}</span></a>
        <a href="#comment" class="icon nova-bubbles"><span class="hidden-xs">{{__('sns.comment')}}</span></a>
        <a href="#like" class="icon nova-heart2-full"><span class="hidden-xs">{{__('sns.like')}}</span></a>
      </span>
    </div>
    <div class="divider"></div>
  </header>
  <div class="article-content" itemprop="articleBody" id="post-content">
    {{ post.content }}
  </div>
  <footer class="article-footer">
    <!--<time class="article-footer-updated" datetime="{{ date_xml(page.updated) }}" itemprop="dateModified">{{ __('page.last_updated', date(page.updated)) }}</time>-->
<!-- JiaThis Button BEGIN -->
<div class="jiathis_style"><a name="share"></a>
	<span class="jiathis_txt icon nova-share">{{__('sns.share')}}：</span>
	<a class="jiathis_button_tsina">{{__('sns.weibo')}}</a>
	<a class="jiathis_button_weixin">{{__('sns.wechat')}}</a>
	<a class="jiathis_button_twitter">{{__('sns.twitter')}}</a>
	<a class="jiathis_button_copy">{{__('sns.copy')}}</a>
	<a class="jiathis_button_ishare">{{__('sns.one')}}</a>
	<a href="http://www.jiathis.com/share?uid={{theme.share.jiathis.uid}}" class="jiathis jiathis_txt jiathis_separator jtico jtico_jiathis" target="_blank">{{__('sns.more')}}</a>
	<a class="jiathis_counter_style"></a>
  <a name="like"></a>
  <a class="jiathis_like_qzone"></a>
</div>
<!-- JiaThis Button END -->
  </footer>
</article>
<div>
  <nav>{{ nova_paginator2({show_name: true}) }}</nav>
  {{ partial('../partial/donate') }}
  {{ partial('../partial/comment') }}
</div>
```

#### 其它模板

- 单页，单页与文章详情页类似。不过没有文章详情页复杂。不做详细介绍。
- 项目文档，项目文档页须借助[hexo-generator-github]插件使用。在此也不做详细介绍。

更多的[nova layout]请点击链接查看。

### 辅助函数

{% raw %}
在前面的主题模板中，出现了大量的`{{}}`包含的文本，它是swig中调用js的方式。`{{}}`包含的内容可以是[hexo变量]，如`{{post.title}}`即是输出文章的标题。也可以是辅助函数，如`__('sns.share')`即是输出健值为<var>sns.share</var>的国际化文本，其它一些[Nova中]定义的辅助函数有：
{% endraw %}
- page_title()：返回页面标题
- page_excerpt()：返回文章摘要
- post_cates()：返回指定文章的分类
- post_tags()：返回指定文章的标签

`page_excerpt()` 辅助函数代码：
```js 
// get page excerpt
hexo.extend.helper.register('page_excerpt', function(post){
  var p = post ? post : this.page;
  var excerpt = p.excerpt;
  if (!excerpt) {
    var pos = p.content.indexOf('</p>');
    if (pos > 0){
      excerpt = p.content.substring(0, pos + 4);
    }
  }
  return excerpt;
});
```
`post_cates()`辅助函数代码
```js
// insert category of post
hexo.extend.helper.register('post_cates', function(post, options){
  var o = options || {};
  var _class = o.hasOwnProperty('class') ? o.class : 'category-item';
  var icon = o.hasOwnProperty('icon') ? o.icon : 'glyphicon glyphicon-folder-close';
  var cats = post.categories;
  var _self = this;
  var ret = '';
  if (cats == null || cats.length == 0) {
      return ret;
  }
  ret += '<span class="post-category">';
  ret += '<i class="' + icon + '"></i><span class="hidden-xs">' + _self.__('category.label') + '</span>';
  cats.forEach(function(item, i){
    ret += '<a class="' + _class + '" href="' + _self.url_for_lang(item.path) + '">' + item.name + '</a>';
  });
  ret += '</span>';
  return ret;
});
```
在`layout/post/index.swig`中使用

```htmlbars
{{ post_cates(post) }} 
```
将输出以下结果：
<pre>
    <span class="post-category"><i class="glyphicon glyphicon-folder-close"></i><span class="hidden-xs">分类</span><a class="category-item" href="/categories/tech/">软件技术</a><a class="category-item" href="/categories/tech/Web/">Web</a></span>
</pre>

点击链接查看更多的[Nova辅助函数]

***注：辅助函数放在主题`scripts`目录下***

### 主题资源
主题当中需要使用到的一些资源有css样式表，js脚本及一些图片资源。资源须放置在主题`source`目录下。在生成时，这些资源会直接复制到`public`根目录下，所以在主题模板中对资源的引用，直接以`/`为前缀+路径加载即可，如下所示：
```js
{{ css('css/bs/nova.css') }}
{{ js('js/script.js')}}
```

### 第三方插件
[hexo]是静态博客，所以像评论、分享等功能，须借助第三方插件才能实现。以评论为例，常用的评论系统有多说，友言，disqus（国外）等。如若需要使用这些第三方插件，可以到对应的官方网站上查看使用说明或集成文档。

## 建议 
- 主题模板中尽量不要写死可能会变的东西，尽量以主题配置项的方式提供配置。比如最近文章显示几条等。
- 第三方插件脚本尽量放在</body>之前，以免影响页面的显示。
- 选择一些比较成熟的前端框架，比如bootstrap以获得更好的兼容性。
- 支持响应式

## 参考
hexo: https://hexo.io
Nova: http://www.ieclipse.cn/p/hexo-theme-nova

[hexo模板]: https://hexo.io/zh-cn/docs/templates.html
[hexo变量]: https://hexo.io/zh-cn/docs/variables.html
[hexo辅助函数]: https://hexo.io/zh-cn/docs/helpers.html
[W3C School]: http://www.w3school.com.cn/
[nova layout]: /p/hexo-theme-nova/layouts.html
[Nova辅助函数]: /p/hexo-theme-nova/helpers.html
[hexo]: https://hexo.io
[node.js]: https://nodejs.org/
[Nova]: /en/p/hexo-theme-nova
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
