import 'package:amap_map/amap_map.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/location/location_data.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/utils/loading_command.dart';
import 'package:x_amap_base/x_amap_base.dart';

class TrackViewModel extends ChangeNotifier {
  TrackViewModel({
    required this.context,
    required LocationRepository locationRepository,
    required this.name,
  }) : _locationRepository = locationRepository {
    _load(name);
  }

  final BuildContext context;

  // 地理位置文件名
  final String name;

  final LocationRepository _locationRepository;

  LoadingCommand loading = LoadingCommand();

  // 轨迹数据
  List<LocationData> _data = [];

  List<LocationData> get data => _data;

  final Set<Polyline> _polyline = <Polyline>{};

  Set<Polyline> get polyline => _polyline;

  final Set<Marker> _marker = <Marker>{};

  Set<Marker> get marker => _marker;

  Future<void> _load(String name) async {
    final polylineColor = getCatppuccinByCtx(context).blue;

    await loading.command(() async {
      _data = await _locationRepository.getData(name);

      _polyline.add(
        Polyline(
          points: data.map((item) => LatLng(item.lat, item.lng)).toList(),
          color: polylineColor,
        ),
      );

      _marker.add(Marker(position: LatLng(data.first.lat, data.first.lng)));
      _marker.add(Marker(position: LatLng(data.last.lat, data.last.lng)));

      notifyListeners();
    });
  }
}
