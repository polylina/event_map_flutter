import 'package:event_map_flutter/modules/map/components/event_marker_icon.dart';
import 'package:flutter/material.dart';

/// Round event icon, falling back to a generic event glyph when the event has
/// no icon of its own.
class EventIconAvatar extends StatelessWidget {
  const EventIconAvatar({super.key, required this.iconUrl, this.size = 24});

  final String? iconUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: EventMarkerIcon.fillColor,
      backgroundImage: iconUrl == null ? null : NetworkImage(iconUrl!),
      child: iconUrl == null
          ? Icon(Icons.event, color: Colors.white, size: size / 2)
          : null,
    );
  }
}
