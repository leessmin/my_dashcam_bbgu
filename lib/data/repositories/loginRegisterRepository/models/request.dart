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

