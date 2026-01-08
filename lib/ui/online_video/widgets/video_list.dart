import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/videoDio/models/response.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/base64_image.dart';
import 'package:my_dashcam/utils/timestamp_format.dart';
import 'package:my_dashcam/utils/video_process.dart';
import 'package:path/path.dart' as p;

class VideoList extends StatelessWidget {
  const VideoList({
    super.key,
    required this.videos,
    required this.tapVideo,
    required this.currentVideoIdx,
    required this.isExportMode,
    required this.onLongPress,
    required this.onSwitchExportVideo,
    required this.exportVideo,
  });

  final List<VideoResponse> videos;

  final void Function(int) tapVideo;

  // 当前选择的视频索引
  final int currentVideoIdx;

  // 是否为导出模式
  final bool isExportMode;

  // 监听长按
  final void Function() onLongPress;

  // 添加导出视频
  final void Function(VideoResponse) onSwitchExportVideo;

  // 需要导出的视频
  final List<VideoResponse> exportVideo;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final videoEntity = videos[index];

        return Card(
          color: index == currentVideoIdx
              ? getCatppuccinByCtx(context).lavender
              : null,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onLongPress: onLongPress,
            onTap: () {
              if (isExportMode) {
                onSwitchExportVideo(videoEntity);
              } else {
                tapVideo(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Stack(
                              children: [
                                Base64Image(
                                  image: videoEntity.videoThumbnail
                                      .split(",")
                                      .last,
                                  height: 108 * 0.8,
                                  width: 192 * 0.8,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 5,
                                  child: Text(
                                    VideoProcess.videoDurationFormat(
                                      videoEntity.duration * 1000,
                                    ).toString().split(".").first,
                                    style: TextStyle(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.labelMedium?.fontSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _videoNameFormat(
                                    p.basename(videoEntity.videoPath),
                                  ),
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: index == currentVideoIdx
                                            ? getCatppuccinByCtx(
                                                context,
                                              ).rosewater
                                            : null,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _infoText(
                                        context,
                                        "分辨率: ${videoEntity.resolution}",
                                        active: index == currentVideoIdx,
                                      ),
                                      _infoText(
                                        context,
                                        "类型: ${videoEntity.videoType}",
                                        active: index == currentVideoIdx,
                                      ),
                                      _infoText(
                                        context,
                                        "大小: ${videoEntity.videoSize.toStringAsFixed(2)}MB",
                                        active: index == currentVideoIdx,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned.fill(
                        right: 0,
                        top: 0,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: isExportMode
                              ? Checkbox(
                                  checkColor: getCatppuccinByCtx(context).base,
                                  fillColor: WidgetStatePropertyAll(
                                    getCatppuccinByCtx(context).mauve,
                                  ),
                                  value: exportVideo.contains(videoEntity),
                                  onChanged: (bool? value) {
                                    onSwitchExportVideo(videoEntity);
                                  },
                                )
                              : SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 视频详情文字
  Widget _infoText(BuildContext context, String data, {required bool active}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Text(
        data,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: active ? getCatppuccinByCtx(context).rosewater : null,
        ),
      ),
    );
  }

  /// 视频的名字格式化
  /// 时间戳.mp4 -> yyyy-MM-dd hh:mm:ss
  /// [videoName] 视频文件名
  /// @return 格式化后的字符串
  String _videoNameFormat(String videoName) {
    final timestamp = videoName.split(".")[0];
    return TimestampFormat.timestampToTimeString(
      timestamp,
      format: "yyyy-MM-dd HH:mm:ss",
    );
  }

  /// 格式化Bytes大小
  String formatBytes(int? bytes, [int decimals = 2]) {
    if (bytes == null || bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (bytes != 0) ? (math.log(bytes) / math.log(1024)).floor() : 0;
    double size = bytes / math.pow(1024, i);
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }
}
