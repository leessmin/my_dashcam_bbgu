import 'dart:convert';

import 'package:my_dashcam/data/models/configuration.dart';
import 'package:my_dashcam/data/services/configuration_service.dart';

class ConfigurationRepository {
  ConfigurationRepository({required ConfigurationService configurationService})
    : _configurationService = configurationService;

  final ConfigurationService _configurationService;

  Future<Configuration> getConfiguration() async {
    final configJson = await _configurationService.read();
    return Configuration.fromJson(
      jsonDecode(configJson),
    );
  }

  Future<void> saveConfiguration(Configuration cfg) async {
    return _configurationService.write(jsonEncode(cfg));
  }
}
