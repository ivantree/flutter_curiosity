import 'package:camera/camera.dart';
import 'package:curiosity/main.dart';
import 'package:curiosity/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curiosity/flutter_curiosity.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({Key key, @required this.scanResult}) : super(key: key);

  /// 扫描结果回调
  final ValueChanged<String> scanResult;

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
        backgroundColor: Colors.black,
        body: Center(child: ScannerView(scanResult: scanResult)));
  }
}

class CameraScanPage extends StatefulWidget {
  @override
  _CameraScanPageState createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<CameraScanPage> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  int time;

  Future<void> initCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    CameraDescription description;
    for (final CameraDescription element in cameras) {
      if (element.lensDirection == CameraLensDirection.back)
        description = element;
    }
    if (description == null) return;
    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize();
    setState(() {});
    time = DateTime.now().millisecondsSinceEpoch;
    controller.startImageStream((CameraImage image) async {
      final int now = DateTime.now().millisecondsSinceEpoch;
      if ((now - time) < 5000) return;
      if (image.planes.isEmpty) return;
      if (image.planes[0].bytes.isEmpty) return;
      if (image.format.group != ImageFormatGroup.yuv420) return;
      final ScanResult data = await scanImageMemory(image.planes[0].bytes);
      if (data != null) {
        log('我的二维码');
        log(data.toJson());
        controller?.stopImageStream();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if (controller != null && controller?.value?.aspectRatio != null) {
      child = AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller));
    }
    return OverlayScaffold(
        backgroundColor: Colors.black, body: Center(child: child));
  }

  @override
  Future<void> dispose() async {
    await controller?.stopImageStream();
    await controller?.dispose();
    super.dispose();
  }
}

class UrlImageScanPage extends StatefulWidget {
  @override
  _UrlImageScanPageState createState() => _UrlImageScanPageState();
}

class _UrlImageScanPageState extends State<UrlImageScanPage> {
  TextEditingController controller = TextEditingController();
  String code = '';
  String type = '';

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      appBar: AppBar(title: const Text('San url image')),
      body: Column(children: <Widget>[
        Container(
            margin: const EdgeInsets.all(20),
            child: InputField(
                hintText: '请输入Url',
                helperText: '务必输入正确的url地址',
                focusedBorder: inputBorder(Colors.blueAccent),
                enabledBorder: inputBorder(Colors.blueAccent),
                disabledBorder: inputBorder(Colors.grey),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                controller: controller)),
        RaisedButton(onPressed: () => scan(), child: const Text('识别二维码')),
        showText('code', code),
        showText('type', type),
      ]),
    );
  }

  Future<void> scan() async {
    if (controller.text.isEmpty) return showToast('请输入Url');
    final ScanResult data = await scanImageUrl(controller.text);
    if (data != null) {
      code = data.code;
      type = data.type;
      setState(() {});
    }
  }

  InputBorder inputBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(width: 1, color: color));
  }
}

class FileImageScanPage extends StatefulWidget {
  @override
  _FileImageScanPageState createState() => _FileImageScanPageState();
}

class _FileImageScanPageState extends State<FileImageScanPage> {
  String path = '';
  String code = '';
  String type = '';

  @override
  Widget build(BuildContext context) {
    return OverlayScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      appBar: AppBar(title: const Text('San file image')),
      body: Column(children: <Widget>[
        RaisedButton(onPressed: () => openGallery(), child: const Text('选择图片')),
        const SizedBox(height: 20),
        showText('path', path),
        RaisedButton(onPressed: () => scan(), child: const Text('识别')),
        showText('code', code),
        showText('type', type),
      ]),
    );
  }

  Future<void> scan() async {
    if (path.isEmpty) return showToast('请选择图片');
    if (await Utils.requestPermissions(Permission.storage, '读取文件')) {
      final ScanResult data = await scanImagePath(path);
      if (data != null) {
        code = data.code;
        type = data.type;
        setState(() {});
      }
    }
  }

  Future<void> openGallery() async {
    final String data = await openSystemGallery;
    showToast(data.toString());
    path = data;
    setState(() {});
  }
}
