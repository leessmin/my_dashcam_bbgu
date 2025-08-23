import 'package:amap_map/amap_map.dart';
import 'package:coordtransform/coordtransform.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/location/location_data.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/utils/latlong.dart';
import 'package:my_dashcam/utils/loading_command.dart';
import 'package:x_amap_base/x_amap_base.dart';

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

  final Set<Polyline> _polyline = <Polyline>{};

  Set<Polyline> get polyline => _polyline;

  final Set<Marker> _marker = <Marker>{};

  Set<Marker> get marker => _marker;

  // 行使总时长
  Duration _totalTime = Duration();

  Duration get totalTime => _totalTime;

  // 行使路长，单位Km
  double _totalDistance = 0;

  double get totalDistance => _totalDistance;

  double _avgSpeed = 0;

  double get avgSpeed => _avgSpeed;

  Future<void> _load(String name) async {
    final polylineColor = getCatppuccinByCtx(context).blue;

    await loading.command(() async {
      debugPrint("wuyu: $deviceId");
      _data = await _locationRepository.getData(name, deviceId: deviceId);

      // 路径
      _polyline.add(
        Polyline(
          points: data.map((item) {
            final latLng = CoordTransform.transformWGS84toGCJ02(
              item.lng,
              item.lat,
            );
            return LatLng(latLng.lat, latLng.lon);
          }).toList(),
          color: polylineColor,
        ),
      );

      final firstData = data.first;
      final lastData = data.last;

      final firstLatLng = CoordTransform.transformWGS84toGCJ02(
        firstData.lng,
        firstData.lat,
      );
      final lastLatLng = CoordTransform.transformWGS84toGCJ02(
        lastData.lng,
        lastData.lat,
      );

      // 标记起始点/终点
      _marker.add(Marker(position: LatLng(firstLatLng.lat, firstLatLng.lon)));
      _marker.add(Marker(position: LatLng(lastLatLng.lat, lastLatLng.lon)));

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
