import 'package:my_dashcam/data/services/models/video.dart';
import 'package:my_dashcam/data/services/sqlite_videos_service.dart';

class SqliteVideosRepository {
  final SqliteVideosService _service = SqliteVideosService();

  Future<void> insertVideo(Video video) => _service.insertVideo(video);

  // 更新upload字段为1
  Future<void> updateUpload(String videoPath) =>
      _service.updateUpload(videoPath);

  // 删除视频通过视频路径
  Future<void> deleteVideo(String videPath) => _service.deleteVideo(videPath);

  // 删除视频通过dir_name
  Future<void> deleteVideoByDirName(String dirName) =>
      _service.deleteVideoByDirName(dirName);

  // 获取上传失败的文件列表
  Future<List<Video>> getUploadFailedVideos() =>
      _service.getUploadFailedVideos();
}
