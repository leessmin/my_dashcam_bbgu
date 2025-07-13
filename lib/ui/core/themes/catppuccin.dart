import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

/// 获取catppuccin主题配色方案
/// [isDark] 是否是暗黑主题
Flavor getCatppuccin(bool isDark) {
  return isDark ? catppuccin.macchiato : catppuccin.latte;
}

/// 通过context获取当前颜色主题
/// [context] BuildContext, 用来判断使用那个主题配色方案
Flavor getCatppuccinByCtx(BuildContext context){
  return getCatppuccin(Theme.of(context).brightness == Brightness.dark);
}