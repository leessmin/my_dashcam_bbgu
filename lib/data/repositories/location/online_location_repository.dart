import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/location/location_repository.dart';
import 'package:my_dashcam/data/repositories/location/models/location_response.dart';
import 'package:my_dashcam/utils/dio.dart';

import 'location_data.dart';

class OnlineLocationRepository implements LocationRepository {
  @override
  Future<List<LocationData>> getData(String name, {String? deviceId}) async {
    try {
      final deviceIdParams =( deviceId == null || deviceId == "null")? "" : "&device_id=$deviceId";
      debugPrint("Name=$name,asdfasdfasdfasdf, deviceIdParams=$deviceIdParams");

      final response = await (await authFetch)?.get(
        "/location/get_location_path?file_name=$name$deviceIdParams",
      );

      final result = Response.fromJson(
        response?.data,
        (json) => List<LocationResponse>.from(
          (json as List).map(
            (item) => LocationResponse.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );

      if (result.code != 200) {
        return [];
      }

      return result.data
          .map(
            (item) => LocationData(
              lng: item.lng,
              lat: item.lat,
              time: DateTime.parse(item.createdTime),
            ),
          )
          .toList();
    } catch (err) {
      debugPrint("err: $err");
      return <LocationData>[];
    }
  }
}
