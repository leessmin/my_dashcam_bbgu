import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/videoExport/video_export_repository.dart';
import 'package:my_dashcam/data/services/video_export_service.dart';

final videoExportProvider = Provider(
  (ref) => VideoExportRepository(videoExportService: VideoExportService()),
);
