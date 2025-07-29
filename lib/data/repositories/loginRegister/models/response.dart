class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.user,
  });

  final String token;
  final User user;

  Map<String, Object?> toMap() {
    return {
      'token': token,
      'user': user,
    };
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  const User({
    required this.username,
    required this.email,
  });

  final String username;
  final String email;

  Map<String, Object?> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }
}

