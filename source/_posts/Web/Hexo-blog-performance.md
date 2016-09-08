---
title: Hexo页面加载性能优化
date: 2016-08-30 20:30:30
category: [Web]
tags: [Hexo]
toc: true
---

## 引言

影响网页打开速度的原因有许多种，本文主要对部署在github上的hexo博客页面的加载速度做一个分析。然后给出几点相关的优化建议。

<!-- more -->

## 加载速度对比
先看下面几个站点的加载速度
- www.ieclipse.cn
这是我自己的站点，使用了双线部署，国内节点为coding.net。
{% asset_img ieclipse.cn.png %}
请求非常多，52个请求，页面加载用时427ms，加上其它的异步请求，总用时1.54s。相当于页面秒开。加载相对较慢的有nova.css和那个自动隐藏导航栏的js脚本。其它的像jq和bootstrap都使用了cdn，加载还是相当快的。

- csdoker.com
{% asset_img csdoker.com.png %}
请求虽然少，只有14个，但是加载速度非常慢，主要是博客部署在github上，国内访问较慢，页面呈现用时5s，全部加载总用时11.74s。相对加载速度较慢的主要是背景，头像和字体文件。总体来说加载慢。

- fatdoge.cn
{% asset_img fatdoge.cn.png %}
请求也少，只有12个，但是加载速度却是相当地慢，光域名解析建立连接就将近5s，剩下的大家看图。到我截完图，它还在加载其它的一些资源。

- login926.github.io
{% asset_img login926.github.io.png %}
请求较多，影响页面呈现的只有前5个请求，在1.4s内加载完成。因为脚本和css少。呈现非常快。页面总加载耗时3.95s。如果考虑数据量的话，此网站的加载速度是最快的。


## 优化建议
- 使用多线部署，因为国内访问github比较慢，建议博客可以放在国内的站点。具体教程可以参考本站另一文章：[Hexo博客双线部署]
- 使用cdn，对于字体，js，css等静态资源，如果有cdn加速，建议使用cdn。比如我的博客，jquery, bootstrap使用的都是cdn。
- 尽量使用简洁的主题，比如Next，像上面的csdoker.com和fatdoge.cn使用的主题，加载就慢多了。
- js脚本尽量后置，如果不影响功能，建议放在&lt;/body&gt;之前，并且能异步加载的，尽量异步加载。比如本站的nova主题，许多脚本都是后置并且异步的。

[Hexo博客双线部署]: /2016/08/29/Web/Hexo-deploy-lines/
[hexo]: https://hexo.io
[hexo-generator-index2]: http://github.com/Jamling/hexo-generator-index2
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
