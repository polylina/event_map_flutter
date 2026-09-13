import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/services/logger_service.dart';
import 'package:event_map_flutter/modules/auth/dto/auth_provider.dart';
import 'package:event_map_flutter/modules/auth/services/abstract_auth_service.dart';
import 'package:event_map_flutter/modules/auth/services/auth_storage_service.dart';
import 'package:event_map_flutter/modules/auth/utils/auth_web_helper.dart';

class WebAuthService implements AbstractAuthService {
  String getWebRedirectUrl() {
    final uri = Uri.base;
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}${uri.path}';
  }

  @override
  Future<TokenResponse?> init() async {
    final params = getWebQueryParams();
    final code = params['code'];
    if (code == null || code.isEmpty) {
      return null;
    }

    final storageService = GetIt.I.get<AuthStorageService>();
    final codeVerifier = await storageService.getCodeVerifier();
    if (codeVerifier == null || codeVerifier.isEmpty) {
      return null;
    }

    try {
      final redirectUrl = getWebRedirectUrl();
      final response = await _exchangeWebCode(code, codeVerifier, redirectUrl);
      await storageService.clearCodeVerifier();
      clearWebQueryParams();
      return response;
    } catch (e, stack) {
      LoggerService.instance.e(
        'Web code exchange error',
        error: e,
        stackTrace: stack,
      );
      await storageService.clearCodeVerifier();
      clearWebQueryParams();
      rethrow;
    }
  }

  @override
  Future<TokenResponse?> login(AuthProvider provider) async {
    final redirectUrl = getWebRedirectUrl();
    final (:codeVerifier, :codeChallenge) = getChallenges();

    await GetIt.I.get<AuthStorageService>().saveCodeVerifier(codeVerifier);

    final authUrl =
        Uri.parse(
              AbstractAuthService.serviceConfiguration.authorizationEndpoint,
            )
            .replace(
              queryParameters: {
                'client_id': AbstractAuthService.clientId,
                'redirect_uri': redirectUrl,
                'response_type': 'code',
                'scope': AbstractAuthService.scopes.join(' '),
                'kc_idp_hint': provider.idpHint,
                'code_challenge': codeChallenge,
                'code_challenge_method': 'S256',
              },
            )
            .toString();

    redirectToUrl(authUrl);
    return null;
  }

  @override
  Future<TokenResponse?> refresh(String refreshToken) async {
    final dio = Dio();
    final response = await dio.post<Map<String, dynamic>>(
      AbstractAuthService.serviceConfiguration.tokenEndpoint,
      data: {
        'grant_type': 'refresh_token',
        'client_id': AbstractAuthService.clientId,
        'refresh_token': refreshToken,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final data = response.data!;
    final expiresIn = data['expires_in'] as int?;
    return TokenResponse(
      data['access_token'] as String?,
      data['refresh_token'] as String?,
      expiresIn != null
          ? DateTime.now().add(Duration(seconds: expiresIn))
          : null,
      data['id_token'] as String?,
      data['token_type'] as String?,
      AbstractAuthService.scopes,
      data,
    );
  }

  Future<TokenResponse> _exchangeWebCode(
    String code,
    String codeVerifier,
    String redirectUrl,
  ) async {
    final dio = Dio();
    final response = await dio.post<Map<String, dynamic>>(
      AbstractAuthService.serviceConfiguration.tokenEndpoint,
      data: {
        'grant_type': 'authorization_code',
        'client_id': AbstractAuthService.clientId,
        'redirect_uri': redirectUrl,
        'code': code,
        'code_verifier': codeVerifier,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final data = response.data!;
    final expiresIn = data['expires_in'] as int?;
    return TokenResponse(
      data['access_token'] as String?,
      data['refresh_token'] as String?,
      expiresIn != null
          ? DateTime.now().add(Duration(seconds: expiresIn))
          : null,
      data['id_token'] as String?,
      data['token_type'] as String?,
      AbstractAuthService.scopes,
      data,
    );
  }
}
