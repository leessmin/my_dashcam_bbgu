import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/utils/loading_command.dart';

class OnlineDirViewModel extends ChangeNotifier {
  OnlineDirViewModel({
    required VideoDioRepository videoDioRepository,
    required this.deviceId,
  }) : _videoDioRepository = videoDioRepository {
    getOnlineVideoDir();
  }

  final VideoDioRepository _videoDioRepository;
  final String deviceId;

  List<VideoDirResponse> _videoDirs = [];

  List<VideoDirResponse> get videoDirs => _videoDirs;

  LoadingCommand loading = LoadingCommand();

  Future<void> getOnlineVideoDir() async {
    loading.command(() async {
      final result = (await _videoDioRepository.getVideoDir(deviceId));
      if (result.code == 200) {
        _videoDirs = result.data!;
      }
      notifyListeners();
    });
  }

  // 删除联网的视频目录
  Future<void> deleteOnlineVideoDir(int videoDirId) async {
    await _videoDioRepository.deleteVideoDir(videoDirId);
    getOnlineVideoDir();
  }
}
