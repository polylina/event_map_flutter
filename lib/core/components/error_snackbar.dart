import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar(String text, {super.key})
    : super(
        content: SizedBox(
          height: 42,
          child: Row(
            children: [
              Icon(Icons.error, color: AppColors.errorAccent),
              Container(width: 14),
              Expanded(
                child: Text(text.translated, style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
      );
}
