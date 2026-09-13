import 'package:dio/dio.dart';
import 'package:event_map_flutter/core/interceptors/auth_interceptor.dart';
import 'package:event_map_flutter/core/services/logger_service.dart';

mixin DioClientMixin {
  final Dio dio = Dio()
    ..interceptors.add(AuthInterceptor())
    ..interceptors.add(
      LogInterceptor(
        logPrint: (message) => LoggerService.instance.d(message.toString()),
      ),
    );
}
