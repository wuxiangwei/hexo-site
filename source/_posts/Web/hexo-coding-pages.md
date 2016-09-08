---
title: 将hexo博客部署到coding.net
category: Web
date: 2016-09-08 16:14:00
tags: [Hexo, git]
toc: true
---

[Hexo博客双线部署]的姐妹篇。详细详述如何将hexo博客部署到coding.net

## 注册coding.net
如果你原来有gitcafe账号，那么根据官方的向导，将数据从gitcafe迁移到coding。如果没有，那么就注册一个吧。

## 创建项目
登录成功后，可以创建项目，在[Hexo博客双线部署]中，我介绍的是用户pages，在这里，我介绍项目pages，所以创建的是一个普通项目。创建过程如下所示：

{% asset_img create_project.png %}
简单填下项目名称和简介就行。

***注意：那个使用README.md文件初始化项目不要勾选***

## 开启Coding Pages服务

{% asset_img open_pages.png %}

在项目管理台，点击`Pages服务`选项卡，再点击`开启服务`按钮来开启服务。服务开启之后，可以绑定域名。

{% asset_img pages_bind.png %}

建议绑定域名，比如，我已经有一个用户pages服务了，访问项目pages，好像相当于访问用户pages下的子目录。有许多资源出现404，导致页面显示不正常。

注：公开的项目Pages使用http协议

## DNS解析

先绑定域名再说，因为域名解析不是马上就生效的。登录你的域名控制台，添加域名dns解析规则，如下图所示：

{% asset_img dns.png %}

添加一条CNAME的记录解析到pages.coding.me就可以了。


## 创建项目 Pages
参考[Coding Pages 帮助]，创建项目Pages。我使用master分支来存放hexo的源文件，站点生成之后，部署到coding-pages分支。简要的步骤如下：

- 使用`git clone`命令将项目克隆到本地
- 使用`git checkout --orphan coding-pages`生成一个新的空分支
- 使用`git rm -rf .`命令删除coding-pages中已有的文件（如果没有用README.md初始化项目，可以跳过此步骤，不过建议执行一下此命令）
- 新建一个测试的`index.html`文件，符合html标准，内容随意，我是使用`vim index.html`编辑的，不熟悉vim的，可以直接使用记事本等工具来生成
- 使用`git push -u origin coding-pages`来推送到coding-pages分支

下面是我的详细操作过程

```bash
Jamling@lijiaming-PC MINGW64 /e/hexo
$ git clone git@git.coding.net:Jamling/life.git
Cloning into 'life'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (3/3), done.
Checking connectivity... done.

Jamling@lijiaming-PC MINGW64 /e/hexo
$ cd life/

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git checkout --orphan coding-pages
Switched to a new branch 'coding-pages'

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ ls
README.md

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ git rm -rf .
rm 'README.md'

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ vim index.html

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ git status
On branch coding-pages

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        index.html

nothing added to commit but untracked files present (use "git add" to track)

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ git add .
warning: LF will be replaced by CRLF in index.html.
The file will have its original line endings in your working directory.

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ git commit -m "init commit"
[coding-pages (root-commit) be74fbf] init commit
warning: LF will be replaced by CRLF in index.html.
The file will have its original line endings in your working directory.
 1 file changed, 4 insertions(+)
 create mode 100644 index.html

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$ git push -u origin coding-pages
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 286 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@git.coding.net:Jamling/life.git
 * [new branch]      coding-pages -> coding-pages
Branch coding-pages set up to track remote branch coding-pages from origin.

Jamling@lijiaming-PC MINGW64 /e/hexo/life (coding-pages)
$
```

## 部署验证

上面的步骤做完，dns缓存应该也更新好了。使用浏览器访问一下，看一下coding-pages是否正确部署了。
{% asset_img url1.png %}
{% asset_img url2.png %}

## 安装hexo
- 使用`git checkout master`将分支切到master分支
- 使用`hexo init`来初始化博客，注意，执行过程中，会将.git仓库删除掉，后面需要重新初始化git
- 使用`git init`重新初始化git仓库
- 使用`git remote add`重新设置git仓库远程路径
- 使用`git pull`将远程内容与本地内容合并

具体的操作步骤如下：

```bash
Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ hexo init
INFO  Cloning hexo-starter to E:\hexo\life
fatal: destination path 'E:\hexo\life' already exists and is not an empty directory.
WARN  git clone failed. Copying data instead
INFO  Install dependencies
// 此处忽略hexo的安装输出日志
INFO  Start blogging with Hexo!

Jamling@lijiaming-PC MINGW64 /e/hexo/life
$ git status
fatal: Not a git repository (or any of the parent directories): .git #.git被hexo干掉了 :(

Jamling@lijiaming-PC MINGW64 /e/hexo/life
$ rm README.md #一定要删除，不然下面的git pull会执行不了

Jamling@lijiaming-PC MINGW64 /e/hexo/life
$ git remote add origin git@git.coding.net:Jamling/life.git
fatal: Not a git repository (or any of the parent directories): .git

Jamling@lijiaming-PC MINGW64 /e/hexo/life
$ git init
Initialized empty Git repository in E:/hexo/life/.git/ #木有事，我重新初始化git仓库

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git remote add origin git@git.coding.net:Jamling/life.git #我再重新设置远程仓库路径

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git pull origin master
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From git.coding.net:Jamling/life
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> origin/master

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        .npmignore
        _config.yml
        node_modules/
        package.json
        scaffolds/
        source/
        themes/

nothing added to commit but untracked files present (use "git add" to track)

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ vim .gitignore

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        .gitignore
        .npmignore
        _config.yml
        package.json
        scaffolds/
        source/
        themes/

nothing added to commit but untracked files present (use "git add" to track)

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$
```

是否先初始化hexo博客，再checkout coding项目，是不是会简单一些呢？我没有试过，试过的请告诉我一下哈。

建议将themes目录也加入.gitignore文件。


## Hexo设置

先安装hexo-deployer-git插件，然后配置

```yaml _config.yml
deploy:
  type: git
  repo: 
    coding: git@git.coding.net:Jamling/life,coding-pages
```

repo可以写多个，格式为git仓库地址+英文逗号+分支名称，以实现多线部署。

## 编写博客
这就不多说了，装插件，装主题，写内容，这些属于hexo的基本操作。不懂的百度。本地测试通过之后，可以使用`hexo g -d`部署到coding。

## 提交hexo源文件
博客测试完毕之后，就可以将博客源文件提交到master分支了，这样就算换了电脑，可以从远程仓库获取源代码，又可以愉快地写博客了。

```bash
Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git add .
// 此处省略文件列表

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git commit -m "add sources"

//此处省略文件列表

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ git push origin master
Counting objects: 73, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (70/70), done.
Writing objects: 100% (73/73), 95.92 KiB | 0 bytes/s, done.
Total 73 (delta 0), reused 0 (delta 0)
To git@git.coding.net:Jamling/life.git
   e40018e..0efa99d  master -> master

Jamling@lijiaming-PC MINGW64 /e/hexo/life (master)
$ 

```

## 参考
Coding Pages 帮助: https://coding.net/help/doc/pages/index.html
Hexo博客双线部署: /2016/08/29/Web/Hexo-deploy-lines/

[Hexo]: https://hexo.io
[Nova]: http://github.com/Jamling/hexo-theme-nova
[Coding Pages 帮助]: https://coding.net/help/doc/pages/index.html
[Hexo博客双线部署]: /2016/08/29/Web/Hexo-deploy-lines/