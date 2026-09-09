import 'dart:ui';

class LocaleDetectionService {
  Locale getPlatformLocale() {
    return PlatformDispatcher.instance.locale;
  }
}
