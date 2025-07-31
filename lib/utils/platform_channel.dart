import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 原生平台调用flutter

const _flutterMethodChannel = MethodChannel(
  "com.leessmin.my_dashcam/flutter_channel",
);

Map<String, Future<String> Function(dynamic)> methods = {"recordedVideo": _recordedVideo};

void startFlutterMethodChannel() {
  _flutterMethodChannel.setMethodCallHandler((MethodCall call) async {
    methods[call.method]?.call(call.arguments);
  });
}

// 视频录制完成
Future<String> _recordedVideo(args) async {
  debugPrint("收到平台调用,参数: $args");
  return "ok";
}
