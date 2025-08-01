import 'package:dio/dio.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationDioRepository {
  // 存储上传失败的位置文件 pref key
  final String _failedListKey = "location-failed";
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // 上传地理位置信息
  Future<Response<String?>> uploadLocation(String filePath) async {
    try {
      debugPrint("上传location file: $filePath");
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
      });

      final response = await (await authFetch)?.post(
        "/location/upload",
        data: formData,
      );

      return Response.fromJson(response?.data, (json) => null);
    } catch (_) {
      return Response.defaultResponse(null);
    }
  }

  // 存储失败的位置文件
  void putFailedLocation(String value) async {
    final list = await getFailedLocation();
    list.add(value);
    _prefs.setStringList(_failedListKey, list);
  }

  // 获取 FailedLocation
  Future<List<String>> getFailedLocation() async {
    return (await _prefs.getStringList(_failedListKey)) ?? [];
  }

  // 清空 FailedLocation
  Future<void> cleanFailedLocation() async {
    await _prefs.remove(_failedListKey);
  }

  // 删除某个failedLocation
  Future<void> removeFailedLocation(String val) async {
    final list = await getFailedLocation();
    list.remove(val);
    _prefs.setStringList(_failedListKey, list);
  }
}
