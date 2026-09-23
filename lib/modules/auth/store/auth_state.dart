import 'package:event_map_flutter/modules/auth/utils/jwt_decoder.dart';

class AuthState {
  final String? accessToken;
  final String? refreshToken;
  final String? idToken;
  final bool isLoading;
  final String? errorKey;

  const AuthState({
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.isLoading = false,
    this.errorKey,
  });

  bool get isAuthenticated => accessToken != null;

  Map<String, dynamic>? get _claims => JwtDecoder.payload(idToken);

  /// Full display name from the id token claims, e.g. "Jane Doe".
  String? get userName {
    final claims = _claims;
    if (claims == null) return null;
    return claims['name'] as String? ?? claims['preferred_username'] as String?;
  }

  /// Email from the id token claims.
  String? get userEmail => _claims?['email'] as String?;

  /// Avatar URL from the id token claims (Keycloak: `picture`).
  String? get userAvatar => _claims?['picture'] as String?;

  /// Best label to show: full name, or email when no name is set.
  String? get userLabel => userName ?? userEmail;

  AuthState copyWith({
    String? Function()? accessToken,
    String? Function()? refreshToken,
    String? Function()? idToken,
    bool? isLoading,
    String? Function()? errorKey,
  }) {
    return AuthState(
      accessToken: accessToken == null ? this.accessToken : accessToken(),
      refreshToken: refreshToken == null ? this.refreshToken : refreshToken(),
      idToken: idToken == null ? this.idToken : idToken(),
      isLoading: isLoading ?? this.isLoading,
      errorKey: errorKey == null ? this.errorKey : errorKey(),
    );
  }
}
