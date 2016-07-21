---
title: Hexo高级教程之代码高亮
date: 2016-07-18 22:30:30
category: [软件技术, Web]
tags: [Hexo, Node.js]
toc: true
---

<style>
.nowrap {
    word-wrap: normal;
    word-break: keep-all;
    white-space: pre;
}
</style>

## Hexo高亮

hexo已实现代码高亮，代码封装在hexo-util插件中，使用的是[hightlight.js]，通过`include_code`tag标签来使用，功能已经很强大了，而且自带行号显示，可以满足大多数博主的需求了。但是它仍然存在一些局限性，比如在[Nova]主题中，有些语言不支持，无法高亮，而且界面也比较丑，所以个人还是倾向于自由使用[hightlight.js]来高亮代码，使用起来比较灵活，还能扩展一些功能，但是[hightlight.js]默认是不带行号的。为此，也是遇到了不少坑。后来在某歪果仁的博客中找到一个行号解决方案，在其基础上，终于实现了一个较为理想的代码高亮方案。

## 加载highlight.js
使用[highlight.js]非常简单，只需以下简单的几步。
首先，在博客站点根目录的<var>_config.yml</var>中，将<var>highlight.enable</var>设置为<code>flase</code>以关闭自带的高亮方案。

其次，引入highlight.js的css及js（如果使用较多，推荐在主题模板中作为全局js引入）。
``` html
<link rel="stylesheet" href="//cdn.bootcss.com/highlight.js/9.2.0/styles/github.min.css">
<script src="//cdn.bootcss.com/highlight.js/9.2.0/highlight.min.js"></script>
```
[highlight.js]有许多代码风格，博主可以根据博客站点主题风格，选择合适的代码风格，我使用的是github风格。

然后，在文档加载完毕之后初始化
``` js 
  // highlight
  hljs.initHighlightingOnLoad();
```

如此，便可以测试及查看代码高亮结果了。

## 添加行号
添加行号的大致过程是先将代码部分按行切割，动态生成行号。然后使用相对布局，将行号显示在代码行前。具体代码如下：

```js
  $('pre code').each(function(i, block) {
    //hljs.highlightBlock(block);
    var lines = $(this).text().split('\n').length - 1;
    var $numbering = $('<ul/>').addClass('pre-numbering');
    $(this)
      .addClass('has-numbering')
      .parent()
      .append($numbering);
    for(i=1;i<=lines;i++){
      $numbering.append($('<li/>').text(i));
    }
  });
```

这样`<code>`标签多了一个`has-numbering`的样式，在`<pre>`结节下，动态添加了一个class为`pre-numbering`的`ul`列表来显示行号。CSS代码如下：
```css
code.has-numbering {
  margin-left: 10px;
  word-wrap: normal;
  word-break: keep-all;
  white-space: pre;
}

.pre-numbering {
  position: absolute;
  top: 0;
  left: 0;
  width: 20px;
  height: 100%;
  padding: .5em 0.2em .5em 0;
  border-right: 1px solid #C3CCD0;
  border-radius: 3px 0 0 3px;
  background-color: #EEE;
  text-align: right;
  font-size: 1.0em;
  color: #AAA;
  list-style: none;
}
```

***注，具体的样式需根据当前主题做出适当的修改***

## 处理滚动

添加了行号，为使行号与代码行不错乱，所以要求代码块在横向允许滚动，在处理滚动前，先了解以下三个文本换行的css属性。

- `white-space` 
 
值 | 描述
--- | --- 
normal | 默认。空白会被浏览器忽略。
pre | 空白会被浏览器保留。其行为方式类似 HTML 中的 `pre` 标签。
nowrap | 文本不会换行，文本会在在同一行上继续，直到遇到 `<br>` 标签为止。
pre-wrap |  保留空白符序列，但是正常地进行换行。
pre-line | 合并空白符序列，但是保留换行符。
inherit | 规定应该从父元素继承 white-space 属性的值。

- `word-wrap` 
 
值 | 描述
--- | --- 
normal | 只在允许的断字点换行（浏览器保持默认处理）。
break-word | 在长单词或 URL 地址内部进行换行。

- `word-break` 
 
值 | 描述
--- | --- 
normal | 使用浏览器默认的换行规则。
break-all | 允许在单词内换行。
keep-all |  只能在半角空格或连字符处换行。

除了以上三个属性，还有一个text-wrap属性，不过，大部分浏览器都不支持。所以，仅供参考。
~~text-wrap~~

值 | 描述
--- | --- 
normal | 只在允许的换行点进行换行。
none | 不换行。元素无法容纳的文本会溢出。
unrestricted | 在任意两个字符间换行。
suppress | 压缩元素中的换行。浏览器只在行中没有其他有效换行点时进行换行。

所以，显示行号的`<code>`标签，还需加上以下css规则。
```css
overflow-x: auto;
overflow-y: auto;
word-break: keep-all;
white-space: pre;
```  

## 支持响应式
由于在小屏幕上，尤其是手机浏览器，横向滚动并不好操作，所以，须优化，让代码允许断行，这样，行号就不能显示了。

```css
@media (max-width: 767px) {
  .pre-numbering {
    display: none;
  }
  .has-numbering {
    margin-left: -10px !important;
    word-wrap: break-world !important;
    white-space: pre-wrap !important;
  }
}
```

[hightlight.js]: https://highlightjs.org/
[hexo]: https://hexo.io
[Nova]: http://github.com/Jamling/hexo-theme-nova
