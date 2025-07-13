import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/configuration/global_configuration.dart';
import 'package:my_dashcam/data/models/configuration.dart';

/// 配置文件 service
class ConfigurationService {
  ConfigurationService();

  // 获取配置文件
  Future<File> get _getConfigFile async {
    final file = File(await GlobalConfiguration.configPath);
    if (!file.existsSync()) {
      // 文件不存在
      file.createSync(recursive: true);
      write(jsonEncode(Configuration.defaultConf().toJson()));
    }
    return file;
  }

  // 读取配置
  Future<String> read() async {
    try {
      final file = await _getConfigFile;
      return await file.readAsString();
    } catch (e) {
      debugPrint("ConfigurationService::read: ${e.toString()}");
      return jsonEncode(Configuration.defaultConf().toJson());
    }
  }

  // 写入配置
  Future<void> write(String content) async {
    final file = await _getConfigFile;
    await file.writeAsString(content);
  }
}
