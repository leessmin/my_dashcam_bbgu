import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/data/repositories/location/location_data.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';
import 'package:my_dashcam/data/services/location_service.dart';

class LocalLocationRepository implements LocationRepository {
  final LocationService _service = LocationService();

  @override
  Future<List<LocationData>> getData(String name, {String? deviceId}) async {
    final content = await _service.getFileString("$name.txt");

    final lines = content.split("\n");

    return lines.where((item) => item != "").map((item) {
      debugPrint("item=$item");
      final dataStr = item.split(";");
      final time = DateTime.fromMillisecondsSinceEpoch(int.parse(dataStr[0]));
      final lat = double.parse(dataStr[1]);
      final lng = double.parse(dataStr[2]);
      return LocationData(lng: lng, lat: lat, time: time);
    }).toList();
  }
}
