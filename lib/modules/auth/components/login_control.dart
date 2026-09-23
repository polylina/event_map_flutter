import 'package:event_map_flutter/core/components/themed_surface.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:event_map_flutter/modules/auth/components/social_login_form.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';
import 'package:event_map_flutter/modules/auth/store/auth_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Map-corner auth control.
///
/// - Logged out: material login icon; tap opens a dialog with the social
///   login form.
/// - Logged in: avatar (or generic person icon) + full name / email; tap
///   opens a dropdown with a log out button.
class LoginControl extends StatelessWidget {
  const LoginControl({super.key});

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
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(
        double.infinity,
        0,
        AppSizes.generalPadding,
        double.infinity,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.surface,
      items: [
        PopupMenuItem<String>(
          value: 'logout',
          child: WebCursorRegion(
            cursor: CSSCursor.pointer,
            child: SizedBox(
              height: kMinInteractiveDimension,
              width: double.infinity,
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 20),
                  const SizedBox(width: 12),
                  Text('auth.logout'.translated),
                ],
              ),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'logout') {
        authCubit.logout();
      }
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
            icon: const Icon(Icons.login),
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
  });

  final String? avatarUrl;
  final String? label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: WebCursorRegion(
        cursor: CSSCursor.pointer,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
          child: Container(
            height: kMinInteractiveDimension,
            padding: const EdgeInsets.only(left: 8, right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: AppSizes.shadowElevation,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
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
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
