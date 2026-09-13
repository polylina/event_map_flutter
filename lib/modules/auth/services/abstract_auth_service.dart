import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:event_map_flutter/modules/auth/dto/auth_provider.dart';

abstract class AbstractAuthService {
  static const String defaultRedirectUrl = 'emf://login-callback';
  static const String defaultClientId = 'event_map_flutter';
  static const String defaultIssuer = 'http://localhost:8080/realms/event_map';
  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
  ];

  static String get redirectUrl =>
      dotenv.env['KEYCLOAK_REDIRECT_URL'] ?? defaultRedirectUrl;

  static String get issuer => dotenv.env['KEYCLOAK_ISSUER'] ?? defaultIssuer;

  static String get clientId =>
      dotenv.env['KEYCLOAK_CLIENT_ID'] ?? defaultClientId;

  static AuthorizationServiceConfiguration get serviceConfiguration {
    return AuthorizationServiceConfiguration(
      authorizationEndpoint: '$issuer/protocol/openid-connect/auth',
      tokenEndpoint: '$issuer/protocol/openid-connect/token',
      endSessionEndpoint: '$issuer/protocol/openid-connect/logout',
    );
  }

  Future<TokenResponse?> init();
  Future<TokenResponse?> login(AuthProvider provider);
  Future<TokenResponse?> refresh(String refreshToken);
}
