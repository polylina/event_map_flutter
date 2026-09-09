import 'dart:typed_data';

import 'package:event_map_flutter/core/di/service_locator.dart';
import 'package:event_map_flutter/core/services/image_resolver_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageResolverService', () {
    setUp(() {
      GetIt.I.reset();
      ServiceLocator.registerInstances();
    });

    test('is registered in ServiceLocator', () {
      final service = GetIt.I.get<ImageResolverService>();
      expect(service, isA<ImageResolverService>());
    });

    test('resolves ImageProvider to ui.Image', () async {
      final kTransparentImage = Uint8List.fromList(<int>[
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x06,
        0x00,
        0x00,
        0x00,
        0x1F,
        0x15,
        0xC4,
        0x89,
        0x00,
        0x00,
        0x00,
        0x0A,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0x9C,
        0x63,
        0x00,
        0x01,
        0x00,
        0x00,
        0x05,
        0x00,
        0x01,
        0x0D,
        0x0A,
        0x2D,
        0xB4,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ]);

      final service = ImageResolverService();
      final image = await service.resolve(MemoryImage(kTransparentImage));

      expect(image.width, 1);
      expect(image.height, 1);
    });
  });
}
