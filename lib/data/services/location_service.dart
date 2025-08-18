import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/configuration/global_configuration.dart';

class LocationService {
  /// 删除位置文件
  /// [filename] 文件名
  Future<void> deleteLocationFile(String filename) async {
    final locationDirPath = await GlobalConfiguration.locationPath;

    final file = File("$locationDirPath/$filename");

    if (await file.exists()) {
      await file.delete();
    } else {
      debugPrint("${file.path} 文件不存在!!!");
    }
  }
}
