---
title: Developer
date: 2016-01-30 17:43:26
layout: project
title2: project.develop
---

## 简介

[Eclipse Explorer] 4.x is a millstone version. It de-couples the resources and the development language plugin under Eclipse platform. And it's possible to integrated the [Eclipse Explorer] to your RCP products or other Eclipse IDE for xxx developer. (such as Eclipse for Java IDE).

Our aim is making the most powerful explorer plugin of Eclipse, if you are insterting, invite you to join us sincerely.

## Suggestions
- Fork [Eclipse Explorer]
- Submit fragment project to [Eclipse Explorer]
- Bundle-Name suggested to explorer4xxx, xxx is the dev lang, e.g. explorer4java
- Feature Name suggested to name as Eclipse explorer for xxx, e.g. Eclipse explorer for CDT

## Fragment list
- Eclipse explorer for Java, for Eclipse standard or other Java versions
- Eclipse explorer for CDT, for Eclipse IDE for C/C++ Developers

## Dev guide
- New fragment project
Eclipse->New->Others->Plugin Development->Fragment Project

![image](/p/eclipse-explorer/develop/new_fragment_project1.png)

- Set host plugin
Set [Eclipse Explorer] as host plugin

![image](/p/eclipse-explorer/develop/new_fragment_project3.png)

- Set fragment dependencies
Add the fragment dependencies, e.g. add org.eclipse.jdt.core for explorer4java fragment.

- Extension AdapterFactory
New class such as JavaAdapterFactory.java and extend cn.ieclipse.pde.explorer.AdapterFactory. Rewrite getExplorable() abstract method and return the IExplorable object.

Sample:

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

- Configure extensions
In fragment.xml Editor->Extensions Tab, add org.eclipse.core.runtime.adapters extension.
<p> ![image](/p/eclipse-explorer/develop/new_extension.png) ![image](/p/eclipse-explorer/develop/add_adapter_factory_extension.png)</p>
Sample:

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

- Debug
Debug fragment project as Eclipse Application. "Error log" is suggested to show.

- Create feature
After debuging and testing, New->Project->Plugin Development->Feature Project to create feature.
Add the created feature to cn.ieclipse.pde.explorer.feature project Included Features tab. Finally rebuild the cn.ieclipse.pde.explorer.site project then test the feature installation.

## Publish
Make sure the fragment/feature/update site passing the test, then publish fragment to Eclipse marketplace or published as [Eclipse Explorer] fragment. Finally, fork [Eclipse Explorer] and edit the  README.md to insert the fragment and author info and pull a  request.

Published as [Eclipse Explorer] fragment is recommended, please [mail](mailto:li.jaming@gmail.com) to update the information on Eclipse Marketplace.

[Eclipse Explorer]: https://github.com/Jamling/eclipse-explorer


