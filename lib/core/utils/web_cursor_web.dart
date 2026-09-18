// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'package:event_map_flutter/core/constants/css_cursor.dart';

final List<String> _stack = [];

/// Sets the cursor on every MapLibre map element found in the DOM.
///
/// Needed on Flutter web because the map is an HTML platform view: it is the
/// topmost element under the pointer, so cursors announced by Flutter's
/// MouseRegions never reach the DOM and the browser keeps showing whatever
/// the platform view's CSS says. Widgets rendered above the map call this on
/// pointer enter/exit; inline styles also beat maplibre's own stylesheet.
void _apply(String cursorCss) {
  html.document
      .querySelectorAll('.maplibregl-canvas-container')
      .forEach((element) => element.style.cursor = cursorCss);
}

/// Pushes `cursorCss` while the pointer is inside the calling region.
///
/// Cursors nest as a stack, so a tappable element inside a panel can override
/// the panel's `default` cursor and the previous value is restored on exit.
void pushWebCursor(CSSCursor cursorCss) {
  _stack.add(cursorCss.value);
  _apply(cursorCss.value);
}

/// Pops the cursor pushed by the matching [pushWebCursor].
void popWebCursor() {
  _stack.removeLast();
  _apply(_stack.isEmpty ? 'grab' : _stack.last);
}

/// Sets the cursor without touching the stack (the map's own base cursor).
void setWebCursor(CSSCursor cursorCss) {
  _stack.clear();
  _apply(cursorCss.value);
}
