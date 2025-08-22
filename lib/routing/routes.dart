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
  static const onlineDir = "/onlineDir";
  static const track = "/track";
  static const trackOnline = "/trackOnline";

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
    required String topBarTitle,
    String? deviceId,
  }) => context.push(
    "${Routes.onlineVideo}/$dirId/$dirName/$topBarTitle?deviceId=$deviceId",
  );

  static void pushOnlineDirRoute(
    BuildContext context, {
    required String deviceId,
    required String deviceName,
  }) => context.push("${Routes.onlineDir}/$deviceId/$deviceName");

  /// 跳转至路径页面
  /// [filename] 路径文件名
  /// [type] 类型 0本地 1联网 默认0
  static void pushTrack(
    BuildContext context, {
    required String filename,
    String? deviceId,
    int type = 0,
  }) {
    if (type == 0) {
      context.push("${Routes.track}/$filename");
    } else if (type == 1) {
      final queryStr = deviceId == null ? "" : "?deviceId=$deviceId";
      context.push("${Routes.trackOnline}/$filename$queryStr");
    }
  }
}
