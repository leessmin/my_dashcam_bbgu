import 'dart:io';

import 'package:easy_video_editor/easy_video_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

/// 视频导出
class VideoExportService {
  /// 导出进度
  final ValueNotifier<String> exportProgress = ValueNotifier("0");

  /// 导出视频, 一个一个导出
  /// [videos] 需要导出的视频路径
  Future<void> exportVideosOneByOne(List<String> videos) async {
    for (var (idx, video) in videos.indexed) {
      final _ = await GallerySaver.saveVideo(video);
      exportProgress.value = ((idx / videos.length) * 100).round().toString();
    }
  }

  /// 导出并合并视频
  Future<void> exportVideosMerge(List<String> videos) async {
    final editor = VideoEditorBuilder(
      videoPath: videos[0],
    ).merge(otherVideoPaths: videos.sublist(1));

    final Directory tempDir = await getTemporaryDirectory();
    final tempVideoPath =
        "${tempDir.path}/mergeVideo_${DateTime.now().millisecondsSinceEpoch}.mp4";

    await editor.export(
      outputPath: tempVideoPath,
      onProgress: (progress) {
        exportProgress.value = (progress * 100).toStringAsFixed(1);
      },
    );

    await GallerySaver.saveVideo(tempVideoPath);

    await File(tempVideoPath).delete();
  }
}
