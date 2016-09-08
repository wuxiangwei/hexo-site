---
title: ADT extensions
date: 2015-01-01 12:48:31
category: [Android]
tags: [Android, Eclipse, ADT]
toc: true
---
## Introduction
![Alt text] (adt_ext_new_activity.png?200)

Quickly new Activity/Service/BroadcastReceiver/ContentProvider in Android Project with a wizard and configurate in AndroidManifest.xml.

Main function list:
  - New Activity/Service/BroadcastReceiver.
  - Customize action and category for intent-filter.
  - New ContentProvider.
  - Customize authorities for ContentProvider.

<!-- more -->

Notes:
  * The publish version is based on Eclipse development version, 3.5 is the initial version.
  * This plugin is developed under Eclipse 3.5 + JDK 1.5.
  * Test under jdk 1.5 + eclipse 3.5 Win(32bit) OS and jre 1.6 + eclipse 3.6 Linux(64bit) OS

## Install
### Marketplace client
  - Click "Help->Marketplace" in Eclipse
  - Search "ADT " as keyword to find "Android ADT extentions" plugin in result.
  - Click "Install"

### Local update site
  - Click Help->Install New Software... in Eclipse to open install page
  - Input "http://ieclipse.cn/updates/adt-ext" press "Enter" key
  - Select ADT extentions feature to install after pending

### Local update site
  * Click Help->Install New Software... in Eclipse to open install page
  * Click "Add..." button open add site dialog
  * Click "Archive..." button to select .zip file.
  * Click "OK" back to install page
  * Select ADT extentions feature to install

## Tutorial
 ### New Activity
   -  Choose a package right click and select "New->Others" in popups menu.
   -  Select New Activity under Android category.(If you work in java perspective, New Activity would be visible popups menu.) to open wizard page.
   -  Check "with super suffix" to add super suffix to type name.(such with a Activity suffix)
   -  Select methos stubs which you want to create.
   -  Click "Add..." to add System action/category
   -  Click "Remove..." to remove selected action/category
   -  Click "Add custom" in popups to add custom action/category
   -  Click "Up/Down" to sort selected action/category
   -  Double click to edit seleted action/category 

### New Provider
   -  See New Activity steps to open New Provider wizard page
   -  Input authorities for provider 

## Screenshot

see <https://Jamling.github.com/adt-extensions/wiki/Screenshot>.

## Reference

https://Jamling.github.com/adt-extensions