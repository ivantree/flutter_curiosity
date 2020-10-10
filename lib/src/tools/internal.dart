import 'dart:io';import 'dart:ui';import 'package:flutter/foundation.dart';import 'package:flutter/material.dart';import 'package:flutter_curiosity/flutter_curiosity.dart';bool isDebug() => !kReleaseMode;bool isAndroid() => Platform.isAndroid;bool isIOS() => Platform.isIOS;bool isMacOS() => Platform.isMacOS;bool isWindows() => Platform.isWindows;bool isLinux() => Platform.isLinux;bool isFuchsia() => Platform.isFuchsia;class InternalTools {  ///size → Size 设备尺寸信息，如屏幕的大小，单位 pixels  static Size getSize() => MediaQueryData.fromWindow(window).size;  ///devicePixelRatio → double 单位逻辑像素的设备像素数量，即设备像素比。这个数字可能不是2的幂，实际上它甚至也可能不是整数。例如，Nexus 6的设备像素比为3.5。  static double getDevicePixelRatio() => MediaQueryData.fromWindow(window).devicePixelRatio;  static bool supportPlatform() {    if (!(isAndroid() || isIOS() || isMacOS())) {      log('Curiosity is not support ${Platform.operatingSystem}');      return true;    }    return false;  }  static CameraLensFacing getCameraLensFacing(String lensFacing) {    switch (lensFacing) {      case 'back':        return CameraLensFacing.back;      case 'front':        return CameraLensFacing.front;      case 'external':        return CameraLensFacing.external;      default:        return null;    }  }}const int _limitLength = 800;void log(dynamic msg) {  final String message = msg.toString();  if (isDebug()) {    if (message.length < _limitLength) {      print(msg);    } else {      _segmentationLog(message);    }  }}void _segmentationLog(String msg) {  final StringBuffer outStr = StringBuffer();  for (int index = 0; index < msg.length; index++) {    outStr.write(msg[index]);    if (index % _limitLength == 0 && index != 0) {      print(outStr);      outStr.clear();      final int lastIndex = index + 1;      if (msg.length - lastIndex < _limitLength) {        final String remainderStr = msg.substring(lastIndex, msg.length);        print(remainderStr);        break;      }    }  }}