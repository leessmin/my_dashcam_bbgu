import 'package:flutter/cupertino.dart';

// 加载，命令模式
class LoadingCommand {
  // 状态
  ValueNotifier<bool> status = ValueNotifier(false);

  // 命令
  Future<void> command(Future<void> Function() fn) async {
    try {
      status.value = true;
      await fn();
    } catch (e) {
      debugPrint("loadingCommand err: $e");
    } finally {
      status.value = false;
    }
  }
}
