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
}
