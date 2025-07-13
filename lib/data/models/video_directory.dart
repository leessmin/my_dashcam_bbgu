

/// 视频目录
class VideoDirectory {
  VideoDirectory({
    required this.dirName,
    required this.dirPath,
    required this.firstVideoPath,
    required this.count,
  });

  // 目录名字
  final String dirName;

  // 目录路径
  final String dirPath;

  // 第一个视频的路径
  final String? firstVideoPath;

  // 视频数量
  final int count;
}
