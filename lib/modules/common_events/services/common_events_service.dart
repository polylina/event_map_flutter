import 'package:event_map_flutter/modules/common_events/dto/common_event_dto.dart';
import 'package:event_map_flutter/modules/common_events/dto/user_dto.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

// TODO: replace hardcoded events with a real backend/API call.
class CommonEventsService {
  final List<CommonEventDto> _events = [
    CommonEventDto(
      id: 'c1',
      name: 'City marathon',
      address: 'City Center, Main Street',
      description: 'Annual marathon through the city center.',
      startTime: _today.add(const Duration(hours: 8)),
      endTime: _today.add(const Duration(hours: 12)),
      location: const LatLng(50.061947, 19.937195),
      flyer: 'https://picsum.photos/id/1024/1200/800',
      user: const UserDto(
        name: 'City Sports Club',
        avatar: 'https://picsum.photos/id/1005/200/200',
      ),
    ),
    CommonEventDto(
      id: 'c2',
      name: 'Open-air concert',
      address: 'Central Park, Main Street',
      description: 'Local bands playing live in the park.',
      startTime: _today.add(const Duration(days: 2, hours: 18)),
      endTime: _today.add(const Duration(days: 2, hours: 22)),
      location: const LatLng(50.049683, 19.944544),
      flyer: 'https://picsum.photos/id/1039/1200/800',
      user: const UserDto(
        name: 'Live Park Stage',
        avatar: 'https://picsum.photos/id/1011/200/200',
      ),
    ),
    CommonEventDto(
      id: 'c3',
      address: 'Market Square, Main Street',
      name: 'Farmers market',
      description: 'Weekly market with local produce.',
      startTime: _today.add(const Duration(days: 5, hours: 9)),
      endTime: _today.add(const Duration(days: 5, hours: 14)),
      location: const LatLng(50.076111, 19.947778),
      flyer: 'https://picsum.photos/id/292/1200/800',
      user: const UserDto(
        name: 'Local Farmers Guild',
        avatar: 'https://picsum.photos/id/1027/200/200',
      ),
    ),
    CommonEventDto(
      id: 'c4',
      address: 'Apple Park, Cupertino',
      name: 'Cupertino community picnic',
      description: 'An afternoon picnic at Apple Park.',
      startTime: _today.add(const Duration(days: 1)),
      endTime: _today.add(const Duration(days: 2)),
      location: const LatLng(37.334789, -122.009020),
      flyer: 'https://picsum.photos/id/1059/1200/800',
      user: const UserDto(
        name: 'Cupertino Community',
        avatar: 'https://picsum.photos/id/1062/200/200',
      ),
    ),
  ];

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<List<CommonEventDto>> getEvents({
    DateTime? startDate,
    LatLngBounds? bounds,
  }) async {
    final endDate = startDate?.add(const Duration(days: 1));
    return _events.where((event) {
      if (startDate != null && event.startTime.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && event.startTime.isAfter(endDate)) {
        return false;
      }
      if (bounds == null) return true;
      final lat = event.location.latitude;
      final lng = event.location.longitude;
      return lat >= bounds.southwest.latitude &&
          lat <= bounds.northeast.latitude &&
          lng >= bounds.southwest.longitude &&
          lng <= bounds.northeast.longitude;
    }).toList();
  }
}
