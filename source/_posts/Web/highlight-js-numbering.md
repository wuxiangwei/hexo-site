---
title: Highlight.js 添加代码行号
date: 2016-08-10 22:30:30
category: [软件技术, Web]
tags: [js]
toc: true
---

[highlight.js]是一款功能强大的代码高亮Javascript工具，支持162程序语言，自带74种高亮样式，支持自动侦测语言类型，几乎所有的markdown都支持[highlight.js]。Hexo在[syntax-highlighting-with-highlightjs]的基础上成功实现对代码行号的添加，并且做了一些优化和改进。

注：阅读本文需要一定的前端基础知识。

## 加载highlight.js
使用[highlight.js]非常简单，只需引入[highlight.js]的css及js（推荐在主题模板中作为全局css和js引入，引入的位置在`<head></head>`之间）。

``` html
<link rel="stylesheet" href="//cdn.bootcss.com/highlight.js/9.2.0/styles/github.min.css">
<script src="//cdn.bootcss.com/highlight.js/9.2.0/highlight.min.js"></script>
```
[highlight.js]有许多代码风格，我在这里使用的是github风格。

然后，在文档加载完毕之后初始化（推荐在`</body>`之前的`<script></script>`中引入）

``` js hljs.js https://github.com/Jamling/hexo-theme-nova/blob/master/source/js/hljs.js#L3:L4
  // highlight
  hljs.initHighlightingOnLoad(); 
```

如此，便可以测试及查看代码高亮结果了。

## 添加行号
添加行号的大致过程是先将代码部分按行切割，得到代码行数。然后生成一个动态的行号列表ul插入到`<code>`标签之后

```js hljs.js https://github.com/Jamling/hexo-theme-nova/blob/master/source/js/hljs.js#L51:L59
    if (ds.line_number === 'frontend') {
      console.log("show line number in front-end");
      var lines = texts.length - 1;
      var $numbering = $('<ul/>').addClass('pre-numbering');
      $(this).addClass('has-numbering').parent().append($numbering);
      for (i = 1; i <= lines; i++) {
        $numbering.append($('<li/>').text(i));
      }
    }
```

对于有行号的`<code>`标签，多了一个`has-numbering`的样式，行号列表`ul`的样式为`pre-numbering`。通过定义`has-numbering`和`pre-numbering`css规则来控制行号与代码块的显示及对齐。

```css nova.scss https://github.com/Jamling/hexo-theme-nova/tree/master/source/css/bs/nova.scss
code.has-numbering {
  margin-left: 1.7em !important; /*因为显示行号，所以离左边有一定的距离*/
  word-wrap: normal; 
  word-break: keep-all;
  white-space: pre;
}

.pre-numbering {
  position: absolute; /*绝对定位*/
  top: 0;
  left: 0;
  width: 2.2em; /*行号的宽度*/
  height: 100%;
  padding: 0.5em 0.2em 0.5em 0; /*上下padding保持与<code>一致，不然出现错位*/
  border-right: 1px solid #C3CCD0;
  border-radius: 3px 0 0 3px;
  background-color: #EEE;
  text-align: right;
  font-size: 1.0em; /*字体大小与<code>一致*/
  color: #AAA;
  list-style: none;
}
```

比较重要的规则在上面的css中均有注释说明。完整CSS请参考Nova中的样式。

***注，具体的样式需根据当前主题做出适当的修改***

## 处理滚动

添加了行号，为使行号与代码行不错乱，所以要求代码块在横向允许滚动，一般来说显示行号的`<code>`标签，还需加上以下css规则。
```css
code {
    overflow-x: auto;
    overflow-y: auto;
    word-break: keep-all;
    white-space: pre;
}
```  

## 支持响应式
由于在小屏幕上，尤其是手机浏览器，横向滚动并不好操作，所以，在移动设备上通过媒体查询来设置行号`ul`不显示，并且覆盖`<code>`的样式规则为允许断行。

```css
@media (max-width: 767px) {
  .pre-numbering {
    display: none;
  }
  code.has-numbering {
    margin-left: -0.5px !important;
    word-wrap: break-world !important;
    white-space: pre-wrap !important;
  }
}
```

## 支持更多的代码语言

[highlight.js]默认支持大部分主流程序语言的高亮，但是也有小部分语言是不支持的，比如[Excel VBA基础实例教程]中贴了不少VB代码，需要额外加载[highlight.js]的VBScript.js才能高亮，则需要引入额外的高亮脚本`vbscript.js`即可。如下所示：

```html
<script src="http://cdn.bootcss.com/highlight.js/9.1.0/languages/vbscript.min.js" ></script>

```

## 代码复制
对于复制这块，比较好的解决方案是引入jquery的zclip插件（https://github.com/zeroclipboard/jquery.zeroclipboard）。如果用户选择的不仅仅是代码部分，则需要加入css规则来控制行号不被选择。

``` css
.pre-numbering {
  -webkit-user-select: none; /* Chrome all / Safari all */
  -moz-user-select: none; /* Firefox all */
  -ms-user-select: none; /* IE 10+ */
  user-select: none;  /* Likely future */ 
}
```

## 参考
syntax-highlighting-with-highlightjs: http://idodev.co.uk/2013/03/syntax-highlighting-with-highlightjs/
jquery.zeroclipboard: https://github.com/zeroclipboard/jquery.zeroclipboard
Hexo高级教程之代码高亮: http://www.ieclipse.cn/2016/07/18/Web/Hexo-dev-highlight/

[highlight.js]: https://highlightjs.org/
[hexo]: https://hexo.io
[Nova]: http://github.com/Jamling/hexo-theme-nova
[Excel VBA基础实例教程]: http://www.ieclipse.cn/2016/05/13/tech-vba-guide/
[syntax-highlighting-with-highlightjs]: http://idodev.co.uk/2013/03/syntax-highlighting-with-highlightjs/
