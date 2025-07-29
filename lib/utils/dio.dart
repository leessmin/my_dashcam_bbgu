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
          toastification.show(
            style: ToastificationStyle.fillColored,
            type: ToastificationType.error,
            title: Text('请求出现了错误，请稍后重试'),
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
Dio get authFetch {
  if (_authDio == null) {
    final userSessionRepository = UserSessionRepository();
    _authDio = fetch.clone();
    _authDio?.options.headers = {
      "Authorization": "Bearer ${userSessionRepository.getToken()}",
    };
  }
  return _authDio!;
}
