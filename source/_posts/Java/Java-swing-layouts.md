---
title: Swing 布局管理器
date: 2010-04-02 21:00:00
category: [Java]
tags: [Java, Swing]
toc: true
---
## Null Layout
Null layout也称绝对布局管理器，如果一个容器使用绝对布局的话，那么其中的组件要调用setBounds()方法以确定在哪个位置显示组件，否则组件将不显示。 如果不用WindowsBuilder之类的界面开发插件，使用绝对定位将是一件痛苦的事。 在界面较复杂的情况下，一般不会使用绝对布局
<!-- more -->

## FlowLayout
使用此布局管理器将容器内的组件按从左到右或从右到左排列，如果剩余空间小于组件，那么组件将在新行显示。

## BorderLayout
是某些容器组件的默认布局管理器，它将容器分为NORTH, SOUTH,CENTER，WEST，EAST五个区域，每个区域最多只能有一个组件，所以它也只适用于容器内组件较少（不大于5个）的布局管理。 使用方式：
Container.add（component, BorderLayout. SOUTH）;
如果第二个参数未指定，那么默认在BorderLayout. CENTER区域显示。
如果对同一个区域添加了多个组件，那么只显示最后添加的组件。

## GridLayout
网格布局管理器，它将容器划分为指定行*列个单元格，按组件add的顺序，依次将组件放入单元格中，可以像表格一样指定其单元格之间的水平与垂直间距，但是，它不可以跨行与跨列。 所以此布局管理器只适用于容器内组件排列呈类表格方式的容器布局。


## GridBagLayout
GridLayout不可以跨行与跨列，但GridBagLayout可以，个人认为GridBagLayout是基于GridLayout的，因为它的原理也是将容器区域分为若干个单元格的。

不过功能远比GridLayout强大，不仅可以跨行与跨列，还可以指定在容器大小变更时，组件是否向x轴与y轴方向延伸，以及延伸率。

每个由 GridBagLayout 管理的组件都与 GridBagConstraints 的实例相关联
Constraints 对象指定组件的显示区域在网格中的具体放置位置，以及组件在其显示区域中的放置方式。 除了 Constraints 对象之外，GridBagLayout 还考虑每个组件的最小大小和首选大小，以确定组件的大小。

下面对GridBagConstraints的几个属性做一个简要说明，如要了解属性的原生说明请参考sun官方资料

 - gridx, gridy  ：指定组件在容器单元格内的行索引与列索引，如最左上的那个单元格式，其gridx为0，gridy为0。

 - gridwidth, gridheight ：指定单元格的跨行与跨列数

 - fill：指定填充方向，可以向水平，垂直或水平+垂直方向充满整个容器。

 - ipadx, ipady：指定组件的内部填充，相当于单元格边距，即给组件的最小宽度或高度添加多大的空间。 此属性在我实践中未能参透其中工作方式（有时填充，有时不填充）

 - insets：指定组件的外部填充，相当于单元格间距。

 - Anchor：当组件的大小小于可用显示区域时使用，指定组件在显示区域中的位置。 请见下图： 

<pre>

   -------------------------------------------------
   |FIRST_LINE_START   PAGE_START     FIRST_LINE_END|
   |                                                |
   |                                                |
   |LINE_START           CENTER             LINE_END|
   |                                                |
   |                                                |
   |LAST_LINE_START     PAGE_END       LAST_LINE_END|
   -------------------------------------------------

</pre>

 - weightx, weighty ：指定容器大小变动时，向x或y方向的伸缩率。

关于更多GridBagLayout的信息请参考JDK API或相关资料。

## BoxLayout
允许垂直或水平布置多个组件的布局管理器。 
它与Box联合工作，Box是一个使用了BoxLayout的轻量级组件。 Box的思想是将容器内的组件当做一个Box（盒子），在Box与Box之间可以创建一些不可见的区域，分为：
- Glue: 相当于胶水，粘住了两个box，它会自动沿垂直或水平方向填充两个box之间的不可见区域
- Strut: 指定高度（宽度）的垂直（水平）间距的Glue
RigidArea: 同时指定高度与宽度的Strut
下面请看一个示例，实现的效果与GridBagLayout中示例的效果一样

## SpringLayout
SpringLayout是一种较特殊的布局管理器，它通过定义容器及容器内组件的约束来实现布局。 它与Spring, SpringLayout. Constraints联合使用。 

在此之前先说一下Spring
Spring好似一个弹簧，它可以伸长到maximum，也可以收缩到minimun，在正常情况下它的长度是prefferenceSize，在容器大小变动时，它根据前面的三个值根据一系列规则计算出具体的value。 
Spring是一个抽象类，它提供max,sum静态函数

SpringLayout.Constraints，将管理组件大小和位置更改方式的约束存储在 SpringLayout 控制的容器中，它有x、y、width 和 height 属性，因而它类似于一个 Rectangle。 但是，在 Constraints 对象中，这些属性具有的是 Spring 值，而不是整数。 此外，可以使用 constraint 属性按四个边（东、南、西、北）操作一个 Constraints 对象。
组件与组件的约束是通过边来定义的，如一个textfield的左边距label的右边多少距离。 下面给出边的计算公式：
WEST = x
NORTH = y
EAST = x + width
SOUTH = y + height
下面给出一个官方的示例：
容器容器pane使用Spring布局管理器，pane下有一个label及一个textfield。
   
## 总结
Swing的布局管理器感觉没有SWT好使，在现实的界面开发中，需要根据实际情况灵活使用多种布局管理器，不像SWT使用一个GridLayout差不多就可以了。 鉴于个人理解的还不够深刻，更多的资料需要去看sun官网布局管理器的说明：

