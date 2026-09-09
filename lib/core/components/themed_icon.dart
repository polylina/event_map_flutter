import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? lightColor;
  final Color? darkColor;

  const ThemedIcon({
    super.key,
    required this.icon,
    this.size,
    this.lightColor,
    this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Icon(
        icon,
        size: size,
        color: isDark
            ? darkColor ?? AppColors.darkCrosshair
            : lightColor ?? AppColors.crosshair,
      ),
    );
  }
}
