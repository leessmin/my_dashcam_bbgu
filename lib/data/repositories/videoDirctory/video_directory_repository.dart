import 'dart:io';

import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/data/services/video_directory_service.dart';

class VideoDirectoryRepository {
  VideoDirectoryRepository({
    required VideoDirectoryService videoDirectoryService,
  }) : _videoDirectoryService = videoDirectoryService;

  final VideoDirectoryService _videoDirectoryService;

  /// 读取所有video目录
  Future<List<VideoDirectory>> getVideoParentDirs() =>
      _videoDirectoryService.allVideoParentsDir;

  /// 读取所有video目录, 倒序
  Future<List<VideoDirectory>> getVideoParentDirsReversal() async =>
      (await _videoDirectoryService.allVideoParentsDir).reversed.toList();

  /// 读取某个video下的所有视频
  Future<List<FileSystemEntity>> getVideos(String dirName) =>
      _videoDirectoryService.getVideos(dirName);

  /// 删除某个目录
  Future<void> deleteVideoDir(String dirPath) =>
      _videoDirectoryService.deleteVideoDir(dirPath);
}
