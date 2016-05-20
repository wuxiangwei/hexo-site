---
title: Developer
date: 2016-01-30 17:43:26
layout: project
title2: project.develop
---

## 简介

Eclipse Explorer 4.x版本是一个重构版本。它对平台资源与特定语言版本下的eclipse资源进行了解耦。这样，方便开发者将Eclipse Explorer集成到自己的RCP产品中，或者开发支持特定eclipse版本的explorer插件。

### 主插件
Eclipse Explorer

### 插件fragment
- Eclipse explorer for Java, Eclipse 标准版及其它Java语言版本下的explorer插件

## 插件fragment开发
- 新建fragment工程
在Eclipse中，新建工程，选择Plugin Development目录下的Fragment Project

- 设置宿主插件
添加Eclipse Explorer (4.x)做为宿主插件

- 添加依赖
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

- 测试及发布
测试及发布成功后，可以选择在[Eclipse Explorer](https://github.com/Jamling/eclipse-explorer)添加您的fragment插件


