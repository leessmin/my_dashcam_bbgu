import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/data/repositories/configuration/configuration_repository.dart';
import 'package:my_dashcam/data/repositories/permissions/permission_repository.dart';
import 'package:my_dashcam/data/repositories/videoDirctory/video_directory_repository.dart';
import 'package:my_dashcam/domain/models/camera_activity_options.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ConfigurationRepository configurationRepository,
    required PermissionRepository permissionRepository,
    required VideoDirectoryRepository videoDirectoryRepository,
  })
      : _configurationRepository = configurationRepository,
        _permissionRepository = permissionRepository,
        _videoDirectoryRepository = videoDirectoryRepository {
    requirePermissionAll();
    getVideoDir();
  }

  final ConfigurationRepository _configurationRepository;
  final PermissionRepository _permissionRepository;
  final VideoDirectoryRepository _videoDirectoryRepository;

  // 视频目录
  List<VideoDirectory> _videoDirs = [];

  List<VideoDirectory> get videoDirs => _videoDirs;

  // 获取相机Activity配置
  Future<CameraActivityOptions> getCameraOption() async {
    return (await _configurationRepository.getConfiguration())
        .toCameraActivityOption();
  }

  // 获取所有权限
  Future<void> requirePermissionAll() async {
    await _permissionRepository.requirePermissionAll();
  }

  // 获取视频目录
  Future<void> getVideoDir() async {
    _videoDirs = await _videoDirectoryRepository.getVideoParentDirsReversal();
    notifyListeners();
  }

  // 删除视频目录
  Future<void> deleteVideoDir(String dirPath) async {
    await _videoDirectoryRepository.deleteVideoDir(dirPath);
    getVideoDir();
  }
}
