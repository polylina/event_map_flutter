import 'package:event_map_flutter/core/components/themed_surface.dart';
import 'package:event_map_flutter/modules/auth/components/social_login_form.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> callIfAuthenticated(
  BuildContext context, {
  required VoidCallback callable,
}) async {
  final isAuthenticated = GetIt.I.get<AuthCubit>().state.isAuthenticated;
  if (isAuthenticated) {
    callable();
    return;
  }
  await showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: ThemedSurface(child: SocialLoginForm()),
      ),
    ),
  );
}
