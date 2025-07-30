import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/configuration/global_configuration.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';
import 'package:toastification/toastification.dart';

Dio? _dio;

// 基础请求
Dio get fetch {
  if (_dio == null) {
    _dio = Dio();
    _dio?.options.baseUrl = GlobalConfiguration.apiUri;
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          final data = error.response?.data;
          final msg = data is Map && data['msg'] != null
              ? data['msg']
              : "请求出现了错误，请稍后重试";

          toastification.show(
            style: ToastificationStyle.fillColored,
            type: ToastificationType.error,
            title: Text(msg),
            autoCloseDuration: const Duration(seconds: 3),
          );
          return handler.next(error);
        },
      ),
    );
  }
  return _dio!;
}

Dio? _authDio;

// 需要权限校验
Future<Dio?> get authFetch async {
  final userSessionRepository = UserSessionRepository();
  final token = await userSessionRepository.getToken();

  if (_authDio == null) {
    if (token.isEmpty) {
      return null;
    }

    _authDio = fetch.clone();
    _authDio?.options.headers = {"Authorization": "Bearer $token"};
  }

  if(token.isEmpty){
    _authDio = null;
    return null;
  }

  return _authDio!;
}
