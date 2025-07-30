class DeviceRegisterResponse {
  const DeviceRegisterResponse({
    required this.id,
    required this.model,
    required this.versionRelease,
    required this.display,
  });

  final String id;
  final String model;
  final String versionRelease;
  final String display;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'model': model,
      'version_release': versionRelease,
      'display': display,
    };
  }

  factory DeviceRegisterResponse.fromJson(Map<String, dynamic> json) {
    return DeviceRegisterResponse(
      id: json['id'] as String,
      model: json['model'] as String,
      versionRelease: json['version_release'] as String,
      display: json['display'] as String,
    );
  }
}

class DeviceResponse {
  const DeviceResponse({
    required this.id,
    required this.model,
    required this.versionRelease,
    required this.display,
  });

  final String id;
  final String model;
  final String versionRelease;
  final String display;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'model': model,
      'version_release': versionRelease,
      'display': display,
    };
  }

  factory DeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeviceResponse(
      id: json['id'] as String,
      model: json['model'] as String,
      versionRelease: json['version_release'] as String,
      display: json['display'] as String,
    );
  }
}

