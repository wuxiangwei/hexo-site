title: Git Submodule（子模组）
date: 2016-10-09 13:53:09
categories: [Other]
tags: [Git]
toc: true
---

```
hexo-site    --- hexo-site版本库
└── themes
    └─nova --- nova版本库
```

需求：一个版本库引用其它版本库的文件。如上所示，hexo-site版本库引用nova版本库中的文件。


<!--more-->


## 基本操作

### 添加Submodule

```
cd hexo-site/
git submodule add -f https://github.com/wuxiangwei/hexo-theme-nova.git themes/nova
```
执行添加子模块命令后，hexo-site目录中将生成1个新文件**.gitmodule**，文件记录submodule的引用信息，包括在当前项目的位置以及仓库所在。

### 查看Submodule

```
git submodule status 
dabe550a44b98194546515ec78f8ec8c11b41340 themes/nova (v0.1.2-13-gdabe550)
```
可以看到每个Submodule的commit id，这commit id是固定的，每次克隆主版本库时不变，外部版本库更新时不变。

### 克隆带Submodule的版本库

克隆带Submodule的版本库，并不能自动克隆Submodule的版本库。这个特点的好处是，克隆版本库速度快，数据没有冗余。

```
git submodule init
git submodule update
```
使用上述两个命令能够克隆Submodule的版本库。


