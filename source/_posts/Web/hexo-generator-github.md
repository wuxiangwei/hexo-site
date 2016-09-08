---
title: Hexo github页面生成插件
date: 2016-07-21 20:30:30
category: [Web]
tags: [Hexo, Node.js]
toc: true
---

## 痛点
从2013年开始，本人开始活跃于github，以前托管于sourceforge、svn spot和oschina的开源项目，陆续迁移到了github。此前，我一直使用的是wiki系统来维护相关开源项目的文档及下载等。那时，Markdown还没有现在这么流行，在sourceforge等网站，我几乎不放文档。但迁移到github后，将之前的wiki页面渐渐转成了Markdown页面。在迁移到github之后，我比较重视文档，源代码的修改，有可能需要更新文档。此前wiki网站因为访问太慢，空间也不是特别稳定，在今年终于决定放弃维护，转而使用github pages功能来托管这些项目文档。

github pages是一个静态空间，不支持php等动态语言。虽然如此，不过也有逼格高的玩法。当初曾想过使用jekyll来建站，不过因为工作太忙，没有时间学习。后来无意之中接触了hexo，hexo可以完全兼容github markdown，觉得hexo更适合我一些。于是试用了若干plugin和theme，对其blog功能还是非常满意，但是如果要展现项目文档，还是显得捉襟见肘。我不可能每次更新github后，都手动复制一份相关的文档再更新到博客站点。如何自动抓取github相关的页面等内容成了一个非常大的痛点。

<!-- more -->

## 需求
这其实是一个hexo页面与github页面同步的问题。我期望的是，在github项目变更之后，比如README变更了，releases添加了，那么对应的hexo页面可以自动更新，而无需人工同步。

## 尝试

在尝试若干主题+插件都无法满足我的需求之后，我决定自己开发一个符合我需求的主题。主题的开发还是蛮曲折的，对于项目页这块，我尝试了不少的方案

- 前端JS实现，在html页面使用ajax请求github api，然后填充内容。本来github访问就慢，多个ajax请求就更慢了，而且github还有limit访问限制，未加token的访问，一天也就60次。访问60次之后，就无法再访问了。这肯定不行。

- 同步实现，在生成或访问时，使用同步请求将github内容同步输出为html，node.js是异步的，所以特地找了几个同步网络请求请求库，比如ajax同步请求，urllib-sync等。最后，使用urllib-sync终于实现了同步请求，但是它仍然有缺点，一是生成时，仍然会消耗github api limit，二是生成速度太慢，三是不稳定，经常timeout。四是如果生成过程中，有一次同步请求失败，必须重新全部生成。后面我添加了项目页面越来越多，根本就用不下去了。

## 终级方案
在尝试过多个方案并失败之后，终于痛定思痛，还是要写一个插件，然后仔细研究了hexo源码，发现生成器插件比较适合。它在`hexo server`和`hexo generate`时，生成器都会被调用，那么我只需写一个生成器，用于抓取github api，然后缓存起来，渲染时，直接从缓存中取github response渲染。

说干就干，在生成器中首先对站点的所有文章查找其是否带`gh` front-matter，如果存在，则属于项目页，判断缓存是否存在，存在则跳过生成
```js
  pages.forEach(function(item) {
    if (item.gh) {
      var path = pathFn.join(cacheDir, item.path);
      if (!replace && fs.existsSync(path)) {
        if (github.debug) _self.log.debug(path + " exists skip generate");
        return;
      }
      _self.log.info("generating github " + path);
      var dir = pathFn.dirname(path);
      mkdirsSync(dir);
```

生成具体规则如下：
```js
      var gh = gh_opt.call(_self, item);
      if (gh.type === 'get_contents') {
        github.repos.getContent({
          user : gh.user,
          repo : gh.repo,
          ref : gh.ref ? gh.ref : 'master',
          path : gh.path ? gh.path : 'README.md'
        }, function(err, res) {
          // var url = util.format('repos/%s/%s/contents/%s', user, name, path);
          if (res && res.content) {
            var md = new Buffer(res.content, res.encoding).toString();
            // var md_func = hs['markdown']; // Why generator can't call helper
            // function?
            fs.writeFileSync(path, md);
          }
          else {
            _self.log.w("generate github " + path + " failed");
          }
        });
      }
      else if (gh.type === 'get_releases') {
      ...
      }
      ...
```

根据不同的`gh.type`来调用不同的github api，在这里，使用了node.js github第三方库来简化github操作。比如获取内容，将github上的markdown文件的内容写入到缓存中。所以此种方式，只要缓存存在，则不用重复请求github，不必担心github api limit限制，而且缓存是github原始数据，怎么展示，完全取决于主题。不像某些插件，生成的结果包含html，不好修改。

在主题模板中，使用辅助函数来操作github。比如下面的`gh_contents`，将缓存中的markdown内容转化为html。

```js
function gh_contents(options) {
  var o = options || {}
  var user = o.hasOwnProperty('user') ? o.user : this.config.github.user;
  var name = o.hasOwnProperty('repo') ? o.repo : null;
  var path = o.hasOwnProperty('path') ? o.path : 'README.md';
  var ref = o.hasOwnProperty('ref') ? o.ref : 'master';

  if (name === undefined) {
    return '';
  }

  var cache = (this.gh_read_cache(this.page));
  if (cache) {
    return this.markdown(cache.toString());
  }
```
转化后的html可以做为page.content，直接显示。

```htmlbars
  {%- if gh.type === 'get_contents' %} 
    {% set page.content = gh_contents(gh) %}
    {{ partial('project/contents', {} )}}
```
```htmlbars
<div class="container-fluid">
<div class="row">
  <div class="{{theme.layout.p.sidebar}}" role="navigation">
    {{ partial('sidebar', {}) }}
  </div>
  <div class="{{theme.layout.p.main}}">
    {{ partial('../page/article') }}
  </div>
  <!-- aside -->
  <div class="{{theme.layout.p.toc}}">
  {%- if page_toc() %}
  {{ partial('../partial/toc', {style: 'col m4 l3'}) }}
  {%- endif %}
  </div>
</div>
</div>
```

如上所示，将github上的文件内容直接输出到hexo页面。

## 优化
为保证新建一个github相关的页面而不用重新启动hexo server，仍然需要保留github同步请求，当缓存不存在时，则执行同步请求api，并且将结果保存到缓存中。
```js
  var url = util.format('repos/%s/%s/contents/%s', user, name, path);
  console.log("no cache, and try load from : " + url);
  var repo = gh.reqSync(url, {
    data : {
      'ref' : ref
    }
  });
  if (repo && repo.content) {
    var md = new Buffer(repo.content, repo.encoding).toString();
    var content = this.markdown(md);
    this.gh_write_cache(this.gh_cache_dir(this.page, md));
    return content;
  }
```

为加快生成速度，本插件还提供了控制台命令方式来生成。
```bash
$ hexo github [-r --replace]
```

## 总结
使用[hexo-generator-github]可以将github的内容抓取到本地，配合主题来渲染输出。这样就不必手动修改hexo的页面了。比较方便。但是也有不足的地方，比如，为保证github上的markdown在hexo站点正常显示，要求markdown中的链接和图片等外部资源需要使用绝对路径。另外，如果要更新hexo页面，需要将github缓存删除或者通过控制台命令`$ hexo github -r`，这样才会重新生成hexo页面。


## 参考
hexo api: https://hexo.io/zh-cn/api/
hexo-generator-github: http://github.com/Jamling/hexo-generator-github

[hexo api]: https://hexo.io/zh-cn/api/
[hexo]: https://hexo.io
[hexo-generator-index2]: http://github.com/Jamling/hexo-generator-index2
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
