import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class Routes {
  static const home = "/";
  static const setting = "/setting";
  static const permissions = "/permissions";
  static const video = "/video";
  static const login = "/login";
  static const register = "/register";
  static const onlineVideo = "/onlineVideo";

  // 不需要权限校验的路由列表
  static List<String> get noAuthRoutes => [Routes.login, Routes.register];

  /// go video
  /// [dirName] 存储视频的目录名字
  static void pushVideoRoute(BuildContext context, {required String dirName}) =>
      context.push("${Routes.video}/$dirName");

  static void pushOnlineVideoRoute(
    BuildContext context, {
    required int dirId,
    required String dirName,
  }) => context.push("${Routes.onlineVideo}/$dirId/$dirName");
}
