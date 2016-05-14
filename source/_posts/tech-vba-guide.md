---
title: Excel VBA基础实例教程
date: 2016-05-13 16:32:00
category: [软件技术]
tags:
toc: true
---
<script src="http://cdn.bootcss.com/highlight.js/9.1.0/languages/vbscript.min.js" ></script>
# VBA简介
## VBA
VBA (Visual Basic for Application)，是一种应用程序自动化语言，所谓的应用程序自动化，就是通过程序或者脚本（VBS）让应用程序（Word, Excel）自动化完成一些工作（自动填充内容，自动计算等）。

<!-- more -->

## 宏与VBA
宏其实是Excel自动生成的VBA代码。
可以通过菜单栏工具→宏→录制新宏，然后点击工具栏中字体颜色设置颜色为红色，设置对齐方式为居中对齐，再点击停止宏。
再选择其它单元格，点击菜单栏工具→宏→选择刚才录制的宏。这样所选择的单元格都变成红色字体，居中对齐了。

所以，通过宏，相信大家对VBA有了更深入的了解了吧？没错就是自动化操作。让原本相对相对复杂的操作通过VBA包装起来，再让电脑自动去完成这些操作。

有人要问了，你刚才讲到的例子，可以用格式刷完成，或者多选单元格之后再一起设置也可以呀。确实可以，不过上面宏示例，只是一个非常简单的例子。再复杂一点的呢？比如一份Excel中有一个Sheet，是比较隐私的，需要输入密码才能查看，或者完成一些Excel公式不支持的复杂运算。这时候VBA的强大之处就体现出来啦。

是不是学好了VBA之后，就不用再使用宏了呢？也不是，通过查看录制的宏，可以看到好多VBA操作Excel的例子，比如使用哪些对象，执行什么操作啦，一目了然。如果对Excel内建对象不是很熟的话，查看宏代码不失为一个学习VBA的好办法。

# 教程目的
本文档的目的在于让读者对VBA有一个初步的概念，通过练习编写一个个人所得税计算器来一步一步学习VBA。

# 准备工作
首先，你需要安装Office Excel，然后新建一个新建一个Excel文档，重命名为个人所得税计算器。

**注：本教程使用的Office为Office 2003简体中文精简版。如果遇到与本文档不符合的地方，请自行解决。**

其次，通过基本的Excel操作，将表格设计成个人所得税计算器，如下图所示：
{% asset_img image001.png %}

以上基本的Excel操作，相信是个用电脑工作的人，应该都会的。
下面，通过学习VBA，来开启Excel的高级应用吧。

# VBA for Excel

## VBA编辑器简介

### 打开VBA编辑器

菜单栏：视图→工具栏→Visual Basic，打开VB工具栏（后面的Visual Basic，一律简称为VB）
{% asset_img image003.png %}

点击VB编辑器图标，打开VB编辑器
{% asset_img image005.png %}

打开后的界面如下
{% asset_img image007.jpg %}

下面简单介绍一下VB编辑器各个部分
### 工程资源管理器
管理工程资源，如窗体，模块，类模块，还可以导入，导出窗体，模块等，在这里，重点提一下模块与类模块，个人理解，类模块就是单个类，主要用于面向对象的类的定义，而模块主要用于流程的控制。这仅是个人的理解，不明白的人，可以自行百度VBA类模块等关键词。

### 属性窗口
显示当前所选对象的属性，比如上图中，我所选的是第一个sheet（2012个人所得税计算器），属性窗口中的Name属性即为2012个人所得税计算器，当然，属性除了给你看之外，你还可以编辑属性值哟，不信，你试试将Name属性值变更为“个体工商经营所得税计算器”试试。

### 代码窗口
个人理解，这里就是编辑器啦，只不过，可以切换成代码模式（代码窗口）和可视化设计模式（对象窗口）两种模式，你可以在此编辑程序的代码或设计程序窗口。

可视化设计模式只针对窗体有效哦，你可以双击工程资源管理器中的FormCalculator窗体试试，默认打开的就是对象窗口哦，如下图所示：
{% asset_img image009.png %}
 
不过因为我们研究的是VBA，所以，我们不需要画应用程序的窗口，直接使用Excel表格就可以完成了，如果你感兴趣的话，可以将工程导出，然后使用VB创建.exe应用程序哦。

### 立即窗口
如果你学过其它计算机语言的话，可能会很奇怪，为什么叫这个名字，其实它就是调试程序的输出窗口，类似于C++的输出窗口，Java IDE的Console。代码中使用Debug.Print输出的内容都会在此窗口打印出来。

### 本地窗口
此窗口也跟调试程序有关的，在调试程序的过程中，此窗口显示当前范围的变量的值哦，对调试程序来说，有非常大的帮助呢。

### 调试工具栏
为什么要调试呢？就算是顶级的程序员，也不可能保证一次写好代码，而且永不出错。调试的目的在于理解程序的运行，分析及找出bug原因，然后再加以修正，来保证代码的准确无误地按照我们的期望来执行。
所以调试是使用非常频繁的，大家可以通过菜单栏：将视图→工具栏→调试勾选上，将它显示在工具栏上。
调试可以分单步调试，过程调试等等。具体的操作，请自行体会。

提示：可以通过菜单栏→编译工程，来检查整个工程是否能顺利编译通过。因为VB编辑器没有像其它语言编辑器自动侦错，自动完成，语法检查那样的高级功能（有是有一点，就是功能不够强大），比如你拼错了一个变量，代码编辑器并不会立即告诉你。需要你运行过程中才提示，而且就算是提示，给的错误信息也不准确，我刚开始学习的时候，也因此烦恼了好一阵。刚开始写的时候，及时写，及时编译，还是很有必要的。

## VBA语法

在讲到这一节的时候，我有点纠结，因为一门计算机语言的语法是比较复杂的，所以，限于篇幅，我还是只作简单的介绍，详细的请自行参考某些资料，不过与其它部分（如前面的VBA简介）不同的是，要想学好VBA，其语法肯定是必不可少的重要步骤。就像学习英语一样，如果不熟悉其语法，你就没法表达出英语语境下的意思，别人也无法理解你。对于计算机，它只是一台机器，所以，你必须严格的按照其语法来写代码，计算机才能认识你写的代码，并执行它。

在VB/VBA中，是使用VBScript(VBS)来写代码的，VBScript是一种脚本语言，如果有其它计算机语言基础的话，那么学习VBS，不算一件难事。

*注：关于VBS学习资料，可以在网上搜索并下载《VBSCRIPT 速查手册.chm》*

### 数据类型
VBScript 只有一种数据类型，称为 Variant。Variant 是一种特殊的数据类型，根据使用的方式，它可以包含不同类别的信息。因为 Variant 是 VBScript 中唯一的数据类型，所以它也是 VBScript 中所有函数的返回值的数据类型。

最简单的 Variant 可以包含数字或字符串信息。Variant 用于数字上下文中时作为数字处理，用于字符串上下文中时作为字符串处理。这就是说，如果使用看起来象是数字的数据，则 VBScript 会假定其为数字并以适用于数字的方式处理。与此类似，如果使用的数据只可能是字符串，则 VBScript 将按字符串处理。当然，也可以将数字包含在英文引号 (" ") 中使其成为字符串。

#### Variant 子类型
除简单数字或字符串以外，Variant 可以进一步区分数值信息的特定含义。例如使用数值信息表示日期或时间。此类数据在与其他日期或时间数据一起使用时，结果也总是表示为日期或时间。当然，从 Boolean 值到浮点数，数值信息是多种多样的。Variant 包含的数值信息类型称为子类型。大多数情况下，可将所需的数据放进 Variant 中，而 Variant 也会按照最适用于其包含的数据的方式进行操作。

下表显示 Variant 包含的数据子类型：

子类型 | 描述 
--- | --- 
Empty   | 未初始化的 Variant。对于数值变量，值为 0；对于字符串变量，值为零长度字符串 ("")。
Null    | 不包含任何有效数据的 Variant。
Boolean | 包含 True 或 False。
Byte    | 包含 0 到 255 之间的整数。
Integer | 包含 -32,768 到 32,767 之间的整数。
Currency | -922,337,203,685,477.5808 到 922,337,203,685,477.5807。
Long    | 包含 -2,147,483,648 到 2,147,483,647 之间的整数。
Single  | 包含单精度浮点数，负数范围从 -3.402823E38 到 -1.401298E-45，正数范围从 1.401298E-45 到 3.402823E38。
Double  | 包含双精度浮点数，负数范围从 -1.79769313486232E308 到 -4.94065645841247E-324，正数范围从 4.94065645841247E-324 到 1.79769313486232E308。
Date (Time) | 包含表示日期的数字，日期范围从公元 100 年 1 月 1 日到公元 9999 年 12 月 31 日。
String  | 包含变长字符串，最大长度可为 20 亿个字符。
Object  | 包含对象。
Error   | 包含错误号。

您可以使用转换函数来转换数据的子类型。另外，可使用 VarType 函数返回数据的 Variant 子类型。

### 变量定义
变量是一种使用方便的占位符，用于引用计算机内存地址，该地址可以存储 Script 运行时可更改的程序信息。在 VBScript 中只有一个基本数据类型，即 Variant，因此所有变量的数据类型都是 Variant。

#### 变量声明
声明变量的一种方式是使用 Dim 语句、Public 语句和 Private 语句在 Script 中显式声明变量。例如：
```vbscript
Dim a ‘声明一个变量名为a的变量
Dim a As Integer ‘ 声明一个变量名为a的integer类型变量
```
声明多个变量时，使用逗号分隔变量。例如：
`Dim Top, Bottom, Left, Right`
对于数组的声明，可以通过变更名后面加（）来声明，例如
`Dim b(2) ‘声明一个长度为3的数组`

#### 变量赋值
对于常量，可以使用const START = 3500来赋值
对于变量，可以使用“=”来赋值，如`b(0) = 0 ‘数组下标起始值为0`
`a = Array(0,1,2)`
对于对象，需要使用Set来赋值，如
```vbscript
Dim obj As Collection ‘声明obj是一个集合对象
Set obj = new Collection ‘创建一个Collection对象并赋值给obj
```
### 运算符
VBScript 有一套完整的运算符，包括算术运算符、比较运算符、连接运算符和逻辑运算符。

当表达式包含多种运算符时，首先计算算术运算符，然后计算比较运算符，最后计算逻辑运算符。所有比较运算符的优先级相同，即按照从左到右的顺序计算比较运算符。算术运算符和逻辑运算符的优先级如下所示：


#### 算术运算符              
描述 | 符号
--- | ---   
求幂	| ^	
负号	| -		
乘	    | *	
除	    |   /	
整除	|   \	
求余	| Mod
加	    | +		 	 
减	    | -	 	 	 	 
字符串连接	    | &	 

#### 比较运算符
描述 | 符号
--- | --- 
等于 | =	
不等于	| <>
小于	| <	
大于	| >	
小于等于	| <=	
大于等于	| >=	
对象引用比较	| Is

#### 逻辑运算符
描述 | 符号
--- | --- 
逻辑非         |   Not
逻辑与         |   And
逻辑或         |   Or
逻辑异或        |   Xor
逻辑等价        |   Eqv
逻辑隐含        |   Imp

当乘号与除号同时出现在一个表达式中时，按从左到右的顺序计算乘、除运算符。同样当加与减同时出现在一个表达式中时，按从左到右的顺序计算加、减运算符。
通过运行符，可以实现加，减，除等基本运算及大于，等于等比较操作。
### 流程控制
#### 分支流程
好比遇到分叉路口，需要决定走哪条分支。
```vbscript
Sub testIf()
    If (a > 0) Then 'if 流程分支开始
        Debug.Print ("a more than 0")
    ElseIf (a = 0) Then '可以根据需要，添加0个或多个 ElseIf ... Then
        Debug.Print ("a equals 0")
    Else '剩下的流程
        Debug.Print ("a less than 0")
    End If '结束
End Sub
```
#### 循环流程
重复执行某些操作
```vbscript
Sub testFor()
    For i = 0 To 5 Step 2 '每循环一次，i自增step，如没有添加step，默认step是1
        Debug.Print (i) '可以使用 exit for退出for循环
    Next i
    Debug.Print ("last i is : " & i)
End Sub
```
### 过程与函数
#### Sub 过程
Sub 过程是包含在 Sub 和 End Sub 语句之间的一组 VBScript 语句，执行操作但不返回值。Sub 过程可以使用参数（由调用过程传递的常数、变量或表达式）。如果 Sub 过程无任何参数，则 Sub 语句必须包含空括号 ()。
```vbscript
Sub testArray()
    Dim a
    a = Array(1, 2, 3)
    Debug.Print (a(0))
    Dim b(2)
    b(0) = 0
    b(1) = 1
    b(2) = 2
    Debug.Print (b(2))
End Sub
```
#### Function 过程
Function 过程是包含在 Function 和 End Function 语句之间的一组 VBScript 语句。Function 过程与 Sub 过程类似，但是 Function 过程可以返回值。Function 过程可以使用参数（由调用过程传递的常数、变量或表达式）。如果 Function 过程无任何参数，则 Function 语句必须包含空括号 ()。Function 过程通过函数名返回一个值，这个值是在过程的语句中赋给函数名的。Function 返回值的数据类型总是 Variant。
```vbscript
Function func_smp() As String
    func_smp = "I am a simple function"
End Function

Function func_param(ByVal x As Integer, ByRef y As Integer) As Integer
    func_param = x + y
End Function
```
# VBA + Excel综合实例
相信大家对前面的介绍有点烦了吧，我要学习的是VBA + Excel，干嘛整那么多枯燥乏味的VB呢？唉，其实我也不想的，不过，工欲善其事，必先利其器，先把基础学好了，打扎实了，总不会有错的，在现实生活中，要想学好一门知识，可不像武侠电视剧中，一下子学会九阳真经那么简单。下面就进入我们的实战练习吧。

## 分析及设计
相当于打腹稿吧，程序不是你想的那样，想写就写，分析的过程就是理解用户的需求，用户需要什么，一定要弄清楚了。设计呢，就是考虑程序该怎么写，好比建一幢楼，需要先设计，并不是想怎么写就怎么写，与其它模块有什么接口啦，应该保护什么数据啦。这些都是需要事先考虑或协商好的。

### 分析
需求很简单，就是用户输入TA的税前工资，然后可以计算出所扣的税，税后收入是多少，税率等级是多少。不过我在这里，多考虑一件事：税级。个税有两种，一种是含税级，一种是不含税级的，它们之间，除了计税等级不一样，其它的都是一样子滴。

### 设计
嗯，我想的是这样，我有一个类模块，在类模块初始化（创建）的时候，里面已经包含一些基本的信息了，如税率级，起征点，用户可以选择含税级或不含税级两种计税方式，不过，必须得事先设置好。然后用户输入一个数值，这个类可以计算出应缴纳的税款，税后收入，税率等级，关于计税算法呢，嗯，我就采用百度百科上的示例算法吧（根据对应的税率级按税率扣税，再减去速算扣除数）。然后我想，对应的税级，应缴税款，是根据税前工资决定的，你们可以读它，但是你不可以随意指定它（它必须是经过我计算得出的）。

我再想得长远一点，这个计算器，如果比较受欢迎的话，或者考虑到没有安装Office的人也能够应用。我得将数据，与界面分离，以达到代码的重复利用。嗯，暂时就想这么多吧，下面开始写我们的代码吧。

## VBA实战

### 插入类模块
右键单击工程资源管理器中的任意地方，插入类模块。
{% asset_img image019.png %}
并在属性窗口中将其重命名为：TaxPersonal。并双击此类模块，以打开代码编辑窗口。

### 定义类属性
定义如起征点等属性。
```vbscript
Const START = 3500 '起征点
Const LEVEL_NUM = 7 '总级数
Private pType As Integer ' 只允许写一次 0:含税级; 1:不含税级
Private pName As String '只读属性
Private array_p1, array_p2, array_p 'range
Private array_rate 'rate
Private array_deduct 'deduct
Private pLevel 'level
Private pTax 'tax
Private pDiff As Single '
Private pSalary ' salary before tax
```
这里，使用Private 声明变量，表示变量（属性）是私有的，别的工程不能访问它。

### 添加构建函数
定义一个构建函数，用来做一些初始化操作，比如税率。
在代码窗口中，选择上方的第一个下拉列表中选择Class，再在第二个下拉列表中选择Initialize，来生成构建函数。
{% asset_img image023.png %}
注意，构建函数的名字是固定的，叫Class_initialize()
然后我们填入代码，注意到纳税额数组，其长度为级数减1，因为超过80000，我们不好定义一个具体的上限值。纯粹是算法上的考虑。

### 定义计税Sub
我们定义一个方法来计算所得税
```vbscript
' 计算个人所得税
Public Sub calc(beforeTax As Single)
  pSalary = CCur(beforeTax) '转为货币类型
  If (pSalary <= START) Then '如果低于或等于起征点可以不用计算啦
    pLevel = -1
    pTax = 0
    pDiff = 0
  Else
    pDiff = pSalary - START '计税部分
    If (pType = 0) Then '含税级
      array_p = array_p1
    Else '不含税级
      array_p = array_p2
    End If
    
    For i = 0 To LEVEL_NUM - 2 ' 只算到<或=80000
      If (pDiff <= CLng(array_p(i))) Then
        pLevel = i
        Exit For
      End If
    Next i
    
    If (i = LEVEL_NUM - 1) Then '超过了最后一级
      pLevel = LEVEL_NUM - 1
    End If
    
    ' 使用计税公式计算扣税
    pTax = pDiff * array_rate(pLevel) / 100 - array_deduct(pLevel)
    
  End If
  
End Sub
```
定义属性读写方法
```vbscript
' 获取税后收入
Public Function afterTax() As Single
  afterTax = pSalary - pTax
End Function

' 获取缴纳的个人所得税
Public Property Get tax() As Currency
  tax = pTax
End Property

' 获取个人所得税级别
Public Property Get level() As Integer
  level = pLevel + 1
End Property

' 获取个人所得税计算公式
Public Property Get Expression() As String
  Expression = "Level " & level & ":" & pSalary & " - ((" _
  & pSalary & " - " & START & ") * " & array_rate(pLevel) & "% - " & array_deduct(pLevel) & ")"
End Property

```
注意：获取个人所得税公式函数中，因为字符太长，使用 _ 换行写了。

### 调试
插入一个新模块，名字定义为TaxCalucator，再写一个test Sub来测试及调试我们将才写的类。

在这里，我使用单步调试。
{% asset_img image029.png %}
不知道细心的朋友，有没有发现代码中有一处bug呢？

呵呵，通过本地窗口，可以发现我鼠标选中的那一行，读取的level属性是不对滴，因为在未调用calc函数之前，它应该是默认的0才是。我在TaxPersonal类模块中定义的pLevel有效值是-1到6（内部定义，方便计算，因为数组下标是从0开始计算的），但给别人看的属性level是国家法律中规定的1到7。

可以自己想想，在哪里，应该怎么修复此bug。

## 在Excel中调用VBA
终于到最后一步了：将VBA应用到Excel上去。
首先在这里，特别讲一个Excel对象，其中ActiveSheet属性表示的是当前所在的WorkSheet。

其中一个WorkSheet又是由单元格所组成，最左上角的单元格，其行数为1，列数为1。可以通过Cells(row,column)来获取单元格对象。通过写Value属性来修改单元格的值。有了这些知识。就可以很快地将TaxPersonal应用到表格上去了。

### 新增AutoCalc Sub
双击Sheet 1（2012个人所得税计算器）Sheet，添加AutoCalc Sub用来自动计算个税。代码如下：
```vbscript

Private Sub AutoCalc()
  On Error GoTo ErrorHandle
  Dim total, deduct, beforeTax, levelText
  Dim taxObj As New TaxPersonal
  levelText = Array("很抱歉，您还没有纳税资格！", _
  "恭喜您，你已成为了国家纳税人！", "恭喜您，您应该是温饱不愁了吧？", _
  "恭喜您，您已经迈入小康了！", "恭喜您，好好享受一下小资情调吧！", "恭喜您，您的收入已经达到中产阶级水平了", _
  "恭喜您，您已经为成了名符其实的资产阶级", "恭喜您，国家会感谢您为国家所做的贡献的！")
  
  total = Me.Cells(2, 2).value
  deduct = Me.Cells(3, 2).value
  If (IsNumeric(total)) Then
    Cells(9, 1).value = ""
    If (IsNumeric(deduct)) Then
      Cells(9, 1).value = ""
      beforeTax = CSng(total) - CSng(deduct)
      taxObj.calc (beforeTax)
      'Me.Cells(5, 2).value = beforeTax - taxObj.tax ' 我用Excel公式了，没使用VBA
      Me.Cells(6, 2).value = taxObj.level '税级
      Me.Cells(6, 3).value = taxObj.Expression
      Me.Cells(7, 2).value = taxObj.tax
      Me.Cells(7, 3).value = levelText(taxObj.level) '根据税级给出一个个性化的提示
      Me.Cells(8, 2).value = taxObj.afterTax '税后收入
      
    Else
      Cells(9, 1).value = "请输入有效的扣除项"
    End If
  Else
    Cells(9, 1).value = "请输入有效的税前收入"
  End If
  
  Exit Sub
ErrorHandle:
  Cells(9, 1).value = "哇，恭喜您为我找到一个BUG，错误：" & Err.Description & "，类型：" & Err.Number
  Err.Clear '最后别忘了清除Error对象

End Sub

```
注意，我在代码中还添加了一个错误处理，当有错误产生时，会在最后一行中给出一些错误信息。如果有人发现了bug，可以将输入信息及错误信息发送到li.jamling@gmail.com

### 调用AutoCalc Sub
什么时候触发此Sub呢，我想单元格变更的时候吧，这样，当用户输入完税前工资后，就可以立即自动计算了。
```vbscript
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
  AutoCalc
End Sub
```
选择WorkSheet的SelectionChange Sub，在Sub中调用AutoCalc Sub就可以了。

## VBA工程的签名
### 签名的好处
为什么要签名呢？因为Office默认的宏安全级别为高，如果你的VBA工程未签名，那么默认情况下，此宏是被禁用的。

签名之后，在打开有宏的Excel时，会弹出一个警告框，如下图所示：
{% asset_img image035.png %}
在勾选“总是相信来自此发布者的宏（A）”复选框时，下边的“启用宏(E)”按钮才可以点击。

数字签名，还可以保护代码不被修改，如果代码修改过了，那么签名校验就不会通过。

### 签名过程
开始→程序→Microsoft Office→Microsoft Office工具→VBA项目的数字证书。
{% asset_img image037.png %}
{% asset_img image039.png %}
输入您的证书名称后确定。
在VBA 编辑器中，菜单栏工具→数字签名→选择刚才创建的证书即可。

### VBA宏保护
通过VBA的工程属性，可以设置一个工程进入密码，可以防止别人查看，修改你的VBA代码

工具→工程属性，点击保护选项卡，输入工程保护密码即可
{% asset_img image041.png %} 

## 练习
在熟悉VBA之后，使用VBA实现一个《个体工商户的生产经营所得税计算器》。附录工程中包含答案。

## 附录
完整工程
个人所得税计算器VBA工程：{% asset_link 个人所得税计算器.xls %}
 
# 关于作者
Jamling，男，资深宅男，85年生，目前就职于南京一家软件公司，主要从事Java软件设计及研发。在工作之余，喜欢搞一些与软件相关的研究性课题，姑且算是一名技术宅吧。

Email: li.jamling@gmail.com

注：
后面我可能会再制作Excel VBA高级教程，面向的读者是已有VBA基础的读者。

