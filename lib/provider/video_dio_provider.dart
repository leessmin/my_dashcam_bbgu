import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';

final videoDioProvider = Provider((ref) => VideoDioRepository());
