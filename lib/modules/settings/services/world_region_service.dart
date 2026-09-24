import 'package:event_map_flutter/modules/settings/models/world_region.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class WorldRegionService {
  /// Derives the world region from the device timezone.
  /// Falls back to [WorldRegion.rest] when the timezone cannot be resolved.
  Future<WorldRegion> getWorldRegion() async {
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      return regionForTimezone(localTimezone);
    } catch (_) {
      return WorldRegion.rest;
    }
  }

  WorldRegion regionForTimezone(String identifier) {
    final continent = identifier.split('/').first;
    switch (continent) {
      case 'Europe':
        return WorldRegion.europe;
      case 'Asia':
        return WorldRegion.asia;
      case 'America':
        return WorldRegion.america;
      default:
        return WorldRegion.rest;
    }
  }
}
