import 'dart:async';

import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/components/error_snackbar.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';

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

  /// Shows a floating toast sliding in from the top of the screen.
  void showSuccessToast({
    required BuildContext context,
    required String textKey,
  }) {
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (overlayContext) => _SuccessToast(
        text: textKey.translated,
        onDismiss: () => entry?.remove(),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
  }
}

class _SuccessToast extends StatefulWidget {
  const _SuccessToast({required this.text, required this.onDismiss});

  final String text;
  final VoidCallback onDismiss;

  @override
  State<_SuccessToast> createState() => _SuccessToastState();
}

class _SuccessToastState extends State<_SuccessToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..forward();

  late final Animation<Offset> _offset = Tween(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() {
    _timer?.cancel();
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 16,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _offset,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
          elevation: AppSizes.shadowElevation,
          shadowColor: AppColors.shadow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.successAccent),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.text,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
