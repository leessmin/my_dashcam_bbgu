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

  // 位置文件存储路径
  // /data/user/0/com.leessmin.my_dashcam/app_flutter/files/location/
  static Future<String> get locationPath async {
    final Directory baseDir = await getApplicationSupportDirectory();
    final Directory locationDir = Directory("${baseDir.path}/location");

    // 确保目录存在，不存在则创建目录
    if (!await locationDir.exists()) {
      await locationDir.create(recursive: true);
    }
    return locationDir.path;
  }

  // 服务器地址
  // static String get apiUri => "http://100.93.208.87:8080/api";
  static String get apiUri => "http://47.107.183.144:8080/api";

  // 高德地图sdk
  static String get amapApiKeys => "0f9a5bd4b6fa8f39380818bbb4913d4d";
}
