import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:event_map_flutter/modules/auth/dto/auth_provider.dart';
import 'package:event_map_flutter/modules/auth/services/abstract_auth_service.dart';
import 'package:event_map_flutter/modules/auth/services/app_auth_service.dart';
import 'package:event_map_flutter/modules/auth/services/web_auth_service.dart';

class AuthService implements AbstractAuthService {
  final AbstractAuthService _service;

  AuthService() : _service = kIsWeb ? WebAuthService() : AppAuthService();

  @override
  Future<TokenResponse?> init() => _service.init();

  @override
  Future<TokenResponse?> login(AuthProvider provider) =>
      _service.login(provider);

  @override
  Future<TokenResponse?> refresh(String refreshToken) =>
      _service.refresh(refreshToken);
}
