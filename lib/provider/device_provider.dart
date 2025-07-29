import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/device/device_repository.dart';

final deviceProvider = Provider((ref) => DeviceRepository());
