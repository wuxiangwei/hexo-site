title: Plugins
layout: project
title2: hexo-theme-nova.userguide.plugins
---

{% blockquote hexo.io https://hexo.io/docs/plugins.html Plugins  %}
Hexo has a powerful plugin system, which makes it easy to extend functions without modifying the source code of the core module. There are two kinds of plugins in Hexo: 
{% endblockquote %}

## Script

All the [helpers](./helpers.html) under <var>scripts</var> are simple plugin.

## Plugin

Nova theme used 3rd plugins are:
- [lodash] used as util library for writing script plugin.
- [cheerio] helps to process toc.
- [hexo-renderer-sass] helps to generate css.
- [hexo-generator-github] helps to generate project pages.
- [hexo-generator-i18n] helps to generate multi-language sites.

[lodash]: https://github.com/lodash/lodash
[cheerio]: https://github.com/cheeriojs/cheerio
[hexo-renderer-sass]: https://github.com/knksmith57/hexo-renderer-sass
[hexo-generator-github]: https://github.com/Jamling/hexo-generator-github/
[hexo-generator-i18n]: https://github.com/Jamling/hexo-generator-i18n/