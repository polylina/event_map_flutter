import 'package:dio/dio.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/core/config/geocoding_config.dart';
import 'package:event_map_flutter/core/mixins/dio_client_mixin.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';

class HereGeocodingService
    with DioClientMixin
    implements AbstractGeocodingService {
  static const String _baseUrl =
      'https://geocode.search.hereapi.com/v1/geocode';

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    final response = await dio.get(
      _baseUrl,
      queryParameters: {
        'q': query,
        'limit': '10',
        'apiKey': GeocodingConfig.hereApiKey,
      },
      options: Options(validateStatus: (_) => true),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'HERE geocoding failed with status ${response.statusCode}',
      );
    }
    final List<dynamic> items = response.data['items'] ?? [];
    return items.map((item) {
      return AddressSuggestionDto(
        title: item['title'] ?? '',
        address: item['address']?['label'] ?? '',
        location: LatLng(
          (item['position']['lat'] as num).toDouble(),
          (item['position']['lng'] as num).toDouble(),
        ),
      );
    }).toList();
  }
}
