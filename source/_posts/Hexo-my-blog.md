---
title: Hexo your blog
date: 2016-03-04 12:48:31
category: [软件技术, Web]
tags: [Hexo, Node.js]
toc: true
---
# Plan
 * build, get and build the [hexo](https://hexo.io), and run it successfully!
 * customize theme, change valid theme or create a new theme.
 * customize plugin, rewrite or create the helper script under your theme.
 * Optimize, optimize the site, such as search, SEO and so on.

<!-- more -->

The are many documents on the web to tell you how to setup your site with hexo. I will not explain to set up again.

The following guide require certain knowledge of Web tech such as javascript, css, html and node.js template. 

# Customize theme
If you used theme published on https://hexo.io, please see the doc/guide of the theme.

But, sometimes, you want to make some change. You may edit the theme and make a little change. I think it's no difficulty for you.

However, the theme may not meet you. I had want to find one theme to set up the site for my github project once, unfortunately, I found none that help me to build site quickly. So, I decided to create my own theme. 

The first thing is to design.

## Design

The content is divided to three modules

 1. Blog article
 It's a little different from other theme, include index, tags, categories, pagination basic function.
 2. Project page
 It's a sub layout of page, include project docs nagivator sidebar, project list, toc.
 3. Other page
 Other fragment page, such as "About me".

##  Layout

The layout tree

<pre>
layout
	post
		index.swig // home
		post.swig // post detail
		archive.swig // archive/tag/category 
		widget_xxx.swig // search, tags, categories, recently... widget_xxx.swig // search, tags, categories, recently...widget_xxx.swig // search, tags, categories, recently...
	project
		projects.swig // project home, list repos on github
		releases.swig // list repo releases on github
		contents.swig // display repo contents on github
		sidebar.swig // project navigator side bar
	portail
		header.swig // html head, header
		footer.swig // html footer
		comment.swig // page comment
		toc.swig    // toc suffix
	page
		categories.swig // all categories
		donates.swig // donate records and rank
	index.swig // index layout dispatcher, link to post/index.
	post.swig // post layout dispatcher.
	page.swig // page layout dispatcher.
	project.swig // project layout dispatcher.
</pre>

# Customize plugin

## Front-matter

- toc 
Whether show toc or not, default post off, page and project on
- title2
I18n title key, if title2 translated it will replace title
- gh github object used in project layout, has four attr <var>type</var>, <var>path</var>, <var>user</var>, <var>repo</var>.
- type page type used in page layout to extend page

## Tag helpers
- nova_list_categories()
- nova_list_posts()
- nova_list_archive()
- nova_archives()
- nova_paginator()
- nova_paginator2()
- nova_toc()

## Project helpers
- gh_repos()
- gh_get_releases()
- gh_get_contents()
- p_nav()

# Optimize
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

    
