import 'package:event_map_flutter/core/config/geocoding_config.dart';
import 'package:event_map_flutter/core/constants/geocoding_providers.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/services/abstract_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/google_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/here_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/locationiq_geocoding_service.dart';
import 'package:event_map_flutter/modules/map/services/nominatim_geocoding_service.dart';

class GeocodingService implements AbstractGeocodingService {
  late final AbstractGeocodingService _service;
  final AbstractGeocodingService _fallbackService = NominatimGeocodingService();

  GeocodingService() {
    switch (GeocodingConfig.provider) {
      // TODO: move all to API
      case GeocodingProviders.google:
        _service = GoogleGeocodingService();
        break;
      case GeocodingProviders.here:
        _service = HereGeocodingService();
        break;
      case GeocodingProviders.locationIq:
        _service = LocationIqGeocodingService();
        break;
      default:
        _service = NominatimGeocodingService();
        break;
    }
  }

  @override
  Future<List<AddressSuggestionDto>> search(String query) async {
    try {
      return await _service.search(query);
    } catch (_) {
      // Primary provider failed (e.g. quota exceeded) — fall back to Nominatim.
      try {
        return await _fallbackService.search(query);
      } catch (_) {
        return [];
      }
    }
  }
}
