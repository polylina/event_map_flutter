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
