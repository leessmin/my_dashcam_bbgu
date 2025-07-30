import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/data/repositories/configuration/configuration_repository.dart';
import 'package:my_dashcam/data/repositories/permissions/permission_repository.dart';
import 'package:my_dashcam/data/repositories/videoDirctory/video_directory_repository.dart';
import 'package:my_dashcam/domain/models/camera_activity_options.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this.configurationRepository,
    required this.permissionRepository,
    required this.videoDirectoryRepository,
  }) {
    requirePermissionAll();
  }

  final ConfigurationRepository configurationRepository;
  final PermissionRepository permissionRepository;
  final VideoDirectoryRepository videoDirectoryRepository;

  // 获取所有权限
  Future<void> requirePermissionAll() async {
    await permissionRepository.requirePermissionAll();
  }

  // 获取相机Activity配置
  Future<CameraActivityOptions> getCameraOption() async {
    return (await configurationRepository.getConfiguration())
        .toCameraActivityOption();
  }
}
