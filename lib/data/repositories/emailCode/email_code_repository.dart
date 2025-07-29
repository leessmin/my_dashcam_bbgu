import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';

class EmailCodeRepository {
  // 获取邮箱验证码
  Future<Response<String?>?> getEmailCode(String email) async {
    final response = await fetch.get<Map<String, dynamic>>(
      "/verification/send?email=$email",
    );
    return Response<String?>.fromJson(response.data!, (data) => data as String?);
  }
}
