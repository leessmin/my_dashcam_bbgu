import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:my_dashcam/ui/core/ui/dir_list_online.dart';
import 'package:my_dashcam/ui/online_dir/view_models/online_dir_viewmodel.dart';

class OnlineDirScreen extends StatefulWidget {
  const OnlineDirScreen({
    super.key,
    required this.deviceName,
    required this.viewModel,
  });

  // 设备名字
  final String deviceName;
  final OnlineDirViewModel viewModel;

  @override
  State<OnlineDirScreen> createState() => _OnlineDirScreenState();
}

class _OnlineDirScreenState extends State<OnlineDirScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultChildAppBar(context, title: widget.deviceName),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return DirListOnline(
            dirList: widget.viewModel.videoDirs,
            onDeleteVideoDir: (int id) =>
                widget.viewModel.deleteOnlineVideoDir(id),
            deviceName: widget.deviceName,
          );
        },
      ),
    );
  }
}
