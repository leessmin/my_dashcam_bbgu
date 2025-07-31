import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/models/video.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/sqlite_videos_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';

// 原生平台调用flutter

class FlutterChannel {
  const FlutterChannel({
    required SqliteVideosRepository sqliteVideosRepository,
    required VideoDioRepository videoDioRepository,
  }) : _sqliteVideosRepository = sqliteVideosRepository,
       _videoDioRepository = videoDioRepository;

  final SqliteVideosRepository _sqliteVideosRepository;
  final VideoDioRepository _videoDioRepository;

  static final _flutterMethodChannel = MethodChannel(
    "com.leessmin.my_dashcam/flutter_channel",
  );

  void startFlutterMethodChannel() {
    Map<String, Future<String> Function(dynamic)> methods = {
      "recordedVideo": _recordedVideo,
      "deletedVideo": _deletedVideo,
    };

    _flutterMethodChannel.setMethodCallHandler((MethodCall call) async {
      methods[call.method]?.call(call.arguments);
    });
  }

  // 视频录制完成
  Future<String> _recordedVideo(args) async {
    debugPrint("收到平台调用,参数: $args");

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
    debugPrint("删除视频路径: ${args['videoPath']}");

    await _sqliteVideosRepository.deleteVideo(args['videoPath']);

    return "ok";
  }
}
