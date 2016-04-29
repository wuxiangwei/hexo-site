---
title: 带NameSpace的xml XPath搜索
date: 2008-09-29 10:56:00
category: [软件技术,Java]
tags: [xml]
toc: true
---
以典型的J2EE web.xml文件为例，某次要解析此文件。使用Xpath搜索得到的都是null。使用System.out.println（root）打印节点，发现比不带NameSpace的XML root多了一个uri，那么在Xpath中加入uri（setNameSpace("",uri)），结果搜索的结果还是null。后来google了一下，才知道原来当NameSpace的prefix为“”时，在Xpath中需要加入“default”prefix。 
因此，自己可以定义一个比较通用的Xpath搜索方法：
<!-- more -->
```java
/** 
*@param e XPath search based element 
*@param xpath XPath search string 
*@return search result element if exist else null would be returned 
*/ 
public Element getSingleElementByXPath(Element e,String xpath){ 
    Element ret = null; 
    try{ 
        XPath xPath = XPath.getInstance(); 
        String prefix = e.getNameSpacePrefix(); 
        String uri = e.getNameSpaceURI(); 
        if(!"".equals(uri)){ 
            if(!"".equals(prefix)){ 
                xPath.setNameSpace(prefix,uri); 
            }else { 
                xPath.setNameSpace("default",uri); 
            } 
        } 
        ret = xPath.getSingleElementByXpath(e,xpath); 
    } catch (Exception e){ 
        // 
    } 
    return ret; 
}
```

不过，对于多级的Xpath搜索，此方法设置的Xpath NameSpace还是不够，需要自己在Xpath每一级中加入prefix:前导。 
因为一次性给Xpath设置NameSpace并不起作用，这不能不说是给有NameSapce的XML搜索带来致命的移植与维护的问题。

总结：
1，对没有NameSpace的Xpath child:books/child:book... 
2, 对prefix 为"" 的 Xpath default:books/default:book... 
3, 对prefix 不为空的Xpath prefixValue:books/prefixValue:book.... 
