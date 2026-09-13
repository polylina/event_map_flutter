import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  static const String _accessTokenKey = 'auth.accessToken';
  static const String _refreshTokenKey = 'auth.refreshToken';
  static const String _idTokenKey = 'auth.idToken';
  static const String _codeVerifierKey = 'auth.codeVerifier';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String? accessToken,
    required String? refreshToken,
    String? idToken,
  }) async {
    if (accessToken != null) {
      await _storage.write(key: _accessTokenKey, value: accessToken);
    } else {
      await _storage.delete(key: _accessTokenKey);
    }

    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    } else {
      await _storage.delete(key: _refreshTokenKey);
    }

    if (idToken != null) {
      await _storage.write(key: _idTokenKey, value: idToken);
    } else {
      await _storage.delete(key: _idTokenKey);
    }
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getIdToken() async {
    return _storage.read(key: _idTokenKey);
  }

  Future<void> saveCodeVerifier(String verifier) async {
    await _storage.write(key: _codeVerifierKey, value: verifier);
  }

  Future<String?> getCodeVerifier() async {
    return _storage.read(key: _codeVerifierKey);
  }

  Future<void> clearCodeVerifier() async {
    await _storage.delete(key: _codeVerifierKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _idTokenKey);
  }
}
