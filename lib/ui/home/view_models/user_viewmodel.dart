import 'package:flutter/cupertino.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';

class UserUiState {
  const UserUiState({required this.username, required this.email});

  final String username;
  final String email;
}

class UserViewModel extends ChangeNotifier {
  UserViewModel({required UserSessionRepository userSessionRepository})
    : _userSessionRepository = userSessionRepository {
    loadUiState();
  }

  final UserSessionRepository _userSessionRepository;

  UserUiState _uiState = UserUiState(username: "", email: "");

  UserUiState get uiState => _uiState;

  void loadUiState() async {
    _uiState = UserUiState(
      username: await _userSessionRepository.getUsername(),
      email: await _userSessionRepository.getEmail(),
    );
    notifyListeners();
  }

  // 退出登陆
  Future<void> logout() async {
    await _userSessionRepository.cleanUserSession();
  }
}
