import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';

class ButtonPrimaryLight extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final bool? softWrap;

  const ButtonPrimaryLight({
    super.key,
    required this.label,
    this.trailing,
    this.onPressed,
    this.textStyle,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, isDark) {
        return Material(
          color: isDark ? AppColors.buttonPrimary : AppColors.darkButtonPrimary,
          borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
          elevation: AppSizes.shadowElevation,
          shadowColor: AppColors.shadow,
          clipBehavior: Clip.antiAlias,
          child: WebCursorRegion(
            cursor: CSSCursor.pointer,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                height: kMinInteractiveDimension,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isDark ? AppColors.darkText : AppColors.text,
                        ).merge(textStyle),
                        textAlign: textAlign,
                        overflow: textOverflow,
                        maxLines: maxLines,
                        softWrap: softWrap,
                      ),
                      ?trailing,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
