---
title: Thread.join()在AsyncTask中的妙用
date: 2012-06-08 21:00:00
category: [Android]
tags: [Android, Java]
toc: true
---
## 问题
在Android Email当中，在设置接收服务器和发送服务器时，点击下一步，系统会弹出进度框，并执行服务器设置检验。如果用户设置信息不正确，在执行校验时，大约会花1分钟的时间去校验，最后才会提示设置信息不正确。如果用户在等待过程中点击了“取消”，然后再点下一步，发会现，不再弹出等待提示框，也不执行校验了。
<!-- more -->
## 分析

通过分析源码发现，在点击“下一步”执行校验时，会执行一个AsyncTask，在doIngBackground（）中，去打开socket连接，完成相应的校验。同时弹出一个等待提示框。如果用户点击“取消”, 会终止此AsyncTask，并重新生成一个AsyncTask并执行。

但通过debug发现，后面的AsyncTask并没有真正执行。原因是因为前面的Task阻塞在了联网校验上。通过查阅Android文档得知，AsyncTask，是异步处理类。它会新生成一个线程去执行doInBackground。对外，开发者不能获取此线程的引用，就算获取到了，对于像socket连接或IO操作会导致阻塞的作业，强行interrupt线程并不能退出阻塞。

## 结论

所以为避免之后的AsyncTask能够被正常执行，请记住:

不要阻塞doInBackground()，我们应该新建一个线程来完成可能导致阻塞的操作。

## 解决方法

**使用Thread.join()**
```java
@Override  
protected Object doInBackground(Void... params) {  
    Thread thread = new Thread(){  
           public void run(){  
                  mResult = getFromServer();// 从网络上获取数据  
           }  
    };  
    thread.start();  
    try{  
        thread.join(); // 阻塞当前线程，等待thread执行完毕，可以带参数，最多等待多长时间  
    } catch (InterruptedException e) {  
        // Thread.join()可以被interrupt，调用AsyncTask.cancel(true);即可退出等待  
        return null;  
    }
}
```