import 'package:flutter/material.dart';

// 视频总数Card
class VideoTotalCard extends StatelessWidget {
  const VideoTotalCard({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("记录总数", style: Theme.of(context).textTheme.titleMedium),
              Text("$total"),
            ],
          ),
        ),
      ),
    );
  }
}
