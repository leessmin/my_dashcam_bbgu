import 'package:flutter/material.dart';

class SideSheet {
  static Future<Widget?> left(
    BuildContext context, {
    // sheet占据页面的比例
    double scale = 1.3,
    required Widget child,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sheetWidth = screenWidth / scale;

    return showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation1, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Dismissible(
                key: Key("side_sheet_left"),
                // 只允许水平方向滑动
                direction: DismissDirection.endToStart,
                // 防止内容重排
                resizeDuration: null,
                // 滑动40%后关闭
                dismissThresholds: const {DismissDirection.startToEnd: 0.4},
                onDismissed: (direction) {
                  Navigator.of(context).pop(); // 滑动后关闭
                },
                child: Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        height: double.infinity,
                        width: sheetWidth,
                        child: child,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
