---
title: Hexo my blog
date: 2016-03-04 12:48:31
category: [软件技术, Web]
tags: [Hexo, Node.js]
toc: true
---
# Plan
 * build
 * custom my theme
 * custom my plugin
 * Optimize

<!-- more -->

# custom my theme
## study theme
## design your theme
##  layout
 
### post theme 
### post detail
### post list
### post widget

# Optimize
## Baidu site tools
For China.
login [百度站长平台](http://zhanzhang.baidu.com/), and add your site then to verify.

Verification

* File verification 
    download baidu_xxxx_verify.html and upload to your site root dir to verify.
* HTML tag verification 
    add 
 ```
 <meta name="baidu-site-verification" content="xxx" />
 ```
 to your home .html
* CNAME verification    
    add a cname dns parser to zz.baidu.com

    
### tools
After site added, you can do 

1. Post links    
    I choose post my links automatically using following script
```js
<script>
(function(){
    var bp = document.createElement('script');
    bp.src = '//push.zhanzhang.baidu.com/push.js';
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(bp, s);
})();
</script>
```
2. Update robots    
    Update your robots.txt under your site root dir
3. Search in sites    
    Enable and add your script
4. Social Share    
    Custom your share style and add script
5. Analytics   
    Enable baidu analytics

    
