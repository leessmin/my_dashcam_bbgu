import 'package:coordtransform/coordtransform.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/location/location_data.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';
import 'package:my_dashcam/utils/latlong.dart';
import 'package:my_dashcam/utils/loading_command.dart';

class TrackViewModel extends ChangeNotifier {
  TrackViewModel({
    required this.context,
    required LocationRepository locationRepository,
    required this.name,
    this.deviceId = "",
  }) : _locationRepository = locationRepository {
    _load(name);
  }

  final BuildContext context;

  // 地理位置文件名
  final String name;

  // 设备id
  final String deviceId;

  final LocationRepository _locationRepository;

  LoadingCommand loading = LoadingCommand();

  // 轨迹数据
  List<LocationData> _data = [];

  List<LocationData> get data => _data;

  List<List<double>> _polyline = [];

  List<List<double>> get polyline => _polyline;

  // 行使总时长
  Duration _totalTime = Duration();

  Duration get totalTime => _totalTime;

  // 行使路长，单位Km
  double _totalDistance = 0;

  double get totalDistance => _totalDistance;

  double _avgSpeed = 0;

  double get avgSpeed => _avgSpeed;

  Future<void> _load(String name) async {
    await loading.command(() async {
      debugPrint("wuyu: $deviceId");
      _data = await _locationRepository.getData(name, deviceId: deviceId);

      // 路径
      _polyline = data.map((item) {
        // wg84坐标 转换 GCJ02
        final latLng = CoordTransform.transformWGS84toGCJ02(item.lng, item.lat);
        return [latLng.lon, latLng.lat];
      }).toList();

      final firstData = data.first;
      final lastData = data.last;

      // 总时长
      _totalTime = lastData.time.difference(firstData.time);

      // 总路长
      _totalDistance = LatLong.calcDistance(data);

      // 平均速度
      _avgSpeed = LatLong.avgSpeedKmH(
        _totalDistance,
        _totalTime.inSeconds.toDouble(),
      );

      notifyListeners();
    });
  }
}
