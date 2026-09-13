import 'package:dio/dio.dart';
import 'package:event_map_flutter/core/mixins/dio_client_mixin.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';

/// Free OpenStreetMap Nominatim geocoder, used as a quota-free fallback.
class NominatimGeocodingService
    with DioClientMixin
    implements AbstractGeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    final response = await dio.get(
      _baseUrl,
      queryParameters: {
        'q': query,
        'format': 'jsonv2',
        'limit': '10',
        'addressdetails': '1',
      },
      options: Options(
        // Nominatim usage policy requires a valid identifying User-Agent.
        headers: {'User-Agent': 'event_map_flutter'},
        validateStatus: (_) => true,
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Nominatim geocoding failed with status ${response.statusCode}',
      );
    }
    final List<dynamic> results = response.data;
    return results
        .map((result) => AddressSuggestionDto.fromOsmResult(result))
        .toList();
  }
}
