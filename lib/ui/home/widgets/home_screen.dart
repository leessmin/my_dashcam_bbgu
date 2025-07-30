import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/core/ui/side_sheet.dart';
import 'package:my_dashcam/ui/home/view_models/home_viewmodel.dart';
import 'package:my_dashcam/ui/home/widgets/dir_list.dart';
import 'package:my_dashcam/utils/platform_method.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 从录制页面返回时
    if (state == AppLifecycleState.resumed) {
      widget.viewModel.getVideoDir();
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _homeAppBar(context, title: "我的记录仪"),
      body: ListenableBuilder(
        listenable: Listenable.merge([widget.viewModel]),
        builder: (context, _) {
          final videoDirs = widget.viewModel.videoDirs;
          return DirList(
            dirList: videoDirs,
            scrollController: _scrollController,
            onDeleteVideoDir: (String dirPath) =>
                widget.viewModel.deleteVideoDir(dirPath),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await launchCameraActivity(await widget.viewModel.getCameraOption());
        },
        tooltip: "启动记录仪",
        child: Icon(Icons.camera),
      ),
    );
  }

  AppBar _homeAppBar(BuildContext context, {required String title}) {
    return AppBar(
      leading: IconButton(
        // 确保 splashColor 不为透明
        splashColor: Theme.of(context).splashColor,
        // 确保 highlightColor 不为透明
        highlightColor: Theme.of(context).highlightColor,
        onPressed: () {
          SideSheet.left(context, child: _sideSheet(context));
        },
        icon: Icon(Icons.menu, color: Theme.of(context).primaryIconTheme.color),
      ),
      title: Text(title),
    );
  }

  Widget _sideSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/images/logo.png"), width: 80),
              Text("我的行车记录仪"),
              Text("v1.0.0"),
            ],
          ),
          SizedBox(height: 30),
          _sideSheetButton(
            context,
            icon: Icons.settings_outlined,
            text: "设置",
            onPressed: () {
              context.push(Routes.setting);
            },
          ),
          _sideSheetButton(
            context,
            icon: Icons.lock_outline_rounded,
            text: "权限",
            onPressed: () {
              context.push(Routes.permissions);
            },
          ),
          _sideSheetButton(
            context,
            icon: Icons.info_outline_rounded,
            text: "关于",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _sideSheetButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required void Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Theme.of(context).hoverColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color, size: 32),
            SizedBox(width: 12),
            Text(text, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
