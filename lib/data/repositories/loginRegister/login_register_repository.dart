import 'package:dio/dio.dart' hide Response;
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/loginRegister/models/response.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';
import 'package:my_dashcam/utils/dio.dart';

import 'models/request.dart';

class LoginRegisterRepository {
  final _userSessionRepository = UserSessionRepository();

  // 注册
  Future<Response<String?>?> register(RegisterRequest data) async {
    final response = await fetch.post<Map<String, dynamic>>(
      "/user/register",
      data: data.toMap(),
      options: Options(contentType: "application/json"),
    );
    return Response<String?>.fromJson(response.data!, (data) => data as String);
  }

  // 登陆，通过密码
  Future<Response<LoginResponse>> loginPassword(
    LoginPasswordRequest data,
  ) async {
    final response = await fetch.post(
      "/user/login",
      data: data.toMap(),
      options: Options(contentType: "application/json"),
    );

    final result = Response.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );

    _storeUserSession(result);

    return result;
  }

  // 登陆，通过邮箱验证码
  Future<Response<LoginResponse>> loginEmailCode(
    LoginEmailCodedRequest data,
  ) async {
    final response = await fetch.post(
      "/user/login_email",
      data: data.toMap(),
      options: Options(contentType: "application/json"),
    );

    final result = Response.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );

    _storeUserSession(result);

    return result;
  }

  // 跳过登陆
  void skipLogin(){
    _userSessionRepository.setSkipLoginKey(true);
  }

  // 储存用户会话信息
  void _storeUserSession(Response<LoginResponse> result) {
    if (result.code != 200) {
      return;
    }
    _userSessionRepository.setToken(result.data.token);
    _userSessionRepository.setEmail(result.data.user.email);
    _userSessionRepository.setUsername(result.data.user.username);
  }
}
