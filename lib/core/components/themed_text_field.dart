import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';

/// `TextField` that automatically uses a darker fill with white text when the
/// app is in dark mode, so callers don't need to branch on theme brightness.
class ThemedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Color darkFillColor;
  final int maxLines;

  const ThemedTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.darkFillColor = AppColors.darkFill,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) => TextField(
        cursorOpacityAnimates: false,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          labelStyle: TextStyle(color: isDark ? AppColors.darkTextSemi : null),
          fillColor: isDark ? darkFillColor : null,
        ),
      ),
    );
  }
}
