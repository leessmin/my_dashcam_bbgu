import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/provider/my_dashcam_provider.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/home/view_models/home_viewmodel.dart';
import 'package:my_dashcam/ui/home/widgets/home_screen.dart';
import 'package:my_dashcam/ui/permissions/view_models/permissions_viewmodel.dart';
import 'package:my_dashcam/ui/permissions/widgets/permissions_screen.dart';
import 'package:my_dashcam/ui/setting/view_models/setting_viewmodel.dart';
import 'package:my_dashcam/ui/setting/widgets/setting_screen.dart';
import 'package:my_dashcam/ui/video/view_models/video_viewmodel.dart';
import 'package:my_dashcam/ui/video/widgets/video_screen.dart';

GoRouter router(WidgetRef ref) {
  final provider = ref.read(myDashCamProvider);

  // home页面，缓存这个页面
  final homeScreen = HomeScreen(
    viewModel: HomeViewModel(
      configurationRepository: provider.configurationRepository(),
      permissionRepository: provider.permissionRepository(),
      videoDirectoryRepository: provider.videoDirectoryRepository(),
    ),
  );

  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
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
    ],
  );
}
