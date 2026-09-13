import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:event_map_flutter/modules/auth/dto/auth_provider.dart';
import 'package:event_map_flutter/modules/auth/services/abstract_auth_service.dart';

class AppAuthService implements AbstractAuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  @override
  Future<TokenResponse?> init() async {
    return null;
  }

  @override
  Future<TokenResponse?> login(AuthProvider provider) {
    return _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        AbstractAuthService.clientId,
        AbstractAuthService.redirectUrl,
        serviceConfiguration: AbstractAuthService.serviceConfiguration,
        scopes: AbstractAuthService.scopes,
        additionalParameters: {'kc_idp_hint': provider.idpHint},
        allowInsecureConnections: AbstractAuthService.issuer.startsWith(
          'http://',
        ),
      ),
    );
  }

  @override
  Future<TokenResponse?> refresh(String refreshToken) {
    return _appAuth.token(
      TokenRequest(
        AbstractAuthService.clientId,
        AbstractAuthService.redirectUrl,
        serviceConfiguration: AbstractAuthService.serviceConfiguration,
        refreshToken: refreshToken,
        scopes: AbstractAuthService.scopes,
        allowInsecureConnections: AbstractAuthService.issuer.startsWith(
          'http://',
        ),
      ),
    );
  }
}
