import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:my_dashcam/ui/core/ui/dir_list_online.dart';
import 'package:my_dashcam/ui/core/ui/video_total_card.dart';
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
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.loading.status,
        ]),
        builder: (context, _) {
          final loading = widget.viewModel.loading.status.value;
          if (loading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              VideoTotalCard(total: widget.viewModel.videoDirs.length),
              Expanded(
                child: DirListOnline(
                  dirList: widget.viewModel.videoDirs,
                  onDeleteVideoDir: (int id) =>
                      widget.viewModel.deleteOnlineVideoDir(id),
                  deviceName: widget.deviceName,
                  deviceId: widget.viewModel.deviceId,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
