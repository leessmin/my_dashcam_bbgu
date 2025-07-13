import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

/// 视频处理工具
class VideoProcess {
  static final _videoInfo = FlutterVideoInfo();

  /// 获取视频信息
  static Future<VideoData?> getVideoInfo(File video) async {
    return _videoInfo.getVideoInfo(video.path);
  }

  /// 格式化视频时长
  static Duration videoDurationFormat(double? value) {
    return Duration(milliseconds: (value ?? 0).toInt());
  }

  /// 视频预览图管理器key
  static const _previewCacheMangerKey = "previewCacheManger";

  /// 视频预览图缓存管理器
  static CacheManager previewCacheManger = CacheManager(
    Config(
      _previewCacheMangerKey,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: _previewCacheMangerKey),
    ),
  );
}
