import 'package:flutter/material.dart';
import 'package:my_dashcam/data/services/video_export_service.dart';

/// 视频导出
class VideoExportRepository {
  VideoExportRepository({required VideoExportService videoExportService})
    : _videoExportService = videoExportService;

  final VideoExportService _videoExportService;

  ValueNotifier<String> get exportProgress =>
      _videoExportService.exportProgress;

  /// 导出视频一个一个导出
  Future<void> exportVideosOneByOne(List<String> videos) =>
      _videoExportService.exportVideosOneByOne(videos);

  /// 导出视频并合并
  Future<void> exportVideosMerge(List<String> videos) =>
      _videoExportService.exportVideosMerge(videos);
}
