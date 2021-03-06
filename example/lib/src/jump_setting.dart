import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';

class JumpSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    children.add(ElevatedButton(
        onPressed: () => jumpAppSetting, child: const Text('跳转APP设置')));
    children.addAll(SettingType.values
        .map((SettingType value) => ElevatedButton(
            onPressed: () => jumpSystemSetting(settingType: value),
            child: Text(value.toString())))
        .toList());
    return OverlayScaffold(
        appBar: AppBar(title: const Text('Android Jump Setting')),
        body: Universal(isScroll: true, children: children));
  }
}
