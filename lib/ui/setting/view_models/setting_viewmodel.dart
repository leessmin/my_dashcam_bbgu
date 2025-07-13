import 'package:flutter/material.dart';
import 'package:my_dashcam/data/models/configuration.dart';
import 'package:my_dashcam/data/repositories/configuration/configuration_repository.dart';
import 'package:my_dashcam/domain/models/camera_activity_options.dart';

class SettingViewModel extends ChangeNotifier {
  SettingViewModel({required ConfigurationRepository configurationRepository})
    : _configurationRepository = configurationRepository {
    load();
  }

  final ConfigurationRepository _configurationRepository;

  // 配置
  CameraActivityOptions? _options;

  CameraActivityOptions? get options => _options;

  // 加载配置
  Future<void> load() async {
    _options = await (await _configurationRepository.getConfiguration())
        .toCameraActivityOption();
    notifyListeners();
  }

  void updateOptions(CameraActivityOptions value) async {
    await _configurationRepository.saveConfiguration(
      Configuration.fromCameraActivityOptions(value),
    );
    load();
  }
}
