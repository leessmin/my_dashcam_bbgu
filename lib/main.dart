import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/sqlite_videos_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/routing/router.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/themes/theme.dart';
import 'package:my_dashcam/utils/flutter_channel.dart';
import 'package:toastification/toastification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterChannel(
    sqliteVideosRepository: SqliteVideosRepository(),
    videoDioRepository: VideoDioRepository(),
  ).startFlutterMethodChannel();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: catppuccinTheme(getCatppuccin(false)),
        themeMode: ThemeMode.system,
        darkTheme: catppuccinTheme(getCatppuccin(true)),
        routerConfig: router(ref),
      ),
    );
  }
}
