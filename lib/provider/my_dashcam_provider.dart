import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/configuration/configuration_repository.dart';
import 'package:my_dashcam/data/repositories/device/device_repository.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';
import 'package:my_dashcam/data/repositories/loginRegister/login_register_repository.dart';
import 'package:my_dashcam/data/repositories/permissions/permission_repository.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';
import 'package:my_dashcam/data/repositories/videoDio/video_dio_repository.dart';
import 'package:my_dashcam/data/repositories/videoDirctory/video_directory_repository.dart';
import 'package:my_dashcam/data/repositories/videoExport/video_export_repository.dart';
import 'package:my_dashcam/provider/configuration_provider.dart';
import 'package:my_dashcam/provider/device_provider.dart';
import 'package:my_dashcam/provider/location_provider.dart';
import 'package:my_dashcam/provider/permissions_provider.dart';
import 'package:my_dashcam/provider/user_session_provider.dart';
import 'package:my_dashcam/provider/video_dio_provider.dart';
import 'package:my_dashcam/provider/video_directory_provider.dart';
import 'package:my_dashcam/provider/video_export_provider.dart';

import 'login_register_provider.dart';

final myDashCamProvider = Provider((ref) => MyDashCamProvider(ref));

class MyDashCamProvider {
  MyDashCamProvider(this._ref);

  final Ref _ref;

  ConfigurationRepository configurationRepository() =>
      _ref.read(configurationProvider);

  PermissionRepository permissionRepository() => _ref.read(permissionsProvider);

  VideoDirectoryRepository videoDirectoryRepository() =>
      _ref.read(videoDirectoryProvider);

  VideoExportRepository videoExportRepository() =>
      _ref.read(videoExportProvider);

  UserSessionRepository userSessionRepository() =>
      _ref.read(userSessionProvider);

  LoginRegisterRepository loginRegisterRepositor() =>
      _ref.read(loginRegisterProvider);

  DeviceRepository deviceRepository() => _ref.read(deviceProvider);

  VideoDioRepository videoDioRepository() => _ref.read(videoDioProvider);

  LocationRepository localLocationRepository() =>
      _ref.read(localLocationProvider);

  LocationRepository onlineLocationRepository() =>
      _ref.read(onlineLocationProvider);
}
