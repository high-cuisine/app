class AuthResponse {
  final String token;

  AuthResponse({required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
    );
  }
}

class AuthSocResponse {
  final String token;
  final String email;
  final String username;

  AuthSocResponse({
    required this.token,
    required this.email,
    required this.username,
  });

  factory AuthSocResponse.fromJson(Map<String, dynamic> json) {
    return AuthSocResponse(
      token: json['token'],
      email: json['email'],
      username: json['username'],
    );
  }
}
