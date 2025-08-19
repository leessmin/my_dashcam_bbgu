import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/location/local_location_repository.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';

final localLocationProvider = Provider<LocationRepository>(
  (ref) => LocalLocationRepository(),
);
