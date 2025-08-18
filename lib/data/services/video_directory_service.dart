import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/configuration/global_configuration.dart';
import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/data/services/location_service.dart';
import 'package:my_dashcam/data/services/sqlite_videos_service.dart';
import 'package:path/path.dart' as p;

// 视频目录
class VideoDirectoryService {
  final LocationService _locationService = LocationService();
  final SqliteVideosService _sqliteVideosService = SqliteVideosService();

  // 获取所有视频目录
  Future<List<FileSystemEntity>> get _allOriginalVideoDir async {
    final videoParent = Directory(await GlobalConfiguration.videoPath);
    return videoParent.list().toList();
  }

  // 获取目录中的mp4视频
  Future<List<FileSystemEntity>> _getFilterMP4(Directory dir) async {
    final files = await dir.list().toList();
    // 过滤出.mp4文件并按名称排序（可选）
    final mp4Files = files
        .where(
          (file) =>
              file is File && p.extension(file.path).toLowerCase() == '.mp4',
        )
        .toList();
    mp4Files.sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));

    return mp4Files;
  }

  // 读取video目录
  Future<List<VideoDirectory>> get allVideoParentsDir async {
    final videoDirs = <VideoDirectory>[];

    for (var entity in await _allOriginalVideoDir) {
      if (entity is! Directory) {
        continue;
      }

      final mp4List = await _getFilterMP4(entity);

      // 目录
      videoDirs.add(
        VideoDirectory(
          dirName: p.basename(entity.path),
          dirPath: entity.path,
          firstVideoPath: mp4List.firstOrNull?.path,
          count: mp4List.length,
        ),
      );
    }

    videoDirs.sort(
      (a, b) => p.basename(a.dirPath).compareTo(p.basename(b.dirPath)),
    );
    return videoDirs;
  }

  /// 读取某个视频目录下的所有视频
  /// [dirName] 目录名字
  /// @return 视频列表
  Future<List<FileSystemEntity>> getVideos(String dirName) async {
    final videoDir = Directory(
      p.join(await GlobalConfiguration.videoPath, dirName),
    );

    return await _getFilterMP4(videoDir);
  }

  /// 删除视频目录目录
  /// [dirPath] 删除目录的路径
  Future<void> deleteVideoDir(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);

      // 删除视频目录，顺带删除位置文件
      _locationService.deleteLocationFile("${p.basename(dirPath)}.txt");
      // 删除位置信息
      _sqliteVideosService.deleteVideoByDirName(p.basename(dirPath));
    } else {
      debugPrint("$dirPath 目录不存在: $dirPath}");
    }
  }
}
