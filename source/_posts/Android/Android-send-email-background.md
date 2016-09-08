---
title: Android平台邮件自动发送功能实现
date: 2012-03-01 21:00:00
category: [Android]
tags: [Android]
toc: true
---
## 简介
本文简述的是在Android平台如何自动发送邮件（没有邮件编写界面），主要应用场景为忘记密码等安全等级较高的操作，比如我忘记密码了，点击“发送密码到我的邮箱”系统会将密码发送到注册时的电子邮件地址。
<!-- more -->
## Android平台邮件客户端

- Gmail: Gmai电子邮件客户端
- Email: 通用的电子邮件客户端

 
## 解决方案
### Gmail

Gmail已经支持自动发送了，所以非常简单。在使用时，需要添加
`<uses-permission android:name="com.google.android.gm.permission.AUTO_SEND" />`
到AndroidManifest.xml

示例代码如下：
```
    Intent intent = new Intent("com.google.android.gm.action.AUTO_SEND");  
    intent.setType("plain/text");  
    String[] reciver = new String[] { "xxxx@xxx.com" };  
    String subject = "email title";  
    String body = "email body";  
    intent.putExtra(android.content.Intent.EXTRA_EMAIL, reciver);  
    intent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);  
    intent.putExtra(android.content.Intent.EXTRA_TEXT, body);  
```
### Email

Email不支持自动发送，但又是默认邮件客户端，所以需要添加自动发送功能。主要实现步骤为：

#### 编写一个自动发送邮件类

主要功能为：接收用户输入，组装message对象，获取Sender实例，将message发送出去，最后删除message对象（这样已发送的邮件内容不会出现在client中，提高发安全性）

Java代码
```
    package com.android.email.activity;  
      
    import android.app.Activity;  
    import android.app.ProgressDialog;  
    import android.content.ContentUris;  
    import android.content.Context;  
    import android.content.Intent;  
    import android.os.AsyncTask;  
    import android.os.Bundle;  
    import android.text.TextUtils;  
    import android.util.Log;  
    import android.view.View;  
    import android.view.Window;  
    import android.net.Uri;  
    import android.widget.Toast;  
      
    import com.android.emailcommon.provider.EmailContent;  
    import com.android.emailcommon.provider.EmailContent.Account;  
    import com.android.emailcommon.provider.EmailContent.Message;  
    import com.android.emailcommon.mail.MessagingException;  
    import com.android.emailcommon.mail.Address;  
    import com.android.emailcommon.utility.Utility;  
    import com.android.emailcommon.mail.AuthenticationFailedException;  
    import com.android.email.EmailAddressValidator;  
    import com.android.email.mail.Sender;  
      
    /** 
     * Send email in background with account configured in Email application. 
     * Sending message will not saved as draft or in out-going box. Usage: 
     *  
     * <pre> 
     * Intent intent = new Intent(&quot;com.android.email.intent.action.sendInBack&quot;); 
     * String[] reciver = new String[] { &quot;your_name@corp.com&quot; }; 
     * String subject = &quot;email title&quot;; 
     * String body = &quot;email body &quot;; 
     * intent.putExtra(android.content.Intent.EXTRA_EMAIL, reciver[0]); 
     * intent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject); 
     * intent.putExtra(android.content.Intent.EXTRA_TEXT, body); 
     * startActivityForResult(Intent.createChooser(intent, &quot;send&quot;), 0x02); 
     * </pre> 
     *  
     * Now, attachment and multi-receiver function is unsupported. 
     *  
     * @author melord 
     *  
     */  
    public class EmailSendAutoActivity extends Activity implements SendListener {  
      
        private static String tag = "EmailSendAutoAcitivity";  
        private Context mContext;  
      
        private String mTo;  
        private String mCc;  
        private String mBcc;  
        private String mSubject;  
        private String mBody;  
      
        private EmailAddressValidator mValidator = new EmailAddressValidator();  
        private SendListener mListener;  
        private Toast mWaiting;  
        private boolean enableLog = true;  
      
        /** 
         * Sending account email address. 
         */  
        private String mSendEmail;  
        /** 
         * Sending account id 
         */  
        private long mAccountId = -1;  
      
        @Override  
        protected void onCreate(Bundle savedInstanceState) {  
            super.onCreate(savedInstanceState);  
            this.mContext = this;  
            requestWindowFeature(Window.FEATURE_NO_TITLE);  
      
            mListener = this;  
            Intent intent = getIntent();  
            initMessageFromIntent(intent);  
            initAccountFromIntent(intent);  
      
            new SendTask().execute();  
            String msg = intent.getStringExtra("sendMsg");  
            if (msg == null) {  
                msg = "Sending message...";  
            }  
            // mWaiting = ProgressDialog.show(this, "", "sending...", true, true,  
            // null);  
            mWaiting = Toast.makeText(this, msg, Toast.LENGTH_LONG);  
            mWaiting.show();  
        }  
      
        @Override  
        public void onBackPressed() {  
            if (mWaiting != null) {  
                mWaiting.cancel();  
            }  
            super.onBackPressed();  
        }  
      
        @Override  
        public void finish() {  
            if (mWaiting != null) {  
                mWaiting.cancel();  
            }  
            super.finish();  
        }  
      
        /** 
         * Initialize sending account from intent. 
         *  
         * @param intent 
         *            imcoming intent 
         */  
        private void initAccountFromIntent(Intent intent) {  
            String email = intent.getStringExtra("sendAccount");  
            if (email != null) {  
                log(String.format("send email use account (%s) ", email));  
                mSendEmail = email;  
                Long[] ids = EmailContent.Account.getAllAccountIds(this);  
                if (ids != null && ids.length > 0) {  
                    for (int i = 0; i < ids.length; i++) {  
                        EmailContent.Account temp = EmailContent.Account  
                                .restoreAccountWithId(this, ids[i]);  
                        if (temp != null && email.equals(temp.getEmailAddress())) {  
                            log("valid account");  
                            mAccountId = ids[i];  
                            break;  
                        }  
                    }  
                }  
            }  
        }  
      
        /** 
         * Initialize message from intent. 
         *  
         * @param intent 
         *            intent 
         */  
        private void initMessageFromIntent(Intent intent) {  
            String to = intent.getStringExtra(Intent.EXTRA_EMAIL);  
            mTo = composeAddress(to);  
      
            String cc = intent.getStringExtra(Intent.EXTRA_CC);  
            mCc = composeAddress(cc);  
      
            String bcc = intent.getStringExtra(Intent.EXTRA_BCC);  
            mBcc = composeAddress(bcc);  
      
            mSubject = intent.getStringExtra(Intent.EXTRA_SUBJECT);  
      
            mBody = intent.getStringExtra(Intent.EXTRA_TEXT);  
      
            log("to:" + mTo);  
            log("cc:" + mCc);  
            log("bcc:" + mBcc);  
      
        }  
      
        /** 
         * change to stand email address reference to Rfc822 
         *  
         * @param address 
         *            email address 
         * @return RFC822 format email address 
         */  
        private String composeAddress(String address) {  
            String addr = null;  
            if (!TextUtils.isEmpty(address)) {  
                Address[] addresses = Address.parse(address.trim());  
                addr = Address.pack(addresses);  
            }  
            return addr;  
        }  
      
        /** 
         * Update message. fill fields. 
         *  
         * @param message 
         *            email message 
         * @param account 
         *            sending account 
         */  
        private void updateMessage(Message message, Account account) {  
            if (message.mMessageId == null || message.mMessageId.length() == 0) {  
                message.mMessageId = Utility.generateMessageId();  
            }  
            message.mTimeStamp = System.currentTimeMillis();  
            // it will : Name<Address>  
            message.mFrom = new Address(account.getEmailAddress(), account  
                    .getSenderName()).pack();  
            message.mTo = mTo;  
            message.mCc = mCc;  
            message.mBcc = mBcc;  
            message.mSubject = mSubject;  
            message.mText = mBody;  
            message.mAccountKey = account.mId;  
            // here just used account setting simply  
            message.mDisplayName = account.getSenderName();  
            message.mFlagRead = true;  
            message.mFlagLoaded = Message.FLAG_LOADED_COMPLETE;  
      
        }  
      
        private void log(String msg) {  
            if (enableLog) {  
                Log.i(tag, msg);  
            }  
        }  
      
        /** 
         * Really send message. 
         *  
         * @param account 
         *            sending account 
         * @param messageId 
         *            message id 
         */  
        public void sendMessage(Account account, long messageId) {  
            // message uri  
            Uri uri = ContentUris.withAppendedId(EmailContent.Message.CONTENT_URI,  
                    messageId);  
            try {  
                // get a sender, ex. smtp sender.  
                Sender sender = Sender.getInstance(mContext, account  
                        .getSenderUri(mContext));  
                // sending started  
                mListener.onStarted(account.mId, messageId);  
                // sending  
                sender.sendMessage(messageId);  
                // send completed  
                mListener.onCompleted(account.mId);  
      
            } catch (MessagingException me) {  
                // report error  
                mListener.onFailed(account.mId, messageId, me);  
            } finally {  
                try {  
                    // delete this message whenever send successfully or not  
                    mContext.getContentResolver().delete(uri, null, null);  
                } catch (Exception ex) {  
                    Log.w(tag, "delete message occur exception message uri:" + uri);  
                }  
            }  
        }  
      
        public void onCompleted(long accountId) {  
            log("send mail ok");  
            // return Activity.RESULT_OK when send successfully  
            setResult(RESULT_OK);  
            finish();  
        }  
      
        public void onFailed(long accountId, long messageId, Exception ex) {  
            log("send mail failed : " + ex.toString());  
            finish();  
        }  
      
        public void onStarted(long messageId, long accountId) {  
            log("send mail started");  
        }  
      
        /** 
         * Send message task, it is an async task 
         *  
         * @author melord_li 
         *  
         */  
        private class SendTask extends AsyncTask<Void, Void, Void> {  
            @Override  
            protected Void doInBackground(Void... params) {  
                // get default account, if not set, first record is treated as  
                // default.  
                // long id = Account.getDefaultAccountId(mContext);  
                long id = mAccountId;  
                if (id < 0) {  
                    id = Account.getDefaultAccountId(mContext);  
                }  
                if (id < 0) {  
                    Log.w(tag, "no account exists");  
                    finish();  
                    return null;  
                }  
                // get full account message  
                Account account = Account.restoreAccountWithId(mContext, id);  
      
                // A empty message  
                Message message = new Message();  
                // fill message field  
                updateMessage(message, account);  
      
                // Save this message. Because send API will read message in message  
                // db.  
                Uri uri = message.save(mContext);  
                if (uri == null) {  
                    Log.e(tag, "save message occured an error");  
                    finish();  
                    return null;  
                }  
      
                // send  
                sendMessage(account, message.mId);  
                return null;  
            }  
        }  
    }  
      
    /** 
     * Sending monitor 
     *  
     * @author melord 
     *  
     */  
    interface SendListener {  
      
        /** 
         * Send failed. 
         *  
         * @param accountId 
         *            account id 
         * @param messageId 
         *            message id 
         * @param ex 
         *            exception 
         */  
        void onFailed(long accountId, long messageId, Exception ex);  
      
        /** 
         * Send begin. 
         *  
         * @param accountId 
         *            account id 
         * @param messageId 
         *            message id 
         */  
        void onStarted(long messageId, long accountId);  
      
        /** 
         * Send completed. 
         *  
         * @param accountId 
         *            account id 
         */  
        void onCompleted(long accountId);  
    }  
```
#### 配置
Xml代码
```xml
    <activity android:name=".activity.EmailSendAutoActivity" android:theme="@android:style/Theme.Translucent">  
        <intent-filter>  
            <action android:name="com.android.email.intent.action.sendInBack"/>  
            <data android:mimeType="*/*" />  
            <category android:name="android.intent.category.DEFAULT" />  
        </intent-filter>  
    </activity>  
```
#### 使用
Java代码
```Java
    Intent intent = new Intent("com.android.email.intent.action.sendInBack");  
    String[] reciver = new String[] { "yourname@corp.com" };  
    String subject = "email title";  
    String body = "email body";  
    intent.putExtra(android.content.Intent.EXTRA_EMAIL, reciver[0]);  
    intent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);  
    intent.putExtra(android.content.Intent.EXTRA_TEXT, body);  
      
    startActivityForResult(Intent.createChooser(intent, "send"), 0x02);  
```
#### 处理回调

如果发送成功，会返回Activity.RESULT_OK。
