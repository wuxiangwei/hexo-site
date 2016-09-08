---
title: 使用Android NDK编译OpenCV应用
date: 2011-08-01 21:00:00
category: [Android]
tags: [Android]
toc: true
---
## 简介
在linuxt系统下使用OpenCV2.3 + NDK R6编译 OpenCV人脸检测应用
<!-- more -->

## 准备
- Android NDK ( r5或更高版本) 
下载地址：http://developer.android.com/sdk/ndk/index.html
- OpenCV Android包 
http://sourceforge.net/projects/opencvlibrary/files/opencv-android/2.3/
- cmake(可选，替代NDK)
参考：http://www.cmake.org/

*注：http://code.google.com/p/android-opencv/网站上说要使用crystax ndk r4代替NDK。估计可能是对于较旧的Android版本需要这样。如果NDK无法编译，请尝试使用crystax ndk r4编译。*

### OpenCV设置
从网站上下载OpenCV 2.3.0 for Android 后，解压到某个目录，如~/目录下
设置OPENCV_PACKAGE_DIR环境变量
`$ export OPENCV_PACKAGE_DIR=~/enCV-2.3.0/`

## 步骤
### 新建一个Android工程
在eclipse中新建一个android 工程如study.opencv，并且在工程根目录下新建一个名为jni的目录。将下载的android-ndk-r6解压到某个目录下，如~/
从~/android-ndk-r6/sample下某个sample中拷贝Android.mk, Application.mk到study.opencv/jni目录

### 设置编译脚本
在Android.mk中，include $(CLEAR_VARS)后面，加入下行
`include $(OPENCV_PACKAGE_DIR)/$(TARGET_ARCH_ABI)/share/opencv/OpenCV.mk`
如果应用支持ARM NEON那么还需要加入以下行
```
include $(OPENCV_PACKAGE_DIR)/armeabi-v7a-neon/share/opencv/OpenCV.mk
LOCAL_ARM_NEON := true
```
在Application.mk中加入以下行
```
 APP_STL := gnustl_static
 APP_CPPFLAGS := -frtti -fexceptions
```
注：关于Android.mk与Application.mk的详细说明，请参考ndk/docs下Android-mk.html和Application-mk.html。

### Java层定义native接口
新建study.opencv.FaceRec类，定义一个人脸检测的本地接口
```
	/**
	 * detect front face from image.
	 * 
	 * @param xml
	 *            opencv haarcascade xml file path
	 * @param infile
	 *            input image file path
	 * @param outfile
	 *            output image file path
	 */
	public native void detect(String xml, String infile, String outfile);
```

### 生成jni头文件
使用javah命令生成jni头文件
```
$ cd ~/workspace/study.opencv/bin
$ javah study.opencv.FaceRec
```
会在bin目录生成一个study_opencv_FaceRec.h文件。将此文件拷贝到../jni目录中

注：如果接口有变更，请先手动删除生成的.h文件。以防止一些意外的错误。

### 在c层实现图像人脸检测
在jni目录中使用文本编辑器新建一个facedetect.cpp，实现图像人脸检测

```c
#include "cv.h"
#include "highgui.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include <time.h>
#include <ctype.h>

#include <android/log.h>
#include <study_opencv_FaceRec.h>
#include <jni.h>

#define  LOG_TAG    "opencv_face_detect"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

static CvMemStorage* storage = 0;
static CvHaarClassifierCascade* cascade = 0;
void detect_and_draw( IplImage* image );
const char* cascade_name =
    "haarcascade_frontalface_alt.xml";
/*    "haarcascade_profileface.xml";*/
/*int captureFromImage(char* xml, char* filename);*/
char* jstring2String(JNIEnv*, jstring);
int captureFromImage(char* xml, char* filename, char* outfile)
{
	LOGI("begin: ");
	// we just detect image
	// CvCapture* capture = 0;
    IplImage *frame, *frame_copy = 0;
    const char* input_name = "lina.png";
	if(xml != NULL)
	{
		cascade_name = xml;	
	}
	if(filename != NULL)
	{
		input_name = filename;
	}
	LOGI("xml=%s,filename=%s", cascade_name, input_name);
	// load xml 
    cascade = (CvHaarClassifierCascade*)cvLoad( cascade_name, 0, 0, 0 );
	LOGI("load cascade ok ? %d", cascade != NULL ? 1 : 0);
	if( !cascade )
    {
        LOGI("ERROR: Could not load classifier cascade\n" );
		// I just won't write long full file path, to instead of relative path, but I failed.
		FILE * fp = fopen(input_name,"w");
		if(fp == NULL){
			LOGE("create failed");
		}
        return -1;
    }
	storage = cvCreateMemStorage(0);
	// cvNamedWindow( "result", 1 );
    IplImage* image = cvLoadImage( input_name, 1 );
    if( image )
    {
		LOGI("load image successfully");
        detect_and_draw( image );
        // cvWaitKey(0);
		if(outfile != NULL)
		{
			LOGI("after detected save image file");
			cvSaveImage(outfile, image);//把图像写入文件
		}
        cvReleaseImage( &image );
    }
	else
	{
		LOGE("can't load image from : %s ", input_name);
	}
}
void detect_and_draw( IplImage* img )
{
    static CvScalar colors[] = 
    {
        {{0,0,255}},
        {{0,128,255}},
        {{0,255,255}},
        {{0,255,0}},
        {{255,128,0}},
        {{255,255,0}},
        {{255,0,0}},
        {{255,0,255}}
    };
    double scale = 1.3;
    IplImage* gray = cvCreateImage( cvSize(img->width,img->height), 8, 1 );
    IplImage* small_img = cvCreateImage( cvSize( cvRound (img->width/scale),
                         cvRound (img->height/scale)),
                     8, 1 );
    int i;
    cvCvtColor( img, gray, CV_BGR2GRAY );
    cvResize( gray, small_img, CV_INTER_LINEAR );
    cvEqualizeHist( small_img, small_img );
    cvClearMemStorage( storage );
    if( cascade )
    {
        double t = (double)cvGetTickCount();
        CvSeq* faces = cvHaarDetectObjects( small_img, cascade, storage,
                                            1.1, 2, 0/*CV_HAAR_DO_CANNY_PRUNING*/,
                                            cvSize(30, 30) );
        t = (double)cvGetTickCount() - t;
        LOGI( "detection time = %gms\n", t/((double)cvGetTickFrequency()*1000.) );
        for( i = 0; i < (faces ? faces->total : 0); i++ )
        {
            CvRect* r = (CvRect*)cvGetSeqElem( faces, i );
            CvPoint center;
            int radius;
            center.x = cvRound((r->x + r->width*0.5)*scale);
            center.y = cvRound((r->y + r->height*0.5)*scale);
            radius = cvRound((r->width + r->height)*0.25*scale);
            cvCircle( img, center, radius, colors[i%8], 3, 8, 0 );
        }
    }
    // cvShowImage( "result", img );
    cvReleaseImage( &gray );
    cvReleaseImage( &small_img );
}

JNIEXPORT void JNICALL Java_study_opencv_FaceRec_detect
  (JNIEnv * env, jobject obj, jstring xml, jstring filename, jstring outfile)
{
	LOGI("top method invoked! ");/*LOGI("1");
	char * c_xml = (char *)env->GetStringUTFChars(xml, JNI_FALSE);
	LOGI("char * = %s", c_xml);
	if(c_xml == NULL)
	{
		LOGI("error in get char*");
		return;
	}
	char * c_file = env->GetStringCritical(env, filename, 0);
	if(c_xml == NULL)
	{
		LOGI("error in get char*");
		return;
	}
	captureFromImage(c_xml, c_file);
	env->ReleaseStringCritical(env, xml, c_xml);
	env->ReleaseStringCritical(env, file_name, c_file);
	*/
	captureFromImage(jstring2String(env,xml), jstring2String(env,filename), jstring2String(env,outfile));

}

//jstring to char*

char* jstring2String(JNIEnv* env, jstring jstr)
{
	if(jstr == NULL)
	{
		LOGI("NullPointerException!");
		return NULL;
	}
	char* rtn = NULL;
	jclass clsstring = env->FindClass("java/lang/String");
	jstring strencode = env->NewStringUTF("utf-8");
	jmethodID mid = env->GetMethodID(clsstring, "getBytes", "(Ljava/lang/String;)[B");
	jbyteArray barr= (jbyteArray)env->CallObjectMethod(jstr, mid, strencode);
	jsize alen = env->GetArrayLength(barr);
	jbyte* ba = env->GetByteArrayElements(barr, JNI_FALSE);
	if (alen > 0)
	{
		rtn = (char*)malloc(alen + 1);
		memcpy(rtn, ba, alen);
		rtn[alen] = 0;
	}
	env->ReleaseByteArrayElements(barr, ba, 0);
	LOGI("char*=%s",rtn);
	return rtn;
}
```

Android.mk:
```make
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
include $(OPENCV_PACKAGE_DIR)/$(TARGET_ARCH_ABI)/share/opencv/OpenCV.mk

LOCAL_MODULE    := facedetect
LOCAL_CFLAGS    := -Werror
LOCAL_SRC_FILES := \
	facedetect.cpp \

LOCAL_LDLIBS    := -llog

include $(BUILD_SHARED_LIBRARY)
```
Application.mk:
```
APP_ABI := armeabi armeabi-v7a
APP_PLATFORM := android-10
APP_STL := gnustl_static
APP_CPPFLAGS := -frtti -fexceptions
```

### 使用NDK进行编译
在工程jni目录下执行ndk-build
```sh
$ cd ~/workspace/study.opencv/jni
$ ~/android-ndk-r6/ndk-build.
```
如果编译成功，则会在工程下面生成libs/armeabi/facedetect.so库了.
如有编译失败，请根据提示修改错误

### 调用JNI接口
将opencv人脸检测要用到的xml文件(位于OpenCV-2.3.0/armeabi/share/opencv/haarcascades/目录下)及图像文件使用DDMS push到data/data/study.opencv/files目录中。

在activity中新建一个线程，调用FaceRec#detect方法。
```Java
@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		final FaceRec face = new FaceRec();
		new Thread() {
			@Override
			public void run() {
				face.detect(
						"/data/data/study.opencv/files/haarcascade_frontalface_alt2.xml",
						"/data/data/study.opencv/files/wqw1.jpg",
						"/data/data/study.opencv/files/wqw1_detected.jpg");
			}
		}.start();

	}
```

### 运行结果
经测试，对png,jpg,bmp图片可以正确识别，不过就是速度有点慢。

## 参考
- 人脸检测
http://www.opencv.org.cn/index.php/%E4%BA%BA%E8%84%B8%E6%A3%80%E6%B5%8B
