---
applyTo: "**/*.dart"
---

# Member ordering

Private methods always go after public ones within a class.

Order inside a class:

1. Public static fields/constants
2. Private static fields/constants
3. Public static methods
4. Private static methods
5. Public instance fields/constants
6. Private instance fields/constants
7. Constructors
8. Public methods
9. Private methods (including lifecycle overrides like `dispose` if private)

When adding or refactoring methods, place any `_privateMethod` below the last public method. Move existing private methods up only when editing the class anyway.
