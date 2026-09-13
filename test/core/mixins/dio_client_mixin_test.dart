import 'package:dio/dio.dart';
import 'package:event_map_flutter/core/mixins/dio_client_mixin.dart';
import 'package:event_map_flutter/modules/common_events/services/common_events_service.dart';
import 'package:event_map_flutter/modules/map/services/google_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/here_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/locationiq_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/nominatim_geocoding_service.dart';
import 'package:event_map_flutter/modules/user_events/services/user_events_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('configures CommonEventsService Dio with logging', () {
    final service = CommonEventsService();

    expect(service.dio, isA<Dio>());
    expect(service.dio.interceptors.whereType<LogInterceptor>(), hasLength(1));
  });

  test('configures UserEventsService Dio with logging', () {
    final service = UserEventsService();

    expect(service.dio, isA<Dio>());
    expect(service.dio.interceptors.whereType<LogInterceptor>(), hasLength(1));
  });

  test('configures geocoding service Dio clients with logging', () {
    final services = <DioClientMixin>[
      GoogleGeocodingService(),
      HereGeocodingService(),
      LocationIqGeocodingService(),
      NominatimGeocodingService(),
    ];

    for (final service in services) {
      expect(service.dio, isA<Dio>());
      expect(
        service.dio.interceptors.whereType<LogInterceptor>(),
        hasLength(1),
      );
    }
  });
}
