import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';

/// Free OpenStreetMap Nominatim geocoder, used as a quota-free fallback.
class NominatimGeocodingService implements AbstractGeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': query,
        'format': 'jsonv2',
        'limit': '10',
        'addressdetails': '1',
      },
    );
    // Nominatim usage policy requires a valid identifying User-Agent.
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'event_map_flutter'},
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Nominatim geocoding failed with status ${response.statusCode}',
      );
    }
    final List<dynamic> results = jsonDecode(response.body);
    return results
        .map((result) => AddressSuggestionDto.fromOsmResult(result))
        .toList();
  }
}
