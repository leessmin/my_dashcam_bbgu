import 'package:device_info_plus/device_info_plus.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/device/models/request.dart';
import 'package:my_dashcam/data/repositories/device/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';
import 'package:platform_device_id_plus/platform_device_id.dart';

/// 手机设备
class DeviceRepository {
  /// 注册设备
  Future<Response<DeviceRegisterResponse?>?> registerDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.androidInfo;
    final response = await fetch.post<Map<String, dynamic>>(
      "/device/register",
      data: DeviceRegisterRequest(
        id: await PlatformDeviceId.getDeviceId ?? info.id,
        model: info.model,
        versionRelease: info.version.release,
        display: info.display,
      ).toMap(),
    );

    return Response.fromJson(
      response.data!,
      (json) => DeviceRegisterResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
