---
title: Git submodule简介
date: 2016-06-02 16:42:28
category: [软件技术]
tags: git
---
如果项目很大，分为众多模块的时候，需要对每个模块单独维护的时候，引入git submodule是一个非常不错的选择。尤其是对一些sdk+plugin的项目尤为适用。

<!-- more -->

比如本站是使用hexo搭建的博客，其中使用的主题与插件，都是在迁移博客时同步开发的。主题与插件，都在github上建立了单独的库。对于主题及插件的修改，只能提交到其对应的git仓库。

整个博客源代码结构如下：
<pre>
hexo-site
    source
    themes
        nova
    node_modules
        hexo-generator-github
        hexo-generator-i18n
</pre>

其中hexo-site对应Jamling/hexo-site.git，themes/nova目录对应Jamling/hexo-theme-nova.git，node_modules/下的github和i18n插件对应的也是单独的git仓库。

为了保持博客源文件的干净，在.gitignore文件中，把themes目录和node_modules目录都加入了。所以，主题与插件的修改，都不会影响到hexo-site仓库。

然后通过git submodule，将主题及插件做为hexo-site的子模块添加

```bash
git submodule add -f git@github.com:Jamlng/hexo-theme-nova themes/nova
git submodule add -f git@github.com:Jamlng/hexo-generator-github node_modules/hexo-generator-github
git submodule add -f git@github.com:Jamlng/hexo-generator-i18n node_modules/hexo-generator-i18n
```

加-f选项，是因为themes目录和node_modules目录加入了.gitignore，第一个参数为子模块的git仓库地址，第二个参数为子模块的名字。子模块成功添加之后，会在hexo-site目录下创建一个.gitmodules文件。内容如下：

```
[submodule "themes/nova"]
	path = themes/nova
	url = gh:Jamling/hexo-theme-nova
[submodule "node_modules/hexo-generator-github"]
	path = node_modules/hexo-generator-github
	url = gh:Jamling/hexo-generator-github
[submodule "node_modules/hexo-generator-i18n"]
	path = node_modules/hexo-generator-i18n
	url = gh:Jamling/hexo-generator-i18n
```

如果，对git submodule命令不熟，可以使用--help查看帮助，也可以通过直接修改.gitmodules文件来添加。然后要修改子模块，就cd到子模块下，按正常的操作执行git命令就行了。
