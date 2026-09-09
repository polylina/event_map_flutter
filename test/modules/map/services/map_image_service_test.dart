import 'dart:typed_data';

import 'package:event_map_flutter/core/di/service_locator.dart';
import 'package:event_map_flutter/modules/map/services/map_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('MapImageService', () {
    setUp(() {
      GetIt.I.reset();
      ServiceLocator.registerInstances();
    });

    test('is registered in ServiceLocator', () {
      final service = GetIt.I.get<MapImageService>();
      expect(service, isA<MapImageService>());
    });

    testWidgets('renders widget to PNG bytes using generic type and builder', (
      tester,
    ) async {
      final service = GetIt.I.get<MapImageService>();
      final bytes = await tester.runAsync(
        () => service.render<SizedBox>(
          size: 20,
          pixelRatio: 2,
          builder: (image) => const SizedBox(
            width: 20,
            height: 20,
            child: ColoredBox(color: Colors.blue),
          ),
        ),
      );

      expect(bytes, isNotNull);
      expect(bytes, isA<Uint8List>());
      expect(bytes!.isNotEmpty, isTrue);
      // PNG signature: 0x89, 'P', 'N', 'G'
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    });

    testWidgets('renders widget to PNG bytes when widget is passed directly', (
      tester,
    ) async {
      final service = GetIt.I.get<MapImageService>();
      final bytes = await tester.runAsync(
        () => service.render<SizedBox>(
          size: 20,
          pixelRatio: 2,
          widget: const SizedBox(
            width: 20,
            height: 20,
            child: ColoredBox(color: Colors.green),
          ),
        ),
      );

      expect(bytes, isNotNull);
      expect(bytes, isA<Uint8List>());
      expect(bytes!.isNotEmpty, isTrue);
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    });
  });
}
