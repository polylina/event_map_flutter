import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/themed_icon.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';

class PositionedCrosshair extends StatelessWidget {
  const PositionedCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child: ThemedIcon(icon: Icons.gps_fixed, size: AppSizes.crosshairSize),
      ),
    );
  }
}
