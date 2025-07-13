import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/videoDirctory/video_directory_repository.dart';
import 'package:my_dashcam/data/services/video_directory_service.dart';

final videoDirectoryProvider = Provider(
  (ref) =>
      VideoDirectoryRepository(videoDirectoryService: VideoDirectoryService()),
);
