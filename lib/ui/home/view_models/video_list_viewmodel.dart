import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/data/repositories/videoDirctory/video_directory_repository.dart';

class VideoListViewModel extends ChangeNotifier {
  VideoListViewModel({
    required VideoDirectoryRepository videoDirectoryRepository,
    required VideoDioRepository videoDioRepository,
  }) : _videoDirectoryRepository = videoDirectoryRepository,
       _videoDioRepository = videoDioRepository {
    getVideoDir();
    getOnlineVideoDir();
  }

  final VideoDirectoryRepository _videoDirectoryRepository;
  final VideoDioRepository _videoDioRepository;

  // 视频目录
  List<VideoDirectory> _videoDirs = [];

  List<VideoDirectory> get videoDirs => _videoDirs;

  // 联网的视频目录
  List<VideoDirResponse> _onlineVideoDirs = [];

  List<VideoDirResponse> get onlineVideoDirs => _onlineVideoDirs;

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

  // 获取联网的视频目录
  Future<void> getOnlineVideoDir() async {
    final result = (await _videoDioRepository.getVideoDir(null));
    if (result.code == 200) {
      _onlineVideoDirs = result.data!;
    }
    notifyListeners();
  }

  // 删除联网的视频目录
  Future<void> deleteOnlineVideoDir(int videoDirId) async {
    await _videoDioRepository.deleteVideoDir(videoDirId);
    getOnlineVideoDir();
  }
}
