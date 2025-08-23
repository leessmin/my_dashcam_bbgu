import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/ui/video_total_card.dart';
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
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if(_tabController.index == 0){
          // 标签栏--本地
          widget.viewModel.getVideoDir();
        }else if (_tabController.index == 1) {
          // 标签栏--在线视频，刷新在线视频
          widget.viewModel.getOnlineVideoDir();
        }
      }
    });
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
      listenable: Listenable.merge([
        widget.viewModel,
        widget.viewModel.loading.status,
      ]),
      builder: (context, _) {
        final videoDirs = widget.viewModel.videoDirs;
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.directions_car_filled), text: "本地"),
                Tab(icon: Icon(Icons.cloud_circle), text: "云"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  widget.viewModel.loading.status.value
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            VideoTotalCard(
                              total: videoDirs.length,
                            ),
                            Expanded(
                              child: DirList(
                                dirList: videoDirs,
                                scrollController: _scrollController,
                                onDeleteVideoDir: (String dirPath) =>
                                    widget.viewModel.deleteVideoDir(dirPath),
                              ),
                            ),
                          ],
                        ),
                  widget.viewModel.loading.status.value
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            VideoTotalCard(
                              total: widget.viewModel.onlineVideoDirs.length,
                            ),
                            Expanded(
                              child: DirListOnline(
                                dirList: widget.viewModel.onlineVideoDirs,
                                scrollController: _scrollController,
                                onDeleteVideoDir: (int id) =>
                                    widget.viewModel.deleteOnlineVideoDir(id),
                                deviceName: "本机",
                              ),
                            ),
                          ],
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
