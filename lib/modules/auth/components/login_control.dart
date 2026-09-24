import 'package:event_map_flutter/core/components/themed_surface.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';
import 'package:event_map_flutter/core/components/web_icon_button.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:event_map_flutter/modules/auth/components/social_login_form.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';
import 'package:event_map_flutter/modules/auth/store/auth_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Map-corner auth control.
///
/// - Logged out: material login icon; tap opens a dialog with the social
///   login form.
/// - Logged in: avatar (or generic person icon) + full name / email; tap
///   opens a dropdown with a log out button.
class LoginControl extends StatefulWidget {
  const LoginControl({super.key});

  @override
  State<LoginControl> createState() => _LoginControlState();
}

class _LoginControlState extends State<LoginControl> {
  bool _isLogoutVisible = false;
  Timer? _logoutTimer;

  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I.get<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        if (!state.isAuthenticated) {
          return _LoginButton(onPressed: () => _showLoginDialog(context));
        }
        return _UserButton(
          avatarUrl: state.userAvatar,
          label: state.userLabel,
          onPressed: () => _showLogoutMenu(context, authCubit),
          isLogoutVisible: _isLogoutVisible,
          onLogoutPressed: () => authCubit.logout(),
        );
      },
    );
  }

  Future<void> _showLoginDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: ThemedSurface(child: SocialLoginForm()),
        ),
      ),
    );
  }

  void _showLogoutMenu(BuildContext context, AuthCubit authCubit) {
    setState(() {
      _isLogoutVisible = true;
    });
    _logoutTimer?.cancel();
    _logoutTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLogoutVisible = false;
      });
    });
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: SizedBox(
        width: kMinInteractiveDimension,
        height: kMinInteractiveDimension,
        child: WebCursorRegion(
          cursor: CSSCursor.pointer,
          child: IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'auth.login'.translated,
            onPressed: onPressed,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: AppSizes.shadowElevation,
              shadowColor: AppColors.shadow,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserButton extends StatelessWidget {
  const _UserButton({
    required this.avatarUrl,
    required this.label,
    required this.onPressed,
    this.isLogoutVisible = false,
    this.onLogoutPressed,
  });

  final String? avatarUrl;
  final String? label;
  final VoidCallback onPressed;
  final bool isLogoutVisible;
  final VoidCallback? onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
        elevation: AppSizes.shadowElevation,
        shadowColor: AppColors.shadow,
        child: WebCursorRegion(
          cursor: CSSCursor.pointer,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(
                  AppSizes.buttonBorderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: avatarUrl == null
                            ? null
                            : NetworkImage(avatarUrl!),
                        child: avatarUrl == null
                            ? const Icon(Icons.person, size: 16)
                            : null,
                      ),
                      if (label != null) ...[
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: Text(
                            label!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.centerRight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    alignment: Alignment.centerRight,
                    child: child,
                  ),
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: Alignment.centerRight,
                    children: [...previousChildren, ?currentChild],
                  ),
                  child: isLogoutVisible
                      ? WebIconButton(
                          key: const ValueKey('logout'),
                          icon: Icons.logout,
                          onPressed: onLogoutPressed,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
