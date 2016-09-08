---
title: PHP + MySQL批量插入测试
date: 2016-08-25 18:30:30
category: [Web]
tags: [PHP, MySQL]
toc: true
---

使用PHP + MySQL来测试插入百万条数据，看看到底要多久。

<!-- more -->

## 测试代码
使用MySQL批处理即 insert table (field1, filed2...) values (value1, value2...), ... (value n1, value n2) 来插入数据。

```php
<?php

include('init.php');

if(empty($db)) $db=DBConnect();

set_time_limit(0); // 执行时间超过30秒，wamp会中断执行。此方法不起作用。

// 先清空表
$db->execute("truncate table oc_project_content2");
// sql 插入语句
$sql = "insert into oc_project_content2 (gid, gname, fid, fname) values ";
// 分m次执行，一条n条
$m = 1000; $n = 1000;
$t1 = time(); // 开始计时
for($i=0; $i<$m; $i++){
  $arr = array();
  for($j=0; $j<$n; $j++) {
    $gid = ($i * $m + $j);
    $fid = 100;//rand(0, $m*$n)
    $arr[$j] = '('. $gid . ',"' . randStr(6) . '",' . $fid . ',"' . randStr(12) . '")';
  }//var_dump($arr);
  $tmp = join(',', $arr);
  $batch = $sql . $tmp;
  // var_dump($batch);
  $db->execute($batch);
}

$t2 = time();
echo $t2 - $t1 . ' s escaped ' . PHP_EOL; // 查看时间，单位秒

$count = $db->FirstRow("SELECT count(*) FROM `oc_project_content2`");
foreach ($count as $key => $value) {
  echo $key . '=>' . $value;
};

// 生成随机字符串
function randStr($m = 6) {
  $new_str = '';
  $str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwsyz0123456789';
  $max=strlen($str)-1;
  for ($i = 1; $i <= $m; ++$i) {
    $new_str .=$str[mt_rand(0, $max)];
  }
  return $new_str;
}

?>

```

## 测试结果

以下是4次测试结果， 前3次是100x1000条数据，第4次是1000x1000条数据。
```shell
C:\wamp\www\test>..\..\bin\php\php5.3.10\php.exe api.php
11 s escaped
count(*)=>1000000
C:\wamp\www\test>..\..\bin\php\php5.3.10\php.exe api.php
12 s escaped
count( * )=>100000
C:\wamp\www\test>..\..\bin\php\php5.3.10\php.exe api.php
123 s escaped
count(*)=>1000000
C:\wamp\www\test>
```

** 1000x1000条数据，for循环组装sql的时间大约需要24s **

## 总结
MySQL果然强大哈，在我的工作机中，大约1秒能执行10000条插入操作。我的工作机配置不高，2.4G主频，而且开了一堆的软件包括相当吃内存的Android Studio, Eclipse等。

## 遇到的问题

- Maximum execution time of 30 seconds exceeded
执行时间超过30秒，php会报错并中断执行。需要改php.ini设置并重启生效或者在命令行下执行。


[hexo api]: https://hexo.io/zh-cn/api/
[hexo]: https://hexo.io
[hexo-generator-index2]: http://github.com/Jamling/hexo-generator-index2
[hexo-generator-github]: http://github.com/Jamling/hexo-generator-github
[hexo-generator-i18n]: http://github.com/Jamling/hexo-generator-i18n
