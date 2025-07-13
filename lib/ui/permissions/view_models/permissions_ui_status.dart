class PermissionsUiStatus {
  PermissionsUiStatus({
    required this.camera,
    required this.microphone,
    required this.location,
    required this.notification,
    required this.ignoreBatteryOptimizations,
  });

  bool camera;
  bool microphone;
  bool location;
  bool notification;
  bool ignoreBatteryOptimizations;

  // 是否全部为true
  bool isAllReady() {
    return camera &&
        microphone &&
        location &&
        notification &&
        ignoreBatteryOptimizations;
  }
}
