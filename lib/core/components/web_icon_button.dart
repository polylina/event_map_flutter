import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'web_cursor_region.dart';

/// [IconButton] wrapped in a [WebCursorRegion] so tappable icons show the
/// `pointer` cursor over the web map's platform view.
class WebIconButton extends StatelessWidget {
  const WebIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.style,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return WebCursorRegion(
      cursor: CSSCursor.pointer,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: tooltip,
        style: style,
      ),
    );
  }
}
