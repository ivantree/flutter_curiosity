import 'dart:io';import 'package:flutter_curiosity/constant/Constant.dart';import 'package:flutter_curiosity/utils/Utils.dart';class NativeUtils {  //清楚cookie  static clearAllCookie() async {    Utils.supportPlatform();    await methodChannel.invokeMethod('clearAllCookie');  }  //获取cookie  static Future getAllCookie(String url) async {    Utils.supportPlatform();    return await methodChannel.invokeMethod('getAllCookie', {'url': url});  }  //安装apk  仅支持android  static installApp(String apkPath) async {    Utils.supportPlatform();    if (Platform.isAndroid) {      await methodChannel.invokeMethod('installApp', {'apkPath': apkPath});    }  }  //获取文件夹或文件大小  static Future getFilePathSize(String path) async {    Utils.supportPlatform();    return await methodChannel.invokeMethod('getFilePathSize', {'filePath': path});  }  //删除目录  static deleteDirectory(String directoryPath) async {    Utils.supportPlatform();    await methodChannel.invokeMethod('deleteDirectory', {'directoryPath': directoryPath});  }  //删除文件  static deleteFile(String filePath) async {    Utils.supportPlatform();    await methodChannel.invokeMethod('deleteFile', {'filePath': filePath});  }  //解压文件  static unZipFile(String filePath) async {    Utils.supportPlatform();    await methodChannel.invokeMethod('unZipFile', {'filePath': filePath});  }  //去应用市场 android 安装多个应用商店时会弹窗选择，ios app store  // The android platform "marketPackageName" cannot be null  static goToMarket(String packageName, [String marketPackageName]) async {    Utils.supportPlatform();    if (Platform.isIOS) {      await methodChannel.invokeMethod('goToMarket', {'packageName': packageName});    } else if (Platform.isAndroid) {      if (marketPackageName == null) return        await methodChannel.invokeMethod('goToMarket', {'packageName': packageName, 'marketPackageName': marketPackageName});    }  }  //是否安装某个app  仅支持android  static Future isInstallApp(String packageName) async {    Utils.supportPlatform();    if (Platform.isAndroid) {      return await methodChannel.invokeMethod('isInstallApp', {'packageName': packageName});    }  }  //退出app  static exitApp() async {    Utils.supportPlatform();    await methodChannel.invokeMethod('exitApp');  }  //拨打电话  //自行申请动态申请权限  static callPhone(String phoneNumber, {bool directDial: false}) async {    Utils.supportPlatform();    await methodChannel.invokeMethod('callPhone', {'phoneNumber': phoneNumber, 'directDial': directDial});  }  //启动外部浏览器并打开url  //android browserPackageName 打开指定浏览器的包名 browserClassName 指定浏览器的activity  static openUrl(String url, {String browserPackageName, String browserClassName}) async {    Utils.supportPlatform();    await methodChannel.invokeMethod('openUrl');  }}