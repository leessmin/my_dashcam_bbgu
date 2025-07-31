import 'package:dio/dio.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';

class LocationDioRepository {
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
}
