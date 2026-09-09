import 'package:equatable/equatable.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

const _osmLocationKeys = {
  'city',
  'town',
  'village',
  'suburb',
  'district',
  'quarter',
  'state_district',
  'county',
  'state',
  'region',
  'postcode',
  'country',
};

class AddressSuggestionDto extends Equatable {
  final String title;
  final String address;
  final LatLng location;

  const AddressSuggestionDto({
    required this.title,
    required this.address,
    required this.location,
  });

  /// Parses a Nominatim-compatible result (shared by Nominatim and
  /// LocationIQ): strips location-level components (city/district/state/
  /// region/postcode/country/etc.) out of `title`, leaving them in the full
  /// `address` (`display_name`) only.
  factory AddressSuggestionDto.fromOsmResult(Map<String, dynamic> result) {
    final address = result['display_name'] ?? '';
    final addressDetails = result['address'] is Map<String, dynamic>
        ? result['address'] as Map<String, dynamic>
        : <String, dynamic>{};
    final locationValues = _osmLocationKeys
        .map((key) => addressDetails[key])
        .whereType<String>()
        .toSet();
    var title = (result['display_name'] ?? '').toString();
    if (locationValues.isNotEmpty) {
      title = title
          .split(',')
          .map((part) => part.trim())
          .where((part) => !locationValues.contains(part))
          .join(', ');
    }
    return AddressSuggestionDto(
      title: title,
      address: address,
      location: LatLng(
        double.parse(result['lat']),
        double.parse(result['lon']),
      ),
    );
  }

  @override
  List<Object?> get props => [title, address, location];
}
