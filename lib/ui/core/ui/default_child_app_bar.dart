import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

PreferredSizeWidget defaultChildAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    leading: IconButton(
      // 确保 splashColor 不为透明
      splashColor: Theme.of(context).splashColor,
      // 确保 highlightColor 不为透明
      highlightColor: Theme.of(context).highlightColor,
      onPressed: () {
        context.pop();
      },
      icon: Icon(
        Icons.arrow_back_outlined,
        color: Theme.of(context).primaryIconTheme.color,
      ),
    ),
    title: Text(title),
    actions: actions,
  );
}
