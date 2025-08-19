// 地理位置数据
class LocationData {
  const LocationData({
    required this.lng,
    required this.lat,
    required this.time,
  });

  // 经度
  final double lng;

  // 纬度
  final double lat;

  // 时间
  final DateTime time;
}