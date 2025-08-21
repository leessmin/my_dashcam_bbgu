// 经纬度/距离相关关工具
import 'package:latlong2/latlong.dart';
import 'package:my_dashcam/data/repositories/location/location_data.dart';

class LatLong {
  // 计算距离 单位Km
  static double calcDistance(List<LocationData> list) {
    if (list.length < 2) return 0.0;

    final Distance distance = Distance();

    double total = 0.0;

    for (int i = 0; i < list.length - 1; i++) {
      total += distance(
        LatLng(list[i].lat, list[i].lng),
        LatLng(list[i + 1].lat, list[i + 1].lng),
      );
    }

    // 保留1位小数
    return (total / 1000 * 10).round() / 10;
  }

  /// 计算速度 单位Km/h
  /// [distance] 距离 单位km
  /// [timeSeconds] 时间， 单位秒
  static double avgSpeedKmH(double distance, double timeSeconds){
    double timeHours = timeSeconds / 3600; // 秒 -> 小时
    if (timeHours == 0) return 0; // 避免除以0
    return (distance / timeHours * 10).round() / 10;
  }
}
