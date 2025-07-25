import 'package:shared_preferences/shared_preferences.dart';

/// 用户状态
class UserSessionRepository {
  final String _tokenKey = "user-session-token"; // 登陆存储的token
  final String _skipLoginKey = "user-session-skipLogin"; // 跳过登陆
  final String _usernameKey = "user-session-username"; // 用户姓名
  final String _emailKey = "user-session-email"; // 用户邮箱

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<String> getToken() async {
    return (await _prefs.getString(_tokenKey)) ?? "";
  }

  void setToken(String val) => _prefs.setString(_tokenKey, val);

  Future<bool> getSkipLogin() async {
    return (await _prefs.getBool(_skipLoginKey)) ?? false;
  }

  void setSkipLoginKey(bool val) => _prefs.setBool(_skipLoginKey, val);

  Future<String> getUsername() async {
    return (await _prefs.getString(_usernameKey)) ?? "";
  }

  void setUsername(String val) => _prefs.setString(_usernameKey, val);

  Future<String> getEmail() async {
    return (await _prefs.getString(_emailKey)) ?? "";
  }

  void setEmail(String val) => _prefs.setString(_emailKey, val);
}
