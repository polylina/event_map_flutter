import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';

abstract class AbstractGeocodingService {
  Future<List<AddressSuggestionDto>> search(String query);
}
