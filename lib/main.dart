import 'package:amap_map/amap_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/data/repositories/locationDio/location_dio_repository.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/sqlite_videos_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/routing/router.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/themes/theme.dart';
import 'package:my_dashcam/utils/flutter_channel.dart';
import 'package:toastification/toastification.dart';
import 'package:workmanager/workmanager.dart';
import 'package:x_amap_base/x_amap_base.dart';

import 'configuration/global_configuration.dart';
import 'worker/worker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  boot();
  runApp(ProviderScope(child: MyApp()));
}

void boot() async {
  FlutterChannel(
    sqliteVideosRepository: SqliteVideosRepository(),
    videoDioRepository: VideoDioRepository(),
    locationDioRepository: LocationDioRepository(),
  ).startFlutterMethodChannel();

  await Workmanager().initialize(callbackDispatcher);
  // 上传文件
  Workmanager().registerPeriodicTask(
    "upload_file_1",
    "upload_file",
    constraints: Constraints(networkType: NetworkType.connected),
    frequency: Duration(hours: 12),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isAMapInitialized = false;
  late final GoRouter _router;


  @override
  void initState() {
    super.initState();

    _router = router(ref); // 只初始化一次
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isAMapInitialized) {
        // 高德地图sdk初始化
        AMapInitializer.init(
          context,
          apiKey: AMapApiKey(androidKey: GlobalConfiguration.amapApiKeys),
        );

        AMapInitializer.updatePrivacyAgree(
          AMapPrivacyStatement(
            hasAgree: true,
            hasContains: true,
            hasShow: true,
          ),
        );
        _isAMapInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: catppuccinTheme(getCatppuccin(false)),
        themeMode: ThemeMode.system,
        darkTheme: catppuccinTheme(getCatppuccin(true)),
        routerConfig: _router,
      ),
    );
  }
}
