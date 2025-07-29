import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 全局配置
class GlobalConfiguration {
  // 配置文件存储路径  /data/user/0/com.leessmin.my_dashcam/app_flutter/files/config/config.json
  static Future<String> get configPath async {
    final Directory baseDir = await getApplicationSupportDirectory();
    return p.join(baseDir.path, "config/config.json");
  }

  // 视频存储的文件路径 /data/user/0/com.leessmin.my_dashcam/app_flutter/files/video/
  static Future<String> get videoPath async {
    final Directory baseDir = await getApplicationSupportDirectory();
    final Directory videoDir = Directory("${baseDir.path}/video");

    // 取保目录存在,不存在则创建目录
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }

    return videoDir.path;
  }

  // 服务器地址
  static String get apiUri => "http://100.93.208.87:8080/api";
}
