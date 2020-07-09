import 'package:flutter_curiosity/constant/Constant.dart';import 'package:flutter_curiosity/flutter_curiosity.dart';import 'package:flutter_curiosity/tools/InternalTools.dart';class NativeTools {  ///安装apk  仅支持android  static void installApp(String apkPath) async {    InternalTools.supportPlatform();    if (InternalTools.isAndroid()) {      await curiosityChannel.invokeMethod('installApp', {'apkPath': apkPath});    }  }  ///获取文件夹或文件大小  static Future<String> getFilePathSize(String path) async {    InternalTools.supportPlatform();    return await curiosityChannel        .invokeMethod('getFilePathSize', {'filePath': path});  }  ///解压文件  static void unZipFile(String filePath) async {    InternalTools.supportPlatform();    await curiosityChannel.invokeMethod('unZipFile', {'filePath': filePath});  }  ///去应用市场 android 安装多个应用商店时会弹窗选择，ios app store  ///The android platform "marketPackageName" cannot be null  static void goToMarket(String packageName, [String marketPackageName]) async {    InternalTools.supportPlatform();    if (InternalTools.isIOS()) {      await curiosityChannel          .invokeMethod('goToMarket', {'packageName': packageName});    } else if (InternalTools.isAndroid()) {      if (marketPackageName == null)        return await curiosityChannel.invokeMethod('goToMarket', {          'packageName': packageName,          'marketPackageName': marketPackageName        });    }  }  ///是否安装某个app  仅支持android  static Future isInstallApp(String packageName) async {    InternalTools.supportPlatform();    if (InternalTools.isAndroid()) {      return await curiosityChannel          .invokeMethod('isInstallApp', {'packageName': packageName});    }  }  ///退出app  static void exitApp() async {    InternalTools.supportPlatform();    await curiosityChannel.invokeMethod('exitApp');  }  ///拨打电话  ///directDial true 直接拨打电话 false 跳转到拨号页面并输入手机号  ///directDial 为 true 需要 自行申请动态申请权限  static void callPhone(String phoneNumber, {bool directDial: false}) async {    InternalTools.supportPlatform();    await curiosityChannel.invokeMethod(        'callPhone', {'phoneNumber': phoneNumber, 'directDial': directDial});  }  ///系统分享  static void systemShare(      {String title: 'Share',      String content,      List<String> imagesPath,      ShareType shareType}) async {    InternalTools.supportPlatform();    if (shareType == null) return Future.error('The shareType cannot be empty');    if (shareType == ShareType.images) {      if (imagesPath == null || imagesPath.length == 0) {        return Future.error('The shareType cannot be empty');      }    }    if (content == null && imagesPath == null) {      return Future.error(          'A share parameter must be passed content or imagesPath');    }    if (content != null && imagesPath != null) {      return Future.error('Only one parameter can be passed');    }    await curiosityChannel.invokeMethod('systemShare', {      'title': title,      'content': content,      'type': shareType.toString().split('.')[1],      'imagesPath': imagesPath    });  }  ///判断GPS是否开启，GPS或者AGPS开启一个就认为是开启的  static Future<bool> getGPSStatus() async {    InternalTools.supportPlatform();    return await curiosityChannel.invokeMethod('getGPSStatus');  }  /// 跳转到设置页面让用户自己手动开启  static Future jumpGPSSetting() async {    InternalTools.supportPlatform();    await curiosityChannel.invokeMethod('jumpGPSSetting');  }}