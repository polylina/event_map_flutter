import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:event_map_flutter/core/constants/geocoding_providers.dart';

class GeocodingConfig {
  static String get provider =>
      dotenv.env['GEOCODING_PROVIDER'] ?? GeocodingProviders.locationIq;
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? '';
  static String get hereApiKey => dotenv.env['HERE_API_KEY'] ?? '';
  static String get locationIqApiKey => dotenv.env['LOCATIONIQ_API_KEY'] ?? '';

  GeocodingConfig._();
}
