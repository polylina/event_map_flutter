import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';

/// `Material` surface that automatically switches between a light and dark
/// background based on `SettingsCubit`'s theme brightness.
class ThemedSurface extends StatelessWidget {
  final Widget child;
  final Color lightColor;
  final Color darkColor;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;

  const ThemedSurface({
    super.key,
    required this.child,
    this.lightColor = AppColors.surface,
    this.darkColor = AppColors.darkSurface,
    this.elevation = 0,
    this.shadowColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Material(
        color: isDark ? darkColor : lightColor,
        elevation: elevation,
        shadowColor: shadowColor,
        shape: shape,
        clipBehavior: shape == null ? Clip.none : Clip.antiAlias,
        child: child,
      ),
    );
  }
}
