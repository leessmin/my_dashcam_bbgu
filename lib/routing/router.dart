import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/provider/my_dashcam_provider.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/home/view_models/home_viewmodel.dart';
import 'package:my_dashcam/ui/home/widgets/home_screen.dart';
import 'package:my_dashcam/ui/login/view_models/login_viewmodel.dart';
import 'package:my_dashcam/ui/login/widgets/login_screen.dart';
import 'package:my_dashcam/ui/online_dir/view_models/online_dir_viewmodel.dart';
import 'package:my_dashcam/ui/online_dir/widgets/online_dir_screen.dart';
import 'package:my_dashcam/ui/online_video/view_models/online_video_viewmodel.dart';
import 'package:my_dashcam/ui/online_video/widgets/online_video_screen.dart';
import 'package:my_dashcam/ui/permissions/view_models/permissions_viewmodel.dart';
import 'package:my_dashcam/ui/permissions/widgets/permissions_screen.dart';
import 'package:my_dashcam/ui/register/view_models/register_viewmodel.dart';
import 'package:my_dashcam/ui/register/widgets/register_screen.dart';
import 'package:my_dashcam/ui/setting/view_models/setting_viewmodel.dart';
import 'package:my_dashcam/ui/setting/widgets/setting_screen.dart';
import 'package:my_dashcam/ui/track/view_models/track_viewmodel.dart';
import 'package:my_dashcam/ui/track/widgets/track_screen.dart';
import 'package:my_dashcam/ui/video/view_models/video_viewmodel.dart';
import 'package:my_dashcam/ui/video/widgets/video_screen.dart';
import 'package:my_dashcam/utils/timestamp_format.dart';

GoRouter router(WidgetRef ref) {
  final provider = ref.read(myDashCamProvider);

  // home页面，缓存这个页面
  final homeScreen = HomeScreen(
    viewModel: HomeViewModel(
      configurationRepository: provider.configurationRepository(),
      permissionRepository: provider.permissionRepository(),
      videoDirectoryRepository: provider.videoDirectoryRepository(),
      videoDioRepository: provider.videoDioRepository(),
    ),
  );

  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      debugPrint("state.path: ${state.fullPath}");
      final userSessionRepository = provider.userSessionRepository();
      if (!Routes.noAuthRoutes.contains(state.fullPath)) {
        // 需要登陆才能使用的页面
        if ((await userSessionRepository.getToken()).isEmpty &&
            !(await userSessionRepository.getSkipLogin())) {
          // 没有登陆/跳过登陆
          return Routes.login;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return homeScreen;
        },
      ),
      GoRoute(
        path: Routes.setting,
        builder: (context, state) => SettingScreen(
          viewmodel: SettingViewModel(
            configurationRepository: provider.configurationRepository(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.permissions,
        builder: (context, state) => PermissionsScreen(
          viewmodel: PermissionsViewModel(
            permissionRepository: provider.permissionRepository(),
          ),
        ),
      ),
      GoRoute(
        path: "${Routes.video}/:dirName",
        builder: (context, state) {
          final dirName = state.pathParameters["dirName"];
          if (dirName == null) {
            return Scaffold(body: Center(child: Text("dirName == null")));
          }

          debugPrint("dirName: $dirName");
          return VideoScreen(
            viewModel: VideoViewModel(
              videoDirectoryRepository: provider.videoDirectoryRepository(),
              videoExportRepository: provider.videoExportRepository(),
              dirName: dirName,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => LoginScreen(
          viewModel: LoginViewModel(
            deviceRepository: provider.deviceRepository(),
            loginRegisterRepository: provider.loginRegisterRepositor(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => RegisterScreen(
          viewModel: RegisterViewModel(
            loginRegisterRepository: provider.loginRegisterRepositor(),
          ),
        ),
      ),
      GoRoute(
        path: "${Routes.onlineVideo}/:dirId/:dirName/:topBarTitle",
        builder: (context, state) {
          final dirId = state.pathParameters["dirId"];
          final dirName = state.pathParameters["dirName"];
          final topBarTitle = state.pathParameters["topBarTitle"];
          if (dirId == null || dirName == null || topBarTitle == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  "dirId == null || dirName == null || topBarTitle == null",
                ),
              ),
            );
          }

          debugPrint("dirId: $dirId");
          return OnlineVideoScreen(
            viewModel: OnlineVideoViewModel(
              videoDioRepository: provider.videoDioRepository(),
              userSessionRepository: provider.userSessionRepository(),
              dirId: int.parse(dirId),
              topBarTitle:
                  "$topBarTitle:${TimestampFormat.timestampToTimeString(dirName)}",
            ),
          );
        },
      ),
      GoRoute(
        path: "${Routes.onlineDir}/:deviceId/:deviceName",
        builder: (context, state) {
          final deviceName = state.pathParameters["deviceName"];
          final deviceId = state.pathParameters["deviceId"];
          if (deviceName == null || deviceId == null) {
            return Scaffold(
              body: Center(
                child: Text("deviceName == null || deviceId == null"),
              ),
            );
          }

          return OnlineDirScreen(
            deviceName: deviceName,
            viewModel: OnlineDirViewModel(
              videoDioRepository: provider.videoDioRepository(),
              deviceId: deviceId,
            ),
          );
        },
      ),
      GoRoute(
        path: "${Routes.track}/:filename",
        builder: (context, state) {
          final filename = state.pathParameters["filename"];
          if (filename == null) {
            return Scaffold(body: Center(child: Text("filename == null")));
          }
          return TrackScreen(
            viewModel: TrackViewModel(
              context: context,
              locationRepository: provider.localLocationRepository(),
              name: filename,
            ),
          );
        },
      ),
    ],
  );
}
