import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';

Future<Widget?> loadingOverlay(BuildContext context, {Widget? child}) {
  return showGeneralDialog(
    context: context,
    transitionDuration: Duration(milliseconds: 300), // 动画时长
    barrierDismissible: false, // 禁止点击外部关闭
    pageBuilder: (context, animation1, animation2) {
      return PopScope(
        canPop: false,
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text(
                  "导出中,请耐心等待...",
                  style: TextStyle(color: getCatppuccinByCtx(context).lavender),
                ),
                ?child,
              ],
            ),
          ),
        ),
      );
    },
  );
}
