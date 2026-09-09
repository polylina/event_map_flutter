import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// `Text` that resolves its color from the current theme brightness.
class ThemedText extends StatelessWidget {
  const ThemedText(
    this.text, {
    super.key,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.isSecondary = false,
    this.maxLines,
    this.overflow,
    this.primaryColor = AppColors.text,
    this.primaryColorDark = AppColors.darkText,
    this.secondaryColor = AppColors.sectionTitle,
    this.secondaryColorDark = AppColors.darkTextSemi,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isSecondary;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? secondaryColor;
  final Color? secondaryColorDark;
  final Color? primaryColor;
  final Color? primaryColorDark;

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: isSecondary
              ? (isDark ? secondaryColorDark : secondaryColor)
              : (isDark ? primaryColorDark : primaryColor),
        ),
      ),
    );
  }
}
