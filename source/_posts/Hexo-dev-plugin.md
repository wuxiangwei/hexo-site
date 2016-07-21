---
title: Hexo高级教程之插件开发
date: 2016-07-18 20:30:30
category: [软件技术, Web]
tags: [Hexo, Node.js]
toc: true
---

## 引言

{% blockquote hexo.io https://hexo.io/zh-cn/docs/plugins.html 插件  %}

Hexo 有强大的插件系统，使您能轻松扩展功能而不用修改核心模块的源码。在 Hexo 中有两种形式的插件：

脚本（Scripts）
如果您的代码很简单，建议您编写脚本，您只需要把 JavaScript 文件放到 scripts 文件夹，在启动时就会自动载入。

插件（Packages）
如果您的代码较复杂，或是您想要发布到 NPM 上，建议您编写插件。首先，在 node_modules 文件夹中建立文件夹，文件夹名称开头必须为 hexo-，如此一来 Hexo 才会在启动时载入否则 Hexo 将会忽略它。

{% endblockquote %}

<!-- more -->

以上引用来自hexo官方文档。所以，辅助函数也是hexo插件中的一种。除了辅助函数，还有以下类型的插件：

- 控制台 (Console)
- 部署器 (Deployer)
- 过滤器 (Filter)
- 生成器 (Generator)
- 迁移器 (Migrator)
- 处理器 (Processor)
- 渲染引擎 (Renderer)
- 标签 (Tag)

## Hexo插件加载流程
首先上代码（hexo/lib/index.js）：
```js
Hexo.prototype.init = function() {
  var self = this;

  this.log.debug('Hexo version: %s', chalk.magenta(this.version));
  this.log.debug('Working directory: %s', chalk.magenta(tildify(this.base_dir)));

  // Load internal plugins
  require('../plugins/console')(this);
  require('../plugins/filter')(this);
  require('../plugins/generator')(this);
  require('../plugins/helper')(this);
  require('../plugins/processor')(this);
  require('../plugins/renderer')(this);
  require('../plugins/tag')(this);

  // Load config
  return Promise.each([
    'update_package', // Update package.json
    'load_config', // Load config
    'load_plugins' // Load external plugins & scripts
  ], function(name) {
    return require('./' + name)(self);
  }).then(function() {
    return self.execFilter('after_init', null, {context: self});
  }).then(function() {
    // Ready to go!
    self.emit('ready');
  });
};
```
从上面的代码可知，在hexo初始化时会加载插件，加载插件写在`load_plugins.js`中。它有两个主要函数

- loadModules，会去加载第三方的插件，包括hexo自带的插件
- loadScripts，会去加载脚本类的插件，包括主题`scripts`下的脚本

无论加载哪种插件，最后都是通过`index.js`中的`loadPlugin`函数来加载。

有些插件（生成器，处理器，过滤器，渲染引擎）如果存在编译错误，会导致hexo无法启动并且输出错误日志。插件加载完成之后，则根据插件类型，分别放到对应的store中（可以视为数组）。

## 插件类型选择
根据功能，选择合适的插件类型，比如[hexo-generator-github]插件，主要是生成一些与github相关的页面，比如README.md。笔者曾经不懂hexo插件开发，尝试过使用前端js，tag插件，helper插件等实现方式。但均不理想，存在各方面的问题。后来静下心里，耐心学习hexo源码之后，选择了做为generator插件，在hexo生成时，将github api缓存起来。然后再渲染。

不同的类型的插件，在使用上是不一样的。如辅助函数插件，可以在主题模板中使用；标签插件，则是在源文件中使用，在渲染时，再实时转化为html输出。

## 最简单的插件
下面，我们通过实例来写一个最简单的Hello Plugin插件。在`scripts`目录下新建一个hello.js文件，然后键入以下内容：
```js
hexo.extend.helper.register('hello_plugin', function(page){
    this.log("Hello Plugin");
    return "hello plugin";
});
```

重启后，调用此辅助函数，则会在命令窗口显示Hello Plugin，并且在前台界面上显示hello plugin。

如果插件功能较为简单，则不妨将其写为script插件。一个文件，可以写多个不同类型的插件。[hexo-generator-i18n]国际化插件早期也是写在script中的，后来为了更多的人能够使用，将其发布到NPM，才写为了package插件。

## Package插件
### npm init
使用`npm init`来新建本地包。然后根据提示，依次输入name, version, description等信息，新建完成后会生成一个`package.json`文件。
```yaml
{
  "name": "test-plugin",
  "version": "0.0.1",
  "description": "test",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "keywords": []
}
```

当然也可以手动新建`package.json`文件，并编辑，其中name和version字段是必须的。详细请参考npm文档https://docs.npmjs.com/getting-started/using-a-package.json。

### 编写插件逻辑
确定好插件要实现的功能，再根据[hexo api]编写相应的逻辑代码。下面以[hexo-generator-index2]为例。

之前，有人在群里问，如何在hexo博客首页，显示指定分类下文章。要实现这个功能，可以修改官方的hexo-generator-index插件。
```js
module.exports = function(locals) {
  var config = this.config;
  var posts = locals.posts.sort(config.index_generator.order_by);
  var paginationDir = config.pagination_dir || 'page';

  return pagination('', posts, {
    perPage: config.index_generator.per_page,
    layout: ['index', 'archive'],
    format: paginationDir + '/%d/',
    data: {
      __index: true
    }
  });
};
```
在对posts分页之前，将指定分类之外的文章过滤掉即可。如下所示：
```js
  posts = posts.filter(function(post){
    var ret = false;
    post.categories.forEach(function(item, i){
      if (item.name == '软件技术'){
        ret = true;
      }
    });
    return ret;
  });
```
但这种修改，只在当前的机器上有效。在此基础上，对此插件稍做修改，指定的分类，可以通过配置来指定。
```js
var funcs = [];
funcs['category'] = function(post, value){
    var ret = false;
    post.categories.forEach(function(item, i){
      if (item.name == value){
        ret = true;return;
      }
    });
    return ret;
};
```
除了category过滤，[hexo-generator-index2]还有tag和path过滤。

注：hexo启动时，会调用所有的generaotr插件。

### 插件发布
在发布到npm之前，先去npmjs.com注册账号并激活，然后在本地`$ npm login`登录。登录成功之后，就可以发布到npm了。
```bash
$ npm publish
```

发布成功之后，就可以将插件提交到hexo plugins列表了。

如果对插件进行了修改，刚可以通过`npm version`来更新版本（注如使用了git做scm，那么，它会自动生成一个新tag并提交）。

## 参考
hexo api: https://hexo.io/zh-cn/api/
hexo docs: https://hexo.io/zh-cn/docs/plugins.html

[hexo api]: https://hexo.io/zh-cn/api/
[hexo]: https://hexo.io
[hexo-generator-index2]: http://github.com/Jamling/hexo-generator-index2
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
