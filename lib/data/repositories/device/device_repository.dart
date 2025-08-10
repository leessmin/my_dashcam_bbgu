import 'package:device_info_plus/device_info_plus.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/device/models/request.dart';
import 'package:my_dashcam/data/repositories/device/models/response.dart';
import 'package:my_dashcam/utils/dio.dart';
import 'package:platform_device_id_plus/platform_device_id.dart';

/// 手机设备
class DeviceRepository {
  /// 获取设备id
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.androidInfo;

    return  await PlatformDeviceId.getDeviceId ?? info.id;
  }

  /// 注册设备
  Future<Response<DeviceRegisterResponse?>?> registerDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.androidInfo;
    final response = await fetch.post<Map<String, dynamic>>(
      "/device/register",
      data: DeviceRegisterRequest(
        id: await getDeviceId(),
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

  /// 获取用户设备列表
  Future<Response<List<DeviceResponse>?>?> getDevices() async {
    try {
      final response = await (await authFetch)?.get("/device/list");

      return Response.fromJson(
        response?.data,
        (json) => List<DeviceResponse>.from(
          (json as List).map((item) => DeviceResponse.fromJson(item)),
        ),
      );
    } catch (_) {
      return Response.defaultResponse([]);
    }
  }
}
