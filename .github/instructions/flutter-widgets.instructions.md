---
applyTo: "**/*.dart"
---

# Widgets over builder methods

Prefer extracting UI into separate widget classes instead of `_build*` helper methods.

When a build method grows a non-trivial section, create a dedicated widget:

- Private widget class (`class _FooBar extends StatelessWidget`) in the same file, after the main widget, or a public widget in its own file under `components/` when reused.
- Pass needed data via constructor parameters, not by capturing state fields.
- `_build*` methods are allowed only for trivial one-liners; anything with its own layout or logic becomes a widget.

Benefits: const constructors, widget tree caching, no full-State rebuilds, `State` private members stay encapsulated.
