import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/data/repositories/device/device_repository.dart';
import 'package:my_dashcam/data/repositories/device/models/response.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';

class UserUiState {
  const UserUiState({
    required this.username,
    required this.email,
    required this.devices,
    required this.loading,
  });

  final String username;
  final String email;
  final List<DeviceResponse> devices;
  final bool loading;

  UserUiState copyWith({String? username, String? email, List<
      DeviceResponse>? devices, bool? loading}) {
    return UserUiState(
      username: username ?? this.username,
      email: email ?? this.email,
      devices: devices ?? this.devices,
      loading: loading ?? this.loading,
    );
  }
}

class UserViewModel extends ChangeNotifier {
  UserViewModel({
    required UserSessionRepository userSessionRepository,
    required DeviceRepository deviceRepository,
  })
      : _userSessionRepository = userSessionRepository,
        _deviceRepository = deviceRepository {
    loadDeviceId();
    loadUiState();
  }

  final UserSessionRepository _userSessionRepository;

  final DeviceRepository _deviceRepository;

  String _deviceId = "";
  String get deviceId => _deviceId;

  UserUiState _uiState = UserUiState(
      username: "", email: "", devices: [], loading: false);

  UserUiState get uiState => _uiState;

  void loadUiState() async {
    _uiState = _uiState.copyWith(loading: true);
    notifyListeners();

    _uiState = _uiState.copyWith(
      username: await _userSessionRepository.getUsername(),
      email: await _userSessionRepository.getEmail(),
      devices: (await _deviceRepository.getDevices())?.data ?? [],
      loading: false,
    );
    notifyListeners();
  }

  // 退出登陆
  Future<void> logout() async {
    await _userSessionRepository.cleanUserSession();
  }

  void loadDeviceId() async {
    _deviceId = await _deviceRepository.getDeviceId();
    notifyListeners();
  }
}
