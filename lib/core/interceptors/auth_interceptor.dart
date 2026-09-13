import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authCubit = GetIt.I.get<AuthCubit>();
    final accessToken = authCubit.state.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final authCubit = GetIt.I.get<AuthCubit>();
      final newAccessToken = await authCubit.refreshToken();
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        try {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          final dio = Dio();
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (retryError) {
          if (retryError is DioException) {
            return handler.next(retryError);
          }
        }
      }
    }
    handler.next(err);
  }
}
