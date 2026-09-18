import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:flutter/material.dart';

import '../utils/web_cursor.dart';

/// Reusable MouseRegion that drives the DOM cursor on web (see `web_cursor`).
///
/// Use [cursor] `pointer` for tappable elements and `default` for surfaces
/// that just need the map's `grab` cursor suppressed.
class WebCursorRegion extends StatelessWidget {
  const WebCursorRegion({super.key, required this.cursor, required this.child});

  /// CSS cursor value, e.g. `'pointer'` or `'default'`.
  final CSSCursor cursor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => pushWebCursor(cursor),
      onExit: (_) => popWebCursor(),
      child: child,
    );
  }
}
