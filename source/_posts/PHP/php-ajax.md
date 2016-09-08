---
title: PHP + Ajax示例
date: 2016-08-26 18:30:30
category: [Web]
tags: [PHP, Ajax]
toc: true
---

PHP是非常流行的Web服务端语言，Ajax是Web前端异步加载的技术。刚刚学习PHP，发现PHP真是强大，对Ajax或RESTFul的支持非常好，代码写起来也非常简单。今天分享一个个人学习的测试示例，前端使用Ajax向服务端发送请求，服务端使用PHP处理请求，并返回响应信息。接口规范遵循RESTFul。

## 前端
为简化Ajax操作，引入JQuery来发送Ajax请求。请求包含查询字符串，HTTP头及表单数据。

```html test.html
<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <title>Document</title>
<script src="//cdn.bootcss.com/jquery/2.2.0/jquery.min.js"></script>
<link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.6/css/bootstrap-theme.min.css">
<script src="//cdn.bootcss.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

<script>
function my_post() {
  var div = $('#result');
  $.ajax({
          url : 'test.php?urlvar1=var1&urlvar2=var2',
          dataType : "json",
          type : 'post',
          headers: {
            hvar : 'hvar'
          },
          data : {
            foo : 'bar',
            postvar: [{var1: 'var1', var2: 'var2'}, {var1: 'var10', var2: 'var20'}]
          },
          success : function(data) {
            if (data.code==0) {
              div.html(JSON.stringify(data));
            }
          },
          error: function (xhr, msg, e) {console.log(e);
            div.html('加载失败');
          }
        });
}

</script>
 </head>
 <body>
  <div class="container">
    <br>
    <a class="btn btn-primary" role="button" href="javascript:my_post();">发射</a> <br>
    <textarea id="result" class="col-xs-12"></textarea>
  </div>
 </body>
</html>

```

请求数据如下图所示：

{% asset_img request.png %}

其实请求还包含一个hvar的HTTP请求头，HTTP头通常用于设置授权，加密等接口参数。业务参数一般放在url或表单数据中。如果请求方式为get，那么表单数据会作为查询字符串追加到url中。


## 后端

提交请求后，由后端的test.php来处理请求。只简单地将收到的请求Headers，GET参数及POST参数封装成json并返回。

```php test.php
<?php

$data = $_POST['postvar'];
$headers = getallheaders();
foreach ($headers as $key => $value) {
  //echo $key . "=" . $value;
}

header('content-type:application/json;charset=utf8');

$ret = array(
  'code' => 0,
  'headers' => $headers,
  'gets' => $_GET,
  'posts' => $_POST
);
exit(json_encode($ret));
?>
```

接口传过来的json对象，直接会被PHP解析为关联数据。比如<var>$data</var>就是一个array。

响应结果如下图所示：

{% asset_img response.png %}

其中headers包含一个hvar的参数。PHP转json由内置函数`json_encode()`来完成。

## 运行结果

{% asset_img result.png %}

## 总结

PHP真是强大，关联数据与json在结构上非常相似，处理json也非常的方便。如果是Java，后端代码写起来就复杂许多了，json处理还得引入第三方库。

[hexo api]: https://hexo.io/zh-cn/api/
[hexo]: https://hexo.io
[hexo-generator-index2]: http://github.com/Jamling/hexo-generator-index2
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
