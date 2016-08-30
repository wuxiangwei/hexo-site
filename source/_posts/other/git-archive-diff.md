---
title: 使用git打包修改的文件
date: 2016-09-01 11:42:28
category: [软件技术, 奇淫巧技]
tags: git
---

使用git archive可以将传入的文件列表打包为一个zip档案。对于一些大系统，如果只是修复bug，可以做到热替换的话（比如php，js等解释型语言），可以使用此命令将修改的文件添加到zip档案，以提交局方升级。

<!-- more -->
将整个仓库打包

```
git archive -o repo.zip HEAD
```

查看自前一次提交修改的文件
```
git diff --name-only HEAD^
```

如果想查看前n次提交的修改，可以将HEAD^改为HEAD~n即可。

综合运用

```bash
git archive -o update.zip HEAD $(git diff --name-only HEAD^)
```

注：git diff显示的文件需提交到仓库才可以。比如新增加了一个文件，要先commit到仓库，不然会出现错误（git diff 加--cached是否可以解决此错误呢？）。


