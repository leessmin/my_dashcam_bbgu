import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';

class OnlineDirViewModel extends ChangeNotifier {
  OnlineDirViewModel({
    required VideoDioRepository videoDioRepository,
    required String deviceId,
  }) : _videoDioRepository = videoDioRepository,
       _deviceId = deviceId {
    getOnlineVideoDir(deviceId);
  }

  final VideoDioRepository _videoDioRepository;
  final String _deviceId;

  List<VideoDirResponse> _videoDirs = [];

  List<VideoDirResponse> get videoDirs => _videoDirs;

  Future<void> getOnlineVideoDir(String deviceId) async {
    final result = (await _videoDioRepository.getVideoDir(deviceId));
    if (result.code == 200) {
      _videoDirs = result.data!;
    }
    notifyListeners();
  }

  // 删除联网的视频目录
  Future<void> deleteOnlineVideoDir(int videoDirId) async {
    await _videoDioRepository.deleteVideoDir(videoDirId);
    getOnlineVideoDir(_deviceId);
  }
}
