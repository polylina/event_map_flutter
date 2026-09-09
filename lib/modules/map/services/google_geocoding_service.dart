import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:event_map_flutter/core/config/geocoding_config.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';

class GoogleGeocodingService implements AbstractGeocodingService {
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:searchText';

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': GeocodingConfig.googleApiKey,
        'X-Goog-FieldMask':
            'places.displayName,places.formattedAddress,places.location',
      },
      body: jsonEncode({'textQuery': query}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Google geocoding failed with status ${response.statusCode}',
      );
    }
    final List<dynamic>? places = jsonDecode(response.body)['places'];
    return places?.map((place) {
          return AddressSuggestionDto(
            title: place['displayName']?['text'] ?? '',
            address: place['formattedAddress'] ?? '',
            location: LatLng(
              (place['location']['latitude'] as num).toDouble(),
              (place['location']['longitude'] as num).toDouble(),
            ),
          );
        }).toList() ??
        [];
  }
}
