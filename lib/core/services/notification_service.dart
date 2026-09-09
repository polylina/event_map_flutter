import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/error_snackbar.dart';

class NotificationService {
  Future<void> showErrorSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context)
        .showSnackBar(ErrorSnackbar(text))
        .closed
        .then((value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
          }
        })
        .catchError((_) {});
  }
}
