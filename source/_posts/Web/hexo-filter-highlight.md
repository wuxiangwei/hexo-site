---
title: Hexo静态代码高亮插件
date: 2016-08-10 22:30:30
category: [Web]
tags: [Hexo, Node.js]
toc: true
---

之前本站介绍了《[Highlight.js 添加代码行号](/2016/08/10/Web/highlight-js-numbering/)》和《[Hexo高级教程之代码高亮](/2016/07/18/Web/Hexo-dev-highlight/)》算是对Hexo的代码高亮有比较深的了解了。所以萌生出了写一个
Hexo的静态代码高亮插件的想法。在原来代码高亮的基础上，允许添加代码提示及相关元数据，比如代码链接，代码标题。

注：阅读本文需要一定的前端基础知识。

## Hexo自带高亮
Hexo中插入代码有两种写法。一种叫[Code Block](https://hexo.io/docs/tag-plugins.html#Code-Block)
``` plain
{% codeblock [title] [lang:language] [url] [link text] %}
code snippet
{% endcodeblock %}
```
还有一种是[Backtick Code Block](https://hexo.io/docs/tag-plugins.html#Backtick-Code-Block)

{% raw %}``` [language] [title] [url] [link text] code snippet ```{% endraw %}

## Markdown代码高亮
Markdown中插入代码，是通过添加三个反引号（`）或三个波浪号（~）来实现的。如下示例

{% raw %}``` [language] code here <br>```{% endraw %}

像大多数的markdown如github的markdown都是这种写法。这种写法在`[language]`后面不能加其它参数，否则会输出不正常。

## 对比分析
如果使用静态的代码高亮，则必须关闭hexo自带高亮，关闭之后，如果以前的.md源文件使用的是hexo第二种插入代码的方式，则会导致hexo-renderer-marked渲染异常。而且我觉得hexo的第二种插入代码也挺不错的，尤其是链接参数。可以方便地链接到源代码。所以，针对现状，我写了hexo-filter-highlight插件，将代码块的一些元数据与代码内容分开。元数据主要由前端js来控制。而代码内容则由highlight.js来进行高亮，用于替代hexo自带高亮关闭后的代码高亮。


## 插件配置

```yaml _config.yml
hljs:
  enable: true #true to enable the plugin
  line_number: frontend # add line_number in frontend or backend
  trim_indent: backend # trim the indent of code block to prettify output. backend or front-end (recommend)
  copy_code: true # show copy code in caption.
  label:
    left: Code
    right: ':'
    copy: Copy Code
```

`enable`：用于打开或关闭本插件功能。
`line_number`：设定是由前端还是后端（本插件）添加行号（暂时只时在前端添加）
`trim_indent`：是否删除列前面的缩进空白，前端与后端均可。推荐在后端
`label`：用于初始化代码块标题（caption）显示文本。

注：本插件开启后，会在3个反引号前面添加一个`<div class="code-caption">`的div用于显示代码块caption。相应的设置均以`data-`添加在div的data域中。

一开始本插件设定了两种caption的插入位置

 － `outer`方式，在三个反引号前插入，此种方式代码块的解析完全交由markdown，能很好控制caption的显示。比如复制代码右浮动。但是此种方式，代码行`ul`无法在`<pre>`内插入。
  － `inner`方式，由插件解析三个反引号内的内容为`<pre><code>`，并且在`<code>`标签前面插入caption，后面插入行号`ul`，但是此种方式，caption内的元素无法浮动。所以目前只支持`outer`方式，如果有人能够完美解决上面的问题。请在github上提交pull-request。

除了hexo配置，还需在主题在前端脚本上加入代码高亮脚本，如此，才会对代码块高亮。

```js hljs.js https://github.com/Jamling/hexo-theme-nova/blob/master/source/js/hljs.js
  $('.article pre code').each(function(i, block) {
    var ds = $(this).parent().prev(code_caption_selector).data();
    var texts = $(this).text().split('\n');
    if (ds.trim_indent === 'frontend') {
      console.log("trim indent in front-end");
      var tab = texts[0].match(/^\s{0,}/);
      if (tab) {
        var arr = [];
        texts.forEach(function(temp) {
          arr.push(temp.replace(tab, ''));
        });
        $(this).text(arr.join('\n'));
      }
    }

    if (ds.line_number === 'frontend') {
      console.log("show line number in front-end");
      var lines = texts.length - 1;
      var $numbering = $('<ul/>').addClass('pre-numbering');
      $(this).addClass('has-numbering').parent().append($numbering);
      for (i = 1; i <= lines; i++) {
        $numbering.append($('<li/>').text(i));
      }
    }

    hljs.highlightBlock(block);
});
```

设置前端显示样式
``` css
.code-caption {
  clear: both;
  position: relative;
  top: 0; /*empty p height*/
}

.code-caption .code-caption-label {
  font-style: italic;
  font-weight: bold;
 }
 
.code-caption .code-caption-copy {
  float: right;
  @include user-select-none();
}
```
***注：其它样式请参考[Highlight.js 添加代码行号]***

## 使用
语法规则如下：
{% raw %}``` [language] [title] [link] show:off|false <br>code here <br>```{% endraw %}

参数选项如下：

- `language` 代码语言，如html, java, js
- `title` 代码标题，一般使用文件名，如hljs.js
- `link` 代码链接，一般链接到一个文件
- `show` 可以设置off或false来隐藏caption的显示

## 国际化
本插件支持国际化，只不过需要在前端来完成。在加载`hljs.js`之前的位置在主题模板中插入以下脚本
```html
    <script type="text/javascript">
    var hljs_labels = {
        left: "{{__('hljs.left')}}",
        right: "{{__('hljs.right')}}",
        copy: "{{__('hljs.copy')}}"
    }
    </script>
```

## 参考
syntax-highlighting-with-highlightjs: http://idodev.co.uk/2013/03/syntax-highlighting-with-highlightjs/
jquery.zeroclipboard: https://github.com/zeroclipboard/jquery.zeroclipboard
Hexo高级教程之代码高亮: http://www.ieclipse.cn/2016/07/18/Web/Hexo-dev-highlight/
hexo-filter-highlight: https://github.com/Jamling/hexo-filter-highlight/

[highlight.js]: https://highlightjs.org/
[hexo]: https://hexo.io
[Nova]: http://github.com/Jamling/hexo-theme-nova
[Excel VBA基础实例教程]: http://www.ieclipse.cn/2016/05/13/tech-vba-guide/
[syntax-highlighting-with-highlightjs]: http://idodev.co.uk/2013/03/syntax-highlighting-with-highlightjs/
