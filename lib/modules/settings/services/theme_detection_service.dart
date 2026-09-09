import 'dart:ui';

class ThemeDetectionService {
  Brightness getPlatformBrightness() {
    return PlatformDispatcher.instance.platformBrightness;
  }
}
