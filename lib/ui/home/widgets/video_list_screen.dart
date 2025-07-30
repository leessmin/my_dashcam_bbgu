import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/home/view_models/video_list_viewmodel.dart';

import 'dir_list.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key, required this.viewModel});

  final VideoListViewModel viewModel;

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
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
    );
  }
}
