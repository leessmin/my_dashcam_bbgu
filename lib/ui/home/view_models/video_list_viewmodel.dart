import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/data/repositories/videoDirctory/video_directory_repository.dart';

class VideoListViewModel extends ChangeNotifier {
  VideoListViewModel({
    required VideoDirectoryRepository videoDirectoryRepository,
  }) : _videoDirectoryRepository = videoDirectoryRepository {
    getVideoDir();
  }

  final VideoDirectoryRepository _videoDirectoryRepository;

  // 视频目录
  List<VideoDirectory> _videoDirs = [];

  List<VideoDirectory> get videoDirs => _videoDirs;

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
