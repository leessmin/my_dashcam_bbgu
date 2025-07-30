import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/data/repositories/device/device_repository.dart';
import 'package:my_dashcam/data/repositories/device/models/response.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';

class UserUiState {
  const UserUiState({
    required this.username,
    required this.email,
    required this.devices,
  });

  final String username;
  final String email;
  final List<DeviceResponse> devices;
}

class UserViewModel extends ChangeNotifier {
  UserViewModel({
    required UserSessionRepository userSessionRepository,
    required DeviceRepository deviceRepository,
  }) : _userSessionRepository = userSessionRepository,
       _deviceRepository = deviceRepository {
    loadUiState();
  }

  final UserSessionRepository _userSessionRepository;

  final DeviceRepository _deviceRepository;

  UserUiState _uiState = UserUiState(username: "", email: "", devices: []);

  UserUiState get uiState => _uiState;

  void loadUiState() async {
    _uiState = UserUiState(
      username: await _userSessionRepository.getUsername(),
      email: await _userSessionRepository.getEmail(),
      devices: (await _deviceRepository.getDevices())?.data ?? [],
    );
    notifyListeners();
  }

  // 退出登陆
  Future<void> logout() async {
    await _userSessionRepository.cleanUserSession();
  }
}
