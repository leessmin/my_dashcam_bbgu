import 'package:my_dashcam/data/repositories/sqliteVideo/models/video.dart';
import 'package:my_dashcam/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class SqliteVideosRepository {
  final String _table = "videos";

  Future<void> insertVideo(Video video) async {
    final db = await getDB();

    await db.insert(
      _table,
      video.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 更新upload字段为1
  Future<void> updateUpload(String videoPath) async {
    final db = await getDB();
    await db.rawUpdate("UPDATE $_table SET upload = ? WHERE video_path = ?", [
      1,
      videoPath,
    ]);
  }

  // 删除视频通过视频路径
  Future<void> deleteVideo(String videPath) async {
    final db = await getDB();
    await db.delete(_table, where: "video_path = ?", whereArgs: [videPath]);
  }

  // 获取上传失败的文件列表
  Future<List<Video>> getUploadFailedVideos() async {
    final db = await getDB();
    List<Map<String, dynamic>> maps = await db.query(
      _table,
      where: "upload = ?",
      whereArgs: [0],
    );

    return maps.map((val) => Video.fromJson(val)).toList();
  }
}
