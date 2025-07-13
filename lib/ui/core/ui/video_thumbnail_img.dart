import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:my_dashcam/utils/video_process.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// 视频缩略图，带缓存
class VideoThumbnailImg extends StatelessWidget {
  const VideoThumbnailImg({
    super.key,
    required this.videoPath,
    this.height = 72,
    this.width = 128,
    this.quality = 20,
    this.timeMs = 1000,
  });

  /// 视频路径
  final String videoPath;

  /// 图片高度 默认 72
  final double height;

  /// 图片宽度 默认128
  final double width;

  /// 图像质量 默认20
  final int quality;

  /// 从何开始获取视频缩略图 默认1s后
  final int timeMs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getThumbnail(
        videoPath: videoPath,
        height: height.toInt(),
        quality: quality,
        timeMs: timeMs,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Image(
            image: AssetImage("assets/images/image-loading.png"),
            height: height,
            width: width,
          );
        }

        final bytes = snapshot.data!;

        return Image.memory(
          bytes,
          height: height,
          width: width,
          gaplessPlayback: true,
        );
      },
    );
  }

  /// 获取缩略图,带缓存
  Future<Uint8List?> _getThumbnail({
    required String videoPath,
    required int height,
    required int quality,
    required int timeMs,
  }) async {
    final cacheKey = "${videoPath}_${height}_$quality";

    final FileInfo? cacheFile = await VideoProcess.previewCacheManger
        .getFileFromCache(cacheKey);
    if (cacheFile != null) {
      return await cacheFile.file.readAsBytes();
    }

    final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.WEBP,
      maxHeight: height,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: quality,
      timeMs: timeMs,
    );

    if (thumbnailData != null) {
      VideoProcess.previewCacheManger.putFile(
        cacheKey,
        thumbnailData,
        key: cacheKey,
      );
    }

    return thumbnailData;
  }
}
