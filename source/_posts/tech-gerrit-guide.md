---
title: Gerrit&Git使用指南
date: 2016-05-14 14:46:29
category: [软件技术, 其它]
tags: [git]
toc: true
---
上篇介绍了Gerrit的安装与配置，本篇介绍的是Gerrit的使用

<!-- more -->

## 生成ssh key
Windows下，打开gitbash等终端工具输入ssh-keygen生成公钥和私钥
Linux下直接在终端命令中输入ssh-keygen
```shell
$ssh-keygen
```

{% asset_img image001.png %}

## 登录gerrit

在浏览器中输入gerrit地址：http://192.168.135.48/gerrit/
然后在弹出的身份验证对话框中输入账号及密码
**注：注意用户名大小写**

首次登录成功后，进入注册页面，如下所示：

{% asset_img image003.png %}

此界面可以添加ssh（亦可后续添加）

输入Full Name，并点击Register New Email注册邮件地址。Gerrit会向输入的邮箱地址发送一封注册确认邮件。然后登录自己的邮箱，查收文件，点击验证链接，完成验证。验证通过后，将成功注册用户，就可以Review Code / Upload Code啦。

{% asset_img image005.png %}
 
### 设置full-name和email
点击Settings -> Contact Information更新姓名及邮箱地址。

{% asset_img image007.png %}

当email 不为空时，才算是正式的注册用户。才具备git 操作权限。

这里的username和preferred email必须和git config配置的完全一致，才能upload代码到gerrit

### 设置ssh public key
点击settings -> SSH Public Keys链接，将生成的ssh 公钥添加到gerrit

{% asset_img image009.png %}

### 测试ssh连接
命令格式：`ssh –p port your_user_name@gerrit_host`
```shell
$ ssh –p 29418 lijiaming@192.168.135.48
```
{% asset_img image011.png %}

连接成功之后，就可以从gerrit上检出代码了

## 从gerrit检出代码
登录gerrit，点击Projects选项卡，在project list中点击要检出的工程
进入工程详情界面

{% asset_img image013.png %}

点击ssh选项卡，复制代码检出命令
回到git bash终端，粘贴或手动输入git clone命令

{% asset_img image015.png %}

**注：这里使用的是ssh协议哦**

## git本地设置
### 设置用户
用户名登录gerrit的用户名
email地址为gerrit上注册的邮箱地址
必须完全与gerrit上配置的一致，否则将不能push代码

{% asset_img image017.png %}

### 下载commit模板
先cd到仓库目录，然后再下载commit-msg
```shell
$ scp -p -P 29418 yourname@review.example.com:bin/gerrit-cherry-pick ~/bin/

$ scp -p -P 29418 yourname@host:hooks/commit-msg .git/hooks/

$ scp -p -P 29418 lijiaming@192.168.135.48:hooks/commit-msg .git/hooks/
```
{% asset_img image019.png %}

### 设置默认push
编辑./git/config文件，在[remote "origin"]下添加
`push = +refs/heads/*:refs/for/*`
也可以通过`git config origin.remote.push= xxx`来设置哦

这样，push代码时，可以直接使用git push origin branch名称将代码提交到gerrit

如果不设置，需要使用git push origin HEAD:refs/for/master来提交到远程master分支

### 邮件提醒
当gerrit上有事件发生时，会向相关的用户发送邮件，建议使用邮件客户端打开提醒功能，并设置过滤器，如来自gerrit@your_company.com的邮件都存放在特定的文件夹下

### 提交代码
#### 查看状态
```shell
$ git status
```
查看状态比如，已经加入git管控的文件（绿色），修改的文件（红色），冲突的文件（both modified 红色），新添加的文件（红色）

#### 添加文件
```shell
$ git status add
```
添加文件，可以添加目录，文件，也可以使用git add .添加所有文件
建议在git add 之前先git status一下

#### 提交代码
```shell
$ git commit –m “[add|mod|del|…] 
```
提交日志内容，尽量精准描述本次提交

如果忘了带-m参数，可以进入vim/vi界面，按i进入编辑界面，然后输入commit信息，再按esc退出编辑，输入:wq（vim指令， vi指令自行百度）保存并退出

#### 推送代码
```bash
$ git push origin master
```
将当前代码push到远程master分支
如果没有设置默认push，则需使用完整命令
```bash
$ git push origin HEAD:refs/for/master
```
#### 拉取代码
```bash
$ git pull --rebase origin master
```
从远程分支master上拉取代码，如果本地有修改，会导致拉取失败，需要先暂存本地修改的代码

此命令相当于svn的svn update

--rebase的作用是精简commit信息，减少不必要的merge

#### 暂存代码
```bash
$ git stash
```
将本地修改的代码暂存起来
可以添加-u参数，将添加的文件一并加入暂存区
#### 从暂存区恢复
```bash
$ git stash apply 
```
将暂时区的代码恢复到当前分支，后面可以跟stash{position}，将第position次的暂存恢复。
```
$ git stash pop
```
同git stash apply，并且从stash中删除
```
$ git stash list
```
列出暂时区列表

## Gerrit工作流
### Upload代码
请见上一节提交代码

### Review代码
当upload成功之后，就可以在gerrit上看到提交了
{% asset_img image021.png %}

### 添加Reviewer
点击提交日志进去，添加reviewer

{% asset_img image023.png %}

注：输入reviewer的邮箱地址会自动联想，点击点击Add Reviewer确认添加

### 评审代码
 
点击文件查看修改

{% asset_img image025.png %} 

可以双击修改后的代码位置写入评审信息

提交或评审

{% asset_img image027.png %}

点击Review，选择Review结果

{% asset_img image029.png %}

如果评审没有问题，则选择+2或+1，如果代码不正确或存在问题，则选择-1或-2。

最后选择评审动作，是否提交到git

注1：提交到git的前提条件是：review的分数总和必须大于或等于2，并且单次review分数没有-2

注2：如果代码不存在冲突，本次提交则会顺利地merge到git仓库

### 废弃提交

如果代码评审不通过，也可以点击Abandon Change，直接废弃掉本次提交

如果submit存在冲突，也可以先废弃掉提交，让代码提交者解决冲突后，再次提交。

## git 进阶操作
### 切换协议
如果clone时，使用的是https，则每次提交都需要输入用户名与密码，推荐使用ssh协议，可以使用以下命令将https转为ssh协议
```bash
git remote set-url origin git@github.com:someaccount/someproject.git
```
### 导入仓库
```bash
git init
git remote add origin git@github.com:Jamling/test.git
git push -u origin master
```

### 提交代码到多个分支
如果代码需要提交到多个分支，需要使用git cherry-pick功能。以下是一个示例

PS：master为主干分支，dev为开发版本分支。
假设，我们当前在主干分支master，则：
1，master分支上git add , git commit，并且记录下commit id
2，git pull --rebase origin master // 确保master分支是最新状态
3，git push origin master
4，git checkout dev切换到dev分支
5，git cherry-pick 后面加上master分支下的刚刚提交的commit id
6，git pull --rebase origin dev // 确保dev分支是最新的
7，git push origin dev

### 追加修改
当push代码之后，review不通过或者想继续修改，可以继续编辑源代码，然后再通过git commit –amend来追加修改
```bash
$ git add test.txt
$ git commit –m “add test”
$ git push origin master
$ git add test2.txt
$ git commit --amend
$ git push origin master
```

### 版本回退
git reset可以实现版本回退
```bash
git reset --soft HEAD~
```
添加--soft选项，则本地修改仍然存在，commit信息将回退
HEAD~：表示将HEAD版本向前退一个版本~~表示两个版本，亦可以用HEAD~2表示

### 提交tag
```bash
git tag -am “commit message” tagname
git push origin tagname:refs/heads/tagname
git push --tags
```

## Gerrit 常见问题
### 本地仓库与远程仓库不一致
 `Your branch is ahead of 'origin/master' by 1 commits.`

 使用git status后，提示Your branch is ahead/behind of 'origin/master' by x commits. 表示本地仓库与远程仓库不同步，本地仓库比远程仓库提交x次提交。
 出现的原因是有以下两种：
  1. 本地提交push到gerrit，但是gerrit没有merge到远程仓库。
  2. gerrit上已经merge过了，但是本地没有拉取最新的远程仓库。

 解决办法：
 
 先查看gerrit merge状态。然后再通过拉取代码获取最新的分支代码。如果提交的commit是你自己的，可以简单使用git pull，如果不是，强烈推荐`git pull --rebase origin master`来拉取分支。

### Push代码被拒绝 
 - `[remote rejected] HEAD -> refs/for/master (missing Change-Id in commit messag`
 push代码时，出现以下错误：
 
 {% asset_img image033.png %}
 
 解决办法
    1.	先确认是否有从远程下载commit-msg模板，如果没有，参考下载commit模板一节，下载commit-msg模板
    2.	使用git status查看状态，发现ahead of 'origin/master'的数目不对。则使用git log查看提交记录，发现提交记录中有Merge branch 'master' of ssh://…，则可以确定是因为pull代码时，出现了分支冲突，git自动合并并提交合并commit。具体的解决办法之一：
        a)	git reset --soft HEAD~将自动merge后的commit全部重置，并且保存到暂存区
        b)	git reset --hard HEAD~将自动merge的commit还原，再pull --rebase拉取最新的分支代码。并解决冲突。
        c)	从暂存区恢复代码，并且重新提交即可
 - `warning: push.default is unset`
 是由版本兼容性导致的，低版本的git push如果不指定分支名，就会全部推送，而新版只会推送当前分支。
 解决的办法也很简单，我们只需要明确指定应该推送方式即可
    1. 全部推送
    git config --global push.default matching
 
    2. 部分推送
    git config --global push.default simple


