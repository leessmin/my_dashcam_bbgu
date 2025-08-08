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

  // 通过目录id获取目录下的所有视频
  Future<Response<List<VideoResponse>>> getVideos(int dirId) async {
    try {
      final response = await (await authFetch)?.get(
        "/video/list?dir_id=$dirId",
      );

      return Response.fromJson(
        response?.data,
        (json) => List<VideoResponse>.from(
          (json as List).map(
            (item) => VideoResponse.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );
    } catch (err) {
      return Response.defaultResponse([]);
    }
  }

  // 目录详细信息
  Future<Response<VideoDirResponse?>> videoDirInfo(int videoDirId) async {
    try {
      final response = await (await authFetch)?.get(
        "/video/video_dir_info?video_dir_id=$videoDirId",
      );

      return Response.fromJson(
        response?.data,
        (json) => VideoDirResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (err) {
      return Response.defaultResponse(null);
    }
  }

  // 视频播放地址
  Future<Uri> videoPlayUri(int videoId) async {
    final baseUri = Uri.parse((await authFetch)!.options.baseUrl);
    return baseUri.replace(path: "${baseUri.path}/video/get_video/$videoId");
  }
}
