import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/data/repositories/locationDio/location_dio_repository.dart';
import 'package:my_dashcam/data/repositories/sqliteVideo/sqlite_videos_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:workmanager/workmanager.dart';

// workManager

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint("task: work: $task");
    switch (task) {
      case "upload_file":
        await uploadFile();
        break;
      default:
        break;
    }

    return Future.value(true);
  });
}

Future<void> uploadFile() async {
  await _uploadVideo();
  await _uploadLocation();
}

Future<void> _uploadVideo() async {
  final videoRepository = SqliteVideosRepository();
  final dioRepository = VideoDioRepository();

  final videos = await videoRepository.getUploadFailedVideos();

  for (var video in videos) {
    final result = await dioRepository.uploadVideo(
      video.dirName,
      video.videoPath,
    );
    if (result.code == 200) {
      videoRepository.updateUpload(video.videoPath);
    }
  }
}

Future<void> _uploadLocation() async {
  final repository = LocationDioRepository();
  final list = await repository.getFailedLocation();

  for (var val in list) {
    final result = await repository.uploadLocation(val);
    if (result.code == 200) {
      repository.removeFailedLocation(val);
    }
  }
}
