import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/components/button_primary_dark.dart';
import 'package:event_map_flutter/core/components/panel_title.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/modules/auth/dto/auth_provider.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';
import 'package:event_map_flutter/modules/auth/store/auth_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';

class SocialLoginForm extends StatelessWidget {
  static const Map<AuthProvider, IconData> _icons = {
    AuthProvider.google: Icons.g_mobiledata,
    AuthProvider.facebook: Icons.facebook,
  };

  final AuthCubit _authCubit = GetIt.I.get<AuthCubit>();

  SocialLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _authCubit,
      builder: (context, state) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.generalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PanelTitle('auth.loginRequired', alignment: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'auth.loginRequiredMessage'.translated,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.sectionTitle),
            ),
            const SizedBox(height: AppSizes.generalPadding),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              for (final provider in AuthProvider.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: WebCursorRegion(
                    cursor: CSSCursor.pointer,
                    child: ButtonPrimaryDark(
                      label: provider.labelKey.translated,
                      icon: _icons[provider],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      onPressed: () => _authCubit.login(provider),
                    ),
                  ),
                ),
            if (state.errorKey != null)
              Text(
                state.errorKey!.translated,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorAccent),
              ),
          ],
        ),
      ),
    );
  }
}
