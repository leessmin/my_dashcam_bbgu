import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:my_dashcam/ui/core/ui/loading_overlay.dart';
import 'package:my_dashcam/ui/online_video/view_models/online_video_viewmodel.dart';
import 'package:my_dashcam/ui/online_video/widgets/video_list.dart';
import 'package:my_dashcam/ui/online_video/widgets/video_play_box.dart';
import 'package:my_dashcam/utils/timestamp_format.dart';

class OnlineVideoScreen extends StatefulWidget {
  const OnlineVideoScreen({super.key, required this.viewModel});

  final OnlineVideoViewModel viewModel;

  @override
  State<OnlineVideoScreen> createState() => _OnlineVideoScreenState();
}

class _OnlineVideoScreenState extends State<OnlineVideoScreen> {
  @override
  void dispose() {
    super.dispose();
    widget.viewModel.dispose();
  }

  // 导出视频
  void exportVideo(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("导出视频"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                widget.viewModel.exportVideos.isEmpty
                    ? "你确定要导出全部视频吗?"
                    : "你确定要导出${widget.viewModel.exportVideos.length}个视频吗?",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("是否进行视频合并"),
                  ValueListenableBuilder(
                    valueListenable: widget.viewModel.isMerge,
                    builder: (BuildContext context, bool value, _) {
                      return Checkbox(
                        checkColor: getCatppuccinByCtx(context).base,
                        fillColor: WidgetStatePropertyAll(
                          getCatppuccinByCtx(context).mauve,
                        ),
                        value: value,
                        onChanged: (bool? value) {
                          widget.viewModel.setIsMerge(value ?? false);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              final sm = ScaffoldMessenger.of(context);
              final nv = Navigator.of(context);
              final green = getCatppuccinByCtx(context).green;
              nv.pop();
              loadingOverlay(
                context,
                child: ValueListenableBuilder(
                  valueListenable: widget.viewModel.exportProgress,
                  builder: (BuildContext context, value, _) {
                    return Text(
                      "$value%",
                      style: TextStyle(
                        color: getCatppuccinByCtx(context).lavender,
                      ),
                    );
                  },
                ),
              );
              await widget.viewModel.exportVideoHandle();
              nv.pop();
              sm.showSnackBar(
                SnackBar(
                  content: Text("导出成功", style: TextStyle(color: green)),
                ),
              );
            },
            child: Text(
              "导出",
              style: TextStyle(color: getCatppuccinByCtx(context).lavender),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultChildAppBar(
        context,
        title: TimestampFormat.timestampToTimeString(widget.viewModel.dirName),
        actions: [
          IconButton(
            onPressed: () => exportVideo(context),
            icon: Icon(
              Icons.ios_share_sharp,
              color: getCatppuccinByCtx(context).sky,
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.videos.isEmpty) {
            return SizedBox();
          }

          return Column(
            children: [
              VideoPlayBox(chewieController: widget.viewModel.chewieController),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.viewModel.isExportMode
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "导出视频",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  "${widget.viewModel.exportVideos.length}/${widget.viewModel.videos.length}",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.viewModel.setExportMode(false);
                                    widget.viewModel.cleanExportVideos();
                                  },
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                      color: getCatppuccinByCtx(context).red,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "视频列表",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  "${widget.viewModel.currentIndex + 1}/${widget.viewModel.videos.length}个视频",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                      SizedBox(height: 10),
                      Expanded(
                        child: VideoList(
                          videos: widget.viewModel.videos,
                          isExportMode: widget.viewModel.isExportMode,
                          tapVideo: (index) =>
                              widget.viewModel.setCurrentPlay(index),
                          currentVideoIdx: widget.viewModel.currentIndex,
                          onLongPress: () =>
                              widget.viewModel.setExportMode(true),
                          onSwitchExportVideo:
                              widget.viewModel.switchExportVideo,
                          exportVideo: widget.viewModel.exportVideos,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
