import 'package:webview_flutter_plus/webview_flutter_plus.dart';

// webview 服务器
LocalhostServer localhostServer = LocalhostServer();

// 启动webView服务器
Future<void> startWebViewServer() async {
  await localhostServer.start(port: 0);
}
