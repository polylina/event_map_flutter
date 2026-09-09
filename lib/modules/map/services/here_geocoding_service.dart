import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/core/config/geocoding_config.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';

class HereGeocodingService implements AbstractGeocodingService {
  static const String _baseUrl =
      'https://geocode.search.hereapi.com/v1/geocode';

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': query,
        'limit': '10',
        'apiKey': GeocodingConfig.hereApiKey,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'HERE geocoding failed with status ${response.statusCode}',
      );
    }
    final List<dynamic> items = jsonDecode(response.body)['items'] ?? [];
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
