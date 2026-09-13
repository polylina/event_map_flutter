import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/services/logger_service.dart';
import 'package:event_map_flutter/modules/auth/dto/auth_provider.dart';
import 'package:event_map_flutter/modules/auth/services/auth_service.dart';
import 'package:event_map_flutter/modules/auth/services/auth_storage_service.dart';
import 'package:event_map_flutter/modules/auth/store/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = GetIt.I.get<AuthService>();
  final AuthStorageService _storageService = GetIt.I.get<AuthStorageService>();

  Future<String?>? _refreshFuture;

  AuthCubit() : super(const AuthState());

  Future<void> init() async {
    try {
      final webTokenResponse = await _authService.init();
      if (webTokenResponse != null) {
        final accessToken = webTokenResponse.accessToken;
        final refreshToken = webTokenResponse.refreshToken;
        final idToken = webTokenResponse.idToken;

        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          idToken: idToken,
        );

        emit(
          state.copyWith(
            accessToken: () => accessToken,
            refreshToken: () => refreshToken,
            idToken: () => idToken,
            isLoading: false,
          ),
        );
        return;
      }
    } catch (_) {
      emit(
        state.copyWith(isLoading: false, errorKey: () => 'auth.loginFailed'),
      );
      return;
    }

    final accessToken = await _storageService.getAccessToken();
    final refreshToken = await _storageService.getRefreshToken();
    final idToken = await _storageService.getIdToken();

    if (accessToken != null || refreshToken != null) {
      emit(
        state.copyWith(
          accessToken: () => accessToken,
          refreshToken: () => refreshToken,
          idToken: () => idToken,
        ),
      );
    }
  }

  Future<void> login(AuthProvider provider) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorKey: () => null));
    try {
      final response = await _authService.login(provider);
      if (response == null) {
        // On web, login() triggers a full page redirect.
        return;
      }
      final accessToken = response.accessToken;
      final refreshToken = response.refreshToken;
      final idToken = response.idToken;

      await _storageService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        idToken: idToken,
      );

      emit(
        state.copyWith(
          accessToken: () => accessToken,
          refreshToken: () => refreshToken,
          idToken: () => idToken,
          isLoading: false,
        ),
      );
    } catch (e, stack) {
      LoggerService.instance.e(
        'AuthCubit.login error',
        error: e,
        stackTrace: stack,
      );
      emit(
        state.copyWith(isLoading: false, errorKey: () => 'auth.loginFailed'),
      );
    }
  }

  Future<String?> refreshToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture;
    }
    _refreshFuture = _performRefresh();
    try {
      return await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _performRefresh() async {
    final storedRefreshToken =
        state.refreshToken ?? await _storageService.getRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      await logout();
      return null;
    }

    try {
      final response = await _authService.refresh(storedRefreshToken);
      final newAccessToken = response?.accessToken;
      final newRefreshToken = response?.refreshToken ?? storedRefreshToken;
      final newIdToken = response?.idToken ?? state.idToken;

      if (newAccessToken == null) {
        await logout();
        return null;
      }

      await _storageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        idToken: newIdToken,
      );

      emit(
        state.copyWith(
          accessToken: () => newAccessToken,
          refreshToken: () => newRefreshToken,
          idToken: () => newIdToken,
        ),
      );

      return newAccessToken;
    } catch (_) {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.clearTokens();
    emit(
      state.copyWith(
        accessToken: () => null,
        refreshToken: () => null,
        idToken: () => null,
      ),
    );
  }
}
