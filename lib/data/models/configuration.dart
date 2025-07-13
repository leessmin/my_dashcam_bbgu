import 'package:json_annotation/json_annotation.dart';
import 'package:my_dashcam/common/frame_rate.dart';
import 'package:my_dashcam/common/quality.dart';
import 'package:my_dashcam/common/record_interval.dart';
import 'package:my_dashcam/common/rotation.dart';
import 'package:my_dashcam/common/save_size.dart';
import 'package:my_dashcam/domain/models/camera_activity_options.dart';

part 'configuration.g.dart';

/// 应用配置
@JsonSerializable()
class Configuration {
  const Configuration({
    required this.quality,
    required this.rotation,
    required this.frameRate,
    required this.recordSpeed,
    required this.recordVoice,
    required this.stabilization,
    required this.interval,
    required this.lockScreen,
    required this.maxSaveSize,
  });

  // 视频质量
  @JsonKey(defaultValue: "HD")
  final String quality;

  // 录屏旋转角度
  @JsonKey(defaultValue: 1)
  final int rotation;

  // 帧率
  @JsonKey(defaultValue: 30)
  final int frameRate;

  // 是否记录车速
  @JsonKey(defaultValue: true)
  final bool recordSpeed;

  // 是否记录声音
  @JsonKey(defaultValue: true)
  final bool recordVoice;

  // 是否启用防抖
  @JsonKey(defaultValue: true)
  final bool stabilization;

  // 分段录制间隔时间
  @JsonKey(defaultValue: 3)
  final int interval;

  // 进入activity是否锁定屏幕
  @JsonKey(defaultValue: true)
  final bool lockScreen;

  // 最大存储空间
  @JsonKey(defaultValue: 10)
  final int maxSaveSize;

  // 默认配置
  factory Configuration.defaultConf() => Configuration(
    quality: "HD",
    rotation: 1,
    frameRate: 30,
    recordSpeed: true,
    recordVoice: true,
    stabilization: true,
    interval: 3,
    lockScreen: true,
    maxSaveSize: 10,
  );

  factory Configuration.fromCameraActivityOptions(
    CameraActivityOptions options,
  ) => Configuration(
    quality: options.quality.value,
    rotation: options.rotation.value,
    frameRate: options.frameRate.value,
    recordSpeed: options.recordSpeed,
    recordVoice: options.recordVoice,
    stabilization: options.stabilization,
    interval: options.interval.value,
    lockScreen: options.lockScreen,
    maxSaveSize: options.maxSaveSize.value,
  );

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);

  Future<CameraActivityOptions> toCameraActivityOption() =>
      CameraActivityOptions.create(
        quality: Quality.fromValue(quality),
        rotation: Rotation.fromValue(rotation),
        frameRate: FrameRate.fromValue(frameRate),
        recordSpeed: recordSpeed,
        recordVoice: recordVoice,
        stabilization: stabilization,
        interval: RecordInterval.fromValue(interval),
        lockScreen: lockScreen,
        maxSaveSize: SaveSize.fromValue(maxSaveSize),
      );
}
