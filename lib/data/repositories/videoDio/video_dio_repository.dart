import 'package:dio/dio.dart' hide Response;
import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';

class VideoDioRepository {
  // 上传视频
  Future<Response<String?>> uploadVideo(
    String dirName,
    String videoPath,
  ) async {
    try {
      final formData = FormData.fromMap({
        "dir": dirName,
        "video": await MultipartFile.fromFile(videoPath),
      });

      final response = await (await authFetch)?.post(
        "/video/upload",
        data: formData,
      );

      return Response.fromJson(response?.data, (json) => null);
    } catch (_) {
      return Response.defaultResponse(null);
    }
  }

  // 获取视频目录
  Future<Response<List<VideoDirResponse>?>> getVideoDir(
    String? deviceId,
  ) async {
    try {
      final uri = deviceId == null
          ? "/video/video_dir_list"
          : "/video/video_dir_list?deviceId=$deviceId";
      final response = await (await authFetch)?.get(uri);

      return Response.fromJson(
        response?.data,
        (json) => List<VideoDirResponse>.from(
          (json as List).map(
            (item) => VideoDirResponse.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );
    } catch (err) {
      debugPrint("err: $err");
      return Response.defaultResponse(null);
    }
  }

  // 删除视频目录
  Future<Response<String?>> deleteVideoDir(int videoDirId) async {
    try {
      final response = await (await authFetch)?.delete(
        "/video/delete_video_dir?video_dir_id=$videoDirId",
      );

      return Response.fromJson(response?.data, (json) => null);
    } catch (err) {
      return Response.defaultResponse(null);
    }
  }
}
