import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? database;

// 获取数据库实例
Future<Database> getDB() async {
  database ??= await openDatabase(
      join(await getDatabasesPath(), 'my_dashcam_bbgu.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
        CREATE TABLE videos (
	        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	        dir_name TEXT NOT NULL,
	        video_path TEXT NOT NULL,
	        upload INTEGER NOT NULL
        );
      """);
      },
    );

  return database!;
}
