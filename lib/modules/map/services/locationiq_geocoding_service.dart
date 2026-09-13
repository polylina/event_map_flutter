import 'package:dio/dio.dart';
import 'package:event_map_flutter/core/config/geocoding_config.dart';
import 'package:event_map_flutter/core/mixins/dio_client_mixin.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';

class LocationIqGeocodingService
    with DioClientMixin
    implements AbstractGeocodingService {
  static const String _baseUrl = 'https://us1.locationiq.com/v1/search';

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    final response = await dio.get(
      _baseUrl,
      queryParameters: {
        'key': GeocodingConfig.locationIqApiKey,
        'q': query,
        'format': 'json',
        'limit': '10',
        'addressdetails': '1',
      },
      options: Options(validateStatus: (_) => true),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'LocationIQ geocoding failed with status ${response.statusCode}',
      );
    }
    final List<dynamic> results = response.data;
    return results
        .map((result) => AddressSuggestionDto.fromOsmResult(result))
        .toList();
  }
}
