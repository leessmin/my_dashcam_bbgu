import 'package:dio/dio.dart' hide Response;
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/loginRegisterRepository/models/request.dart';
import 'package:my_dashcam/utils/dio.dart';

class LoginRegisterRepository {
  // 注册
  Future<Response<String?>?> register(RegisterRequest data) async {
    final response = await fetch.post<Map<String, dynamic>>(
      "/user/register",
      data: data.toMap(),
      options: Options(contentType: "application/json"),
    );
    return Response<String?>.fromJson(response.data!, (data) => data as String);
  }
}
