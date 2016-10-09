title: Git 子模块
date: 2016-10-09 13:53:09
categories: [Other]
tags: [Git]
toc: true
---


<!--more-->


## 工程结构

``` shell
root@bs-dev:~/repo# tree -L 2 hexo-site
hexo-site               --- hexo-site主工程
├── _config.yml
├── db.json
├── package.json
├── README.md
├── scaffolds
│   ├── draft.md
│   ├── page.md
│   ├── post.md
│   └── project.md
├── source
│   ├── about
│   ├── categories
│   ├── _data
│   ├── demo
│   ├── donate
│   ├── en
│   ├── fav
│   ├── p
│   ├── _posts
│   └── robots.txt
└── themes
    └── nova      --- nova子工程
```


## 添加Submodule

``` shell
cd hexo-site/
git submodule add -f https://github.com/wuxiangwei/hexo-theme-nova.git themes/nova
```
执行添加子模块命令后，hexo-site目录中将生成1个新文件**.gitmodule**，文件记录submodule的引用信息，包括在当前项目的位置以及仓库所在。

```
[submodule "themes/nova"]
	path = themes/nova
	url = https://github.com/wuxiangwei/hexo-theme-nova.git
```



