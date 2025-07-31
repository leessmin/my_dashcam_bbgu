import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dashcam/data/repositories/locationDio/location_dio_repository.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/models/video.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/sqlite_videos_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';

// 原生平台调用flutter

class FlutterChannel {
  const FlutterChannel({
    required SqliteVideosRepository sqliteVideosRepository,
    required VideoDioRepository videoDioRepository,
    required LocationDioRepository locationDioRepository,
  }) : _sqliteVideosRepository = sqliteVideosRepository,
       _videoDioRepository = videoDioRepository,
       _locationDioRepository = locationDioRepository;

  final SqliteVideosRepository _sqliteVideosRepository;
  final VideoDioRepository _videoDioRepository;
  final LocationDioRepository _locationDioRepository;

  static final _flutterMethodChannel = MethodChannel(
    "com.leessmin.my_dashcam/flutter_channel",
  );

  void startFlutterMethodChannel() {
    Map<String, Future<String> Function(dynamic)> methods = {
      "recordedVideo": _recordedVideo,
      "deletedVideo": _deletedVideo,
      "uploadLocationFile": _uploadLocationFile,
    };

    _flutterMethodChannel.setMethodCallHandler((MethodCall call) async {
      methods[call.method]?.call(call.arguments);
    });
  }

  // 视频录制完成
  Future<String> _recordedVideo(args) async {
    await _sqliteVideosRepository.insertVideo(
      Video(dirName: args["dirName"], videoPath: args["videoPath"], upload: 0),
    );

    // 上传视频
    final result = await _videoDioRepository.uploadVideo(
      args["dirName"],
      args["videoPath"],
    );

    if (result.code == 200) {
      _sqliteVideosRepository.updateUpload(args["videoPath"]);
    }

    return "ok";
  }

  // 删除本地视频
  Future<String> _deletedVideo(args) async {
    await _sqliteVideosRepository.deleteVideo(args['videoPath']);

    return "ok";
  }

  // 上传地理位置
  Future<String> _uploadLocationFile(args) async {
    _locationDioRepository.uploadLocation(args['path']);

    return "ok";
  }
}
