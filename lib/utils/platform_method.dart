import 'package:flutter/services.dart';
import 'package:my_dashcam/domain/models/camera_activity_options.dart';

const _platformMethodChannel = MethodChannel("com.leessmin.my_dashcam");

/// 启动原生 CameraActivity
Future<void> launchCameraActivity(CameraActivityOptions option) async {
  await _platformMethodChannel.invokeMethod('launchCameraActivity', option.toMap());
}
