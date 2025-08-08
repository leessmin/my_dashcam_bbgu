import 'dart:io';

import 'package:dio/dio.dart' hide Response;
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';
import 'package:path_provider/path_provider.dart';

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

  // 下载视频到手机相册
  Future<void> downloadVideo(VideoResponse video) async {
    final tempDir = await getTemporaryDirectory();
    final tempVideoPath = "${tempDir.path}/${video.videoName}";

    await (await authFetch)?.download(
      "/video/get_video/${video.id}",
      tempVideoPath,
    );

    await GallerySaver.saveVideo(tempVideoPath);

    // 删除临时视频文件
    final tempVideo = File(tempVideoPath);
    await tempVideo.delete();
  }

  // 合并视频并下载
  Future<void> downloadConcatVideo(
    List<int> ids, {
    required void Function(String) progressFn,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final tempVideoPath =
        "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch ~/ 1000}.mp4";

    await (await authFetch)?.download(
      "/video/concat?${ids.map((id) => "ids=$id").join("&")}",
      tempVideoPath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          double progress = received / total * 100;
          progressFn(progress.toStringAsFixed(2));
        }
      },
    );

    await GallerySaver.saveVideo(tempVideoPath);

    // 删除临时视频文件
    final tempVideo = File(tempVideoPath);
    await tempVideo.delete();
  }

  // 视频播放地址
  Future<Uri> videoPlayUri(int videoId) async {
    final baseUri = Uri.parse((await authFetch)!.options.baseUrl);
    return baseUri.replace(path: "${baseUri.path}/video/get_video/$videoId");
  }
}
