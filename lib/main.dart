import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/routing/router.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/themes/theme.dart';
import 'package:toastification/toastification.dart';

/*
测试获取设备信息
void testDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  print((await deviceInfo.androidInfo).model);
  print((await deviceInfo.androidInfo).id);
  print((await deviceInfo.androidInfo).version.release);
  print((await deviceInfo.androidInfo).display);
  print((await deviceInfo.androidInfo).data);
}
 */

void main() {
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
