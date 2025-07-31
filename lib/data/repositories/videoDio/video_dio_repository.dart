import 'package:dio/dio.dart' hide Response;
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';

class VideoDioRepository {
  // 上传视频
  Future<Response<String?>> uploadVideo(
    String dirName,
    String videoPath,
  ) async {
    try {
      final fromData = FormData.fromMap({
        "dir": dirName,
        "video": await MultipartFile.fromFile(videoPath),
      });

      final response = await (await authFetch)?.post(
        "/video/upload",
        data: fromData,
      );

      return Response.fromJson(response?.data, (json) => null);
    } catch (_) {
      return Response.defaultResponse(null);
    }
  }
}
