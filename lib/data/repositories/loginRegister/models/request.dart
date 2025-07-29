class RegisterRequest {
  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.code,
  });

  final String username;
  final String email;
  final String password;
  final String code;

  Map<String, Object?> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'code': code,
    };
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      code: json['code'] as String,
    );
  }
}

class LoginPasswordRequest {
  const LoginPasswordRequest({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  final String email;
  final String password;
  final String deviceId;

  Map<String, Object?> toMap() {
    return {'email': email, 'password': password, 'device_id': deviceId};
  }

  factory LoginPasswordRequest.fromJson(Map<String, dynamic> json) {
    return LoginPasswordRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceId: json['device_id'] as String,
    );
  }
}

class LoginEmailCodedRequest {
  const LoginEmailCodedRequest({
    required this.email,
    required this.code,
    required this.deviceId,
  });

  final String email;
  final String code;
  final String deviceId;

  Map<String, Object?> toMap() {
    return {'email': email, 'code': code, 'device_id': deviceId};
  }

  factory LoginEmailCodedRequest.fromJson(Map<String, dynamic> json) {
    return LoginEmailCodedRequest(
      email: json['email'] as String,
      code: json['code'] as String,
      deviceId: json['device_id'] as String,
    );
  }
}
