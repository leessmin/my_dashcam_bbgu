import 'package:my_dashcam/common/frame_rate.dart';
import 'package:my_dashcam/common/quality.dart';
import 'package:my_dashcam/common/record_interval.dart';
import 'package:my_dashcam/common/rotation.dart';
import 'package:my_dashcam/common/save_size.dart';
import 'package:my_dashcam/configuration/global_configuration.dart';

/// CameraActivity 配置
class CameraActivityOptions {
  const CameraActivityOptions({
    required this.quality,
    required this.rotation,
    required this.frameRate,
    required this.recordSpeed,
    required this.recordVoice,
    required this.stabilization,
    required this.interval,
    required this.videoSavePath,
    required this.lockScreen,
    required this.maxSaveSize,
  });

  // 视频质量
  final Quality quality;

  // 录制旋转的角度
  final Rotation rotation;

  // 视频的帧率
  final FrameRate frameRate;

  // 是否记录车速
  final bool recordSpeed;

  // 是否记录声音
  final bool recordVoice;

  // 是否启用防抖
  final bool stabilization;

  // 分段录制间隔时间 [1,3,5,10], 单位分钟
  final RecordInterval interval;

  // 录制存储的目录
  final String videoSavePath;

  // 进入activity是否锁定屏幕
  final bool lockScreen;

  // 最大存储空间，单位GB, 0不开启
  final SaveSize maxSaveSize;

  Map<String, dynamic> toMap() {
    return {
      "quality": quality.value,
      "rotation": rotation.value,
      "frameRate": frameRate.value,
      "recordSpeed": recordSpeed,
      "recordVoice": recordVoice,
      "stabilization": stabilization,
      "interval": interval.value,
      "videoSavePath": videoSavePath,
      "lockScreen": lockScreen,
      "maxSaveSize": maxSaveSize.value,
    };
  }

  // CameraActivityOption工厂，不需要传递videoSavePath，默认使用“私有目录/files/video”
  static Future<CameraActivityOptions> create({
    required Quality quality,
    required Rotation rotation,
    required FrameRate frameRate,
    required bool recordSpeed,
    required bool recordVoice,
    required bool stabilization,
    required RecordInterval interval,
    required bool lockScreen,
    required SaveSize maxSaveSize,
  }) async {

    return CameraActivityOptions(
      quality: quality,
      rotation: rotation,
      frameRate: frameRate,
      recordSpeed: recordSpeed,
      recordVoice: recordVoice,
      stabilization: stabilization,
      interval: interval,
      lockScreen: lockScreen,
      maxSaveSize: maxSaveSize,
      videoSavePath: await GlobalConfiguration.videoPath,
    );
  }
}

extension CopyWith on CameraActivityOptions {
  CameraActivityOptions copyWith({
    Quality? quality,
    Rotation? rotation,
    FrameRate? frameRate,
    bool? recordSpeed,
    bool? recordVoice,
    bool? stabilization,
    RecordInterval? interval,
    String? videoSavePath,
    bool? lockScreen,
    SaveSize? maxSaveSize,
  }) {
    return CameraActivityOptions(
      quality: quality ?? this.quality,
      rotation: rotation ?? this.rotation,
      frameRate: frameRate ?? this.frameRate,
      recordSpeed: recordSpeed ?? this.recordSpeed,
      recordVoice: recordVoice ?? this.recordVoice,
      stabilization: stabilization ?? this.stabilization,
      interval: interval ?? this.interval,
      videoSavePath: videoSavePath ?? this.videoSavePath,
      lockScreen: lockScreen ?? this.lockScreen,
      maxSaveSize: maxSaveSize ?? this.maxSaveSize,
    );
  }
}
