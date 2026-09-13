import 'package:dio/dio.dart';
import 'package:event_map_flutter/core/constants/api_endpoints.dart';
import 'package:event_map_flutter/core/mixins/dio_client_mixin.dart';
import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CommonEventsService with DioClientMixin {
  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<List<CommonEventDto>> getEvents({
    DateTime? startDate,
    LatLngBounds? bounds,
    CancelToken? cancelToken,
  }) async {
    if (bounds == null) {
      return [];
    }
    startDate ??= _today;
    final endDate = startDate.add(const Duration(days: 1));
    try {
      final response = await dio.get(
        ApiEndpoints.getCommonEvents,
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'swLat': bounds.southwest.latitude.toString(),
          'swLng': bounds.southwest.longitude.toString(),
          'neLat': bounds.northeast.latitude.toString(),
          'neLng': bounds.northeast.longitude.toString(),
        },
        cancelToken: cancelToken,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => CommonEventDto.fromJson(json)).toList();
    } on DioException catch (_) {
      return [];
    }
  }
}
