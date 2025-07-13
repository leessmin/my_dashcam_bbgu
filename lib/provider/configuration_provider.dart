import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/configuration/configuration_repository.dart';
import 'package:my_dashcam/data/services/configuration_service.dart';

final configurationProvider = Provider(
  (ref) =>
      ConfigurationRepository(configurationService: ConfigurationService()),
);
