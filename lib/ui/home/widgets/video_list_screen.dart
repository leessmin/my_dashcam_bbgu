import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/home/view_models/video_list_viewmodel.dart';
import 'package:my_dashcam/ui/core/ui/dir_list_online.dart';

import 'dir_list.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key, required this.viewModel});

  final VideoListViewModel viewModel;

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 从录制页面返回时
    if (state == AppLifecycleState.resumed) {
      widget.viewModel.getVideoDir();
      widget.viewModel.getOnlineVideoDir();
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.viewModel]),
      builder: (context, _) {
        final videoDirs = widget.viewModel.videoDirs;
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.directions_car_filled), text: "本地"),
                Tab(icon: Icon(Icons.online_prediction), text: "在线"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  DirList(
                    dirList: videoDirs,
                    scrollController: _scrollController,
                    onDeleteVideoDir: (String dirPath) =>
                        widget.viewModel.deleteVideoDir(dirPath),
                  ),
                  DirListOnline(
                    dirList: widget.viewModel.onlineVideoDirs,
                    scrollController: _scrollController,
                    onDeleteVideoDir: (int id) =>
                        widget.viewModel.deleteOnlineVideoDir(id),
                    deviceName: "本机",
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
