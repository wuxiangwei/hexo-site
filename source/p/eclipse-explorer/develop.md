---
title: Developer
date: 2016-01-30 17:43:26
layout: project
title2: project.develop
---

## 简介

[Eclipse Explorer] 4.x版本是一个重构版本。它对平台资源与特定语言版本下的eclipse资源进行了解耦。这样，方便开发者将[Eclipse Explorer]集成到自己的RCP产品中，或者开发支持特定语言eclipse版本（如Eclipse for Java IDE）的explorer插件。

Eclipse Explorer的目标是打造最强大的explorer插件！如果您对此感兴趣，诚邀您和我们一起共同改进此项目。

## 开发规范
- Fragment工程须提交到[Eclipse Explorer]
- Bundle-Name 建议使用explorer4xxx，xxx为开发语言，如explorer4java
- Feature Name 建议使用Eclipse explorer for xxx，如Eclipse explorer for CDT

## Fragment列表
- Eclipse explorer for Java, Eclipse 标准版及其它Java语言版本下的explorer插件
- Eclipse explorer for CDT, Eclipse IDE for C/C++ Developers下的explorer插件

## 开发步骤
- 新建fragment工程
在Eclipse中，新建工程，选择Plugin Development目录下的Fragment Project

![image](/p/eclipse-explorer/develop/new_fragment_project1.png)

- 设置宿主插件
添加[Eclipse Explorer]做为宿主插件

![image](/p/eclipse-explorer/develop/new_fragment_project3.png)

- 添加fragment依赖
如Java版本fragment，添加org.eclipse.jdt.core依赖

- 继承AdapterFactory
新建一个类，如JavaAdapterFactory.java并继承Eclipse Explorer插件中的cn.ieclipse.pde.explorer.AdapterFactory类
重写getExplorable()方法，返回可以浏览的资源对象
示例：
```java
    @Override
    public IExplorable getExplorable(Object obj) {
        String path = null;
        if (obj instanceof IJavaElement) {
            // java project.
            if (obj instanceof IJavaProject) {
                path = ((IJavaProject) obj).getProject().getLocation()
                        .toOSString();
                return new Explorer(path, null);
            }
            // jar resource is null
            else if (obj instanceof JarPackageFragmentRoot) {
                String file = ((IPackageFragmentRoot) obj).getPath()
                        .toOSString();
                // get folder
                return new Explorer(null, file);
            }
            else if (obj instanceof IPackageFragmentRoot) {
                // src folder
                IPackageFragmentRoot src = ((IPackageFragmentRoot) obj);
                IProject p = src.getJavaProject().getProject();
                String prjPath = p.getLocation().toOSString();
                path = new File(prjPath, src.getElementName())
                        .getAbsolutePath();
                return new Explorer(path, null);
                // System.out.println(path);
            }
            else if (obj instanceof IPackageFragment) {// other : package
                IResource resource = ((IPackageFragment) obj).getResource();
                path = resource.getLocation().toOSString();
                return new Explorer(path, null);
            }
            else {// member:filed:
                IResource resource = ((IJavaElement) obj).getResource();
                String file = resource.getLocation().toOSString();
                // get folder
                return new Explorer(null, file);
            }
        }
        return null;
    }
```

- 配置fragment扩展
在fragment.xml，Extensions选项卡，添加org.eclipse.core.runtime.adapters扩展点
<p> ![image](/p/eclipse-explorer/develop/new_extension.png) ![image](/p/eclipse-explorer/develop/add_adapter_factory_extension.png)</p>
示例：
```xml
   <extension
         point="org.eclipse.core.runtime.adapters">
      <factory
            adaptableType="org.eclipse.jdt.core.IJavaElement"
            class="cn.ieclipse.pde.explorer.java.JavaAdapterFactory">
         <adapter
               type="cn.ieclipse.pde.explorer.IExplorable">
         </adapter>
      </factory>
   </extension>
```



- 调试
对fragment工程Run As->Eclipse Application进行调试，建议打开"Error log"视图并查看日志。

- 创建feature
调试并测试完毕之后，在Eclipse中，新建工程，选择Plugin Development目录下的Feature Project，为fragment工程创建feature。
Feature 创建完毕之后，请在cn.ieclipse.pde.explorer.feature工程中Included Features选项卡添加创建的feature，然后对cn.ieclipse.pde.explorer.site重新Build All。Build完之后，对Feature做安装测试并验证

## 发布
在发布之前，应当充分测试fragment/feature/update site，测试通过后，可以选择将此fragment发布到Eclipse marketplace或作为[Eclipse Explorer]的补丁发布。发布成功后，请在[Eclipse Explorer]项目
测试及发布成功后，可以选择在fork [Eclipse Explorer] README.md中添加您的fragment插件及作者信息并提交Pull request.

如果作为[Eclipse Explorer]的补丁发布（推荐使用此方式），请[mail](mailto:li.jaming@gmail.com)管理员在Eclipse Marketplace上更新fragment。

[Eclipse Explorer]: https://github.com/Jamling/eclipse-explorer


