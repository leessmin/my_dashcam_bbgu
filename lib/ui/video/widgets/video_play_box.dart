
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoPlayBox extends StatefulWidget {
  const VideoPlayBox({super.key, required this.chewieController});

  final ValueNotifier<ChewieController?> chewieController;

  @override
  State<VideoPlayBox> createState() => _VideoPlayBoxState();
}

class _VideoPlayBoxState extends State<VideoPlayBox> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.chewieController,
      builder: (BuildContext context, controller, Widget? _) {
        return SizedBox(
          width: double.infinity,
          height: 200,
          child: controller == null
              ? Center(child: CircularProgressIndicator())
              : Chewie(controller: controller),
        );
      },
    );
  }
}
