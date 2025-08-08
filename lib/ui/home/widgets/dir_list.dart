import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/video_directory.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/video_thumbnail_img.dart';
import 'package:my_dashcam/utils/timestamp_format.dart';
import 'package:path/path.dart' as p;

class DirList extends StatefulWidget {
  const DirList({
    super.key,
    required this.dirList,
    required this.scrollController,
    required this.onDeleteVideoDir,
  });

  final List<VideoDirectory> dirList;
  final ScrollController scrollController;
  final Future<void> Function(String) onDeleteVideoDir;

  @override
  State<DirList> createState() => _DirListState();
}

class _DirListState extends State<DirList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: widget.dirList.isEmpty
          ? Center(child: Text("当前没有视频记录"))
          : ListView.builder(
              controller: widget.scrollController,
              itemCount: widget.dirList.length,
              itemBuilder: (context, index) {
                final videoDir = widget.dirList[index];

                if (videoDir.firstVideoPath == null) {
                  return null;
                }

                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Routes.pushVideoRoute(
                        context,
                        dirName: p.basename(videoDir.dirPath),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                TimestampFormat.timestampToTimeString(
                                  videoDir.dirName,
                                ),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                "${videoDir.count}",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: VideoThumbnailImg(
                                  videoPath: videoDir.firstVideoPath!,
                                  height: 72,
                                  width: 128,
                                  quality: 20,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text("删除"),
                                              content: Text("您确定要删除该行车记录吗?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("取消"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    widget.onDeleteVideoDir(
                                                      videoDir.dirPath,
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "删除",
                                                    style: TextStyle(
                                                      color: getCatppuccinByCtx(
                                                        context,
                                                      ).red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: getCatppuccinByCtx(context).red,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
