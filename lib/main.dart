import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/routing/router.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/themes/theme.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: catppuccinTheme(getCatppuccin(false)),
      themeMode: ThemeMode.system,
      darkTheme: catppuccinTheme(getCatppuccin(true)),
      routerConfig: router(ref),
    );
  }
}
