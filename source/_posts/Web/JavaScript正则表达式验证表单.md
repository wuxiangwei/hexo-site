---
title: JavaScript正则表达式验证表单
date: 2007-06-07 21:57:00
category: [Web]
tags: [js]
---

原理：基于自定义的标签；
实现：目前只有文本框和密码域的验证

<!-- more -->
```js
/*************************自定义的模式匹配函数
*********rule：匹配规则
*********vaule:匹配对象（表单元素的值）
*********warning：警告内容
*********note：显示警告的DIV层
************************************************/
function myReg(rule, value, warning, note) {
  var reg = new RegExp(rule);
  var noteDiv = document.getElementById(note);
  if (!reg.test(value)) {
    err += warning;
    err += '\n';
    noteDiv.innerHTML = "<font color=red>" + warning + "</font>"
  } else {
    noteDiv.innerHTML = "<font color=green>OK</font>"
  }
}
function checkForm2(form) {
  var f = document.getElementById(form);
  var l = form.length;
  for (i = 0; i < l; i++) {
    var e = f.elements;
    switch (e.type) {
    case "text":
      {
        if (e.need == "true") {
          myReg(e.rule, e.value, e.warning, e.note)
        } else {
          if (e.value != "") {
            myReg(e.rule, e.value, e.warning, e.note)
          } else {
            document.getElementById(e.note).innerHTML = "ok"
          }
        }
        break
      }
    case "password":
      {
        myReg(e.rule, e.value, e.warning, e.note);
        if (psw == "") {
          psw = e.value
        } else {
          if (psw != e.value) {
            document.getElementById(e.note).innerHTML = "<font color=red>" + e.warning + "</font>"
          } else {
            document.getElementById(e.note).innerHTML = "<font color=green>ok</font>"
          }
          psw = ""
        }
        break
      }
    }
  }
  if (err != "") {
    alert(err);
    err = '';
    return false
  } else {
    return true
  }
}
```