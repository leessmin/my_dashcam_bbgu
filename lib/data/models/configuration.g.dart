// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Configuration _$ConfigurationFromJson(Map<String, dynamic> json) =>
    Configuration(
      quality: json['quality'] as String? ?? 'HD',
      rotation: (json['rotation'] as num?)?.toInt() ?? 1,
      frameRate: (json['frameRate'] as num?)?.toInt() ?? 30,
      recordSpeed: json['recordSpeed'] as bool? ?? true,
      recordVoice: json['recordVoice'] as bool? ?? true,
      stabilization: json['stabilization'] as bool? ?? true,
      interval: (json['interval'] as num?)?.toInt() ?? 3,
      lockScreen: json['lockScreen'] as bool? ?? true,
      maxSaveSize: (json['maxSaveSize'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$ConfigurationToJson(Configuration instance) =>
    <String, dynamic>{
      'quality': instance.quality,
      'rotation': instance.rotation,
      'frameRate': instance.frameRate,
      'recordSpeed': instance.recordSpeed,
      'recordVoice': instance.recordVoice,
      'stabilization': instance.stabilization,
      'interval': instance.interval,
      'lockScreen': instance.lockScreen,
      'maxSaveSize': instance.maxSaveSize,
    };
