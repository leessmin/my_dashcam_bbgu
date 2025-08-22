class LocationResponse {
  const LocationResponse({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.lat,
    required this.lng,
    required this.createdTime,
    required this.fileName,
  });

  final int id;
  final int userId;
  final String deviceId;
  final double lat;
  final double lng;
  final String createdTime;
  final String fileName;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'lat': lat,
      'lng': lng,
      'created_time': createdTime,
      'file_name': fileName,
    };
  }

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      deviceId: json['device_id'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      createdTime: json['created_time'] as String,
      fileName: json['file_name'] as String,
    );
  }
}

