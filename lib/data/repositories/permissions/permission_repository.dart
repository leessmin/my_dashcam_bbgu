import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  // 申请全部权限
  Future<void> requirePermissionAll() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.notification,
      Permission.ignoreBatteryOptimizations,
    ].request();
  }

  // 获取摄像头权限状态  拥有权限返回true
  Future<bool> getCamera() async {
    final status = await Permission.camera.status;
    return !status.isDenied;
  }

  // 获取麦克风权限状态  拥有权限返回true
  Future<bool> getMicrophone() async {
    final status = await Permission.microphone.status;
    return !status.isDenied;
  }

  // 获取定位权限状态  拥有权限返回true
  Future<bool> getLocation() async {
    final status = await Permission.location.status;
    return !status.isDenied;
  }

  // 获取通知权限状态  拥有权限返回true
  Future<bool> getNotification() async {
    final status = await Permission.notification.status;
    return !status.isDenied;
  }

  // 是否忽略电池优化权限
  Future<bool> getIgnoreBattery() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    return !status.isDenied;
  }

  // 请求摄像头权限
  Future<void> requireCamera() async {
    await Permission.camera.request();
  }

  // 请求麦克风权限
  Future<void> requireMicrophone() async {
    await Permission.microphone.request();
  }

  // 请求获取定位权限
  Future<void> requireLocation() async {
    await Permission.location.request();
  }

  // 请求通知栏权限
  Future<void> requireNotification() async {
    await Permission.notification.request();
  }

  // 请求忽略电池优化权限
  Future<void> requireIgnoreBattery() async {
    await Permission.ignoreBatteryOptimizations.request();
  }
}
