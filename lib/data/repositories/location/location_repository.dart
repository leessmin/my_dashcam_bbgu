import 'package:my_dashcam/data/repositories/location/location_data.dart';

// 抽象地理位置仓库
abstract class LocationRepository {
  /// 获取地理位置数据
  /// [name] 地理位置的名字，通常为文件夹名字
  Future<List<LocationData>> getData(String name, {String? deviceId});
}
