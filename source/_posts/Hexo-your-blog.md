---
title: Hexo your blog
date: 2016-03-04 12:48:31
category: [软件技术, Web]
tags: [Hexo, Node.js]
toc: true
---

# Overview

This article in an advanced guide to [hexo] your blog, you need to prepare the following knowledges:

- Front-end: You must has certain knowledge of Web tech such as javascript, css, html and node.js template.
- Layout: The [hexo] layout is the `view` of site, it's usually using a template to render.
- Variables: The [hexo] variables, such as <var>site.posts</va>, <var>config</var>, <var>page</var>.
- Helpers: The [hexo] helpers are used in templates to help you insert snippets quickly.

<!-- more -->

{% asset_img Hexo.png %}

If you has been prepared, I think it's no difficulty for you to make your blog a little change to others.

Index snippets:

```htmlbars
<div class="article-list">
  {%- for post in page.posts %}
  <!-- output blog to html article tag -->
  <article class="article post" itemscope itemtype="http://schema.org/Article">
    <!-- article header: output title and date -->
    <header class="article-header">
      <h1>
        <a href="{{ url_for_lang(post.path) }}" class="article-title" itemprop="name">{{ post.title }}</a>
      </h1>
      <a href="{{ url_for_lang(post.path) }}" class="article-date">{{ time_tag(post.date) }}</a>
    </header>
    <!-- output body: blog excerpt content -->
    <section class="article-content" itemprop="articleBody">
      {% if post.excerpt %}
      {{ post.excerpt }}
      {% endif %}
    </section>
    <footer class="post-item-footer">
      <!-- output blog categories and tags -->
      {{ post_cates(post) }} 
      {{ post_tags(post) }}
    </footer>
  </article>
  <hr>
  {% endfor %}
</div>

```

Index output
<div style="display:none;">
```htmlbars
        <article class="article post" itemscope itemtype="http://schema.org/Article">
          <header class="article-header">
              <h1>
                <a href="/2016/05/14/tech-adb-mobile/" class="article-title" itemprop="name">使用ADB连接手机</a>
              </h1>
            <a href="/2016/05/14/tech-adb-mobile/" class="article-date"><time datetime="2016-05-14T07:34:08.000Z">2016-05-14</time></a>
          </header>
          <section class="article-content" itemprop="articleBody">
            <h2 id="简介"><a href="#简介" class="headerlink" title="简介"></a>简介</h2><p>使用ADB连接手机进行调试，开发、文件传输</p>
<p>使用adb文件传输优点：无需卸载或挂载SD卡</p>
          </section>
          <footer class="post-item-footer">
            <span class="glyphicon glyphicon-folder-close" aria-hidden="true"></span>&nbsp;分类<ol class="breadcrumb category"><li><a class="" href="/categories/软件技术/">软件技术</a></li><li><a class="" href="/categories/软件技术/奇淫巧技/">奇淫巧技</a></li></ol> 
            
          </footer>
        </article>
	    <hr>
        
        <article class="article post" itemscope itemtype="http://schema.org/Article">
        ...
        </article>
```
</div>

{% asset_img index_post.png %}

# Theme
If you used theme published on https://hexo.io, please see the doc/guide of the theme.

But, sometimes, you want to make some change. You may edit the theme and make a little change. I think it's no difficulty for you.

However, the theme may not meet you. I had want to find one theme to set up the site for my github project once, unfortunately, I found none that help me to build site quickly. So, I decided to create my own theme. And the guide based on [Nova].

The first thing is to design.

## Design

The content is divided to three modules

 1. Blog article
 It's a little different from other theme, include index, tags, categories, pagination basic function.
 
 It's two-columns layout, the main container is the post list or post detail, the aside container is widgets or toc.
 2. Project page
 It's a sub layout of page, include project docs nagivator sidebar, project list, toc.
 
 It's three-columns layout, the main container is page content, and the left aside is project nagivator and the right aside is toc suffix
 3. Other page
 Other fragment page, such as "About me".
 
 It's two-columns layout like blog article.

##  Layout

The layout tree

{% asset_img layout.png %}

Please see [nova layout](/en/p/hexo-theme-nova/layouts.html) for more information.

# Plugin
There are many [plugins](https://hexo.io/plugins) of [hexo], it's easy to write a plugin under [hexo].
Just write a <var>.js</var> under <var>scripts</var> in your theme.

here is a sample (<var>scripts</var>/<var>helpers.js</var>) to write a helper plugin to return page title.
```js
// return page title.
hexo.extend.helper.register('page_title', function(page){
  var p = page ? page : this.page;
  var ret = '';
  if (p.title2) {
    ret = this.i18n(p.title2);
  }
  else if (p.title){
    ret = p.title;
  }
  return ret;
});
```

And another sample of display categories in post:
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
Use in layout/post/index.swig

```htmlbars
{{ post_cates(post) }} 
```
Will output:
<pre>
    <span class="post-category"><i class="glyphicon glyphicon-folder-close"></i><span class="hidden-xs">分类</span><a class="category-item" href="/categories/tech/">软件技术</a><a class="category-item" href="/categories/tech/Web/">Web</a></span>
</pre>

The [Nova] rewrite lost of helpers of [hexo] to simplify the style. Please visit [Helpers](/en/p/hexo-theme-nova/helpers.html) for more informations.

# Front-matter

{% blockquote Docs--- https://hexo.io/docs/front-matter.html %}
Front-matter is a block of YAML or JSON at the beginning of the file that is used to configure settings for your writings. Front-matter is terminated by three dashes when written in YAML or three semicolons when written in JSON.
{% endblockquote %}

So you can use it to do lots of things.

See [Nova Front-matter](/en/p/hexo-theme-nova/front-matter.html) for more information.

# Optimize

## I18n

[Nova] use [hexo-generator-i18n] to generate multi-languages site. The default languages is Chinese and <var>root</var>/<var>en</var> is Englisth site.

## Highlight

It's a little of failure, code highlight style not work well in [Nova].
```js
  // highlight
  hljs.initHighlightingOnLoad();
  //hljs.configure
  
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });
```

## Image

Find all images in article and add fancybox style.

```js
  $('.article').each(function(i){
    $(this).find('img').each(function(){
      /*if (!$(this).hasClass('img-responsive')) {
      $(this).addClass('img-responsive')
      }*/
      if ($(this).parent().hasClass('fancybox')) return;

      var alt = this.alt;

      if (alt) $(this).after('<span class="funcybox-caption">' + alt + '</span>');

      $(this).wrap('<a href="' + this.src + '" title="' + alt + '" class="fancybox"></a>');
    });

    $(this).find('.fancybox').each(function(){
      $(this).attr('rel', 'article' + i);
    });
    
    $(this).find('table').each(function(){
      if (!$(this).hasClass('table-bordered')) {
        $(this).addClass('table');
        $(this).addClass('table-bordered');
      }
    });
  });

  if ($.fancybox){
    $('.fancybox').fancybox();
  }
```

## SEO

[Nova] has three helper to enhance the SEO.

- head_title: Generate optimized title string in &lt;title&gt;
- head_keywords: Add tags/categores of post into keywords
- head_description: **TODO, plan to add description in Front-matter and add post excerpt to description**

## Donate

partial/donate.swig support donate in article, the 2d-code images is under image folder.
- donate_alipay.png: Donate via Alipay
- donate_wechat.png: Donate via Wechat

## Baidu site tools
For China.
login [百度站长平台](http://zhanzhang.baidu.com/), and add your site then to verify.

Verification

* File verification 
    download baidu_xxxx_verify.html and upload to your site root dir to verify.
* HTML tag verification 
    add `<meta name="baidu-site-verification" content="xxx" />`
 to your home .html
* CNAME verification    
    add a cname dns parser to zz.baidu.com

    
### tools
After site added, you can do 

1. Post links    
    I choose post my links automatically using following script
```js
<script>
(function(){
    var bp = document.createElement('script');
    bp.src = '//push.zhanzhang.baidu.com/push.js';
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(bp, s);
})();
</script>
```
2. Update robots    
    Update your robots.txt under your site root dir
3. Search in sites    
    Enable and add your script
4. Social Share    
    Custom your share style and add script
5. Analytics   
    Enable baidu analytics
6, Feedback
    Enable feedback
7, Back to top
    Useful function in mobile

    
[hexo]: https://hexo.io
[Nova]: /en/p/hexo-theme-nova
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
