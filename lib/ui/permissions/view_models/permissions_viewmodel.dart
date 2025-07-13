import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/permissions/permission_repository.dart';
import 'package:my_dashcam/ui/permissions/view_models/permissions_ui_status.dart';

class PermissionsViewModel extends ChangeNotifier {
  PermissionsViewModel({required PermissionRepository permissionRepository})
    : _permissionRepository = permissionRepository {
    getAllPermissionsStatus();
  }

  final PermissionRepository _permissionRepository;

  PermissionsUiStatus? _uiStatus;

  PermissionsUiStatus? get uiStatus => _uiStatus;

  // 获取所有权限的状态
  Future<void> getAllPermissionsStatus() async {
    final result = await Future.wait([
      _permissionRepository.getCamera(),
      _permissionRepository.getMicrophone(),
      _permissionRepository.getLocation(),
      _permissionRepository.getNotification(),
      _permissionRepository.getIgnoreBattery(),
    ]);
    _uiStatus = PermissionsUiStatus(
      camera: result[0],
      microphone: result[1],
      location: result[2],
      notification: result[3],
      ignoreBatteryOptimizations: result[4],
    );
    notifyListeners();
  }

  // 请求摄像头权限
  void requireCamera() {
    _permissionRepository.requireCamera().whenComplete(() async {
      _uiStatus?.camera = await _permissionRepository.getCamera();
      notifyListeners();
    });
  }

  // 请求麦克风权限
  void requireMicrophone() {
    _permissionRepository.requireMicrophone().whenComplete(() async {
      _uiStatus?.microphone = await _permissionRepository.getMicrophone();
      notifyListeners();
    });
  }

  // 请求定位权限
  void requireLocation() {
    _permissionRepository.requireLocation().whenComplete(() async {
      _uiStatus?.location = await _permissionRepository.getLocation();
      notifyListeners();
    });
  }

  // 请求通知状态栏权限
  void requireNotification() {
    _permissionRepository.requireNotification().whenComplete(() async {
      _uiStatus?.notification = await _permissionRepository.getNotification();
      notifyListeners();
    });
  }

  // 请求忽略电池优化权限
  void requireIgnoreBattery() {
    _permissionRepository.requireIgnoreBattery().whenComplete(() async {
      _uiStatus?.ignoreBatteryOptimizations = await _permissionRepository
          .getIgnoreBattery();
      notifyListeners();
    });
  }
}
