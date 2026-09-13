import 'package:event_map_flutter/core/components/button_primary_dark.dart';
import 'package:event_map_flutter/core/components/themed_surface.dart';
import 'package:event_map_flutter/modules/auth/components/social_login_form.dart';
import 'package:event_map_flutter/modules/auth/store/auth_cubit.dart';
import 'package:event_map_flutter/modules/auth/store/auth_state.dart';
import 'package:event_map_flutter/modules/map/components/add_event_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/modules/map/components/add_event_form.dart';
import 'package:event_map_flutter/modules/map/components/address_search_field.dart';
import 'package:event_map_flutter/modules/map/components/address_suggestions_list.dart';
import 'package:event_map_flutter/modules/map/dto/address_suggestion_dto.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/modules/user_events/store/user_events_cubit.dart';

class AddEventPanel extends StatelessWidget {
  final bool isFullScreen;
  final AddEventFormCubit _formCubit = GetIt.I.get<AddEventFormCubit>();
  final UserEventsCubit _userEventsCubit = GetIt.I.get<UserEventsCubit>();
  final AuthCubit _authCubit = GetIt.I.get<AuthCubit>();
  final ValueChanged<AddressSuggestionDto> onSuggestionSelected;
  final VoidCallback onClose;

  AddEventPanel({
    super.key,
    required this.onSuggestionSelected,
    required this.onClose,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedSurface(
      child: BlocListener<AddEventFormCubit, AddEventFormState>(
        bloc: _formCubit,
        listenWhen: (previous, current) =>
            previous.selectedSuggestion != current.selectedSuggestion &&
            current.selectedSuggestion != null,
        listener: (context, state) =>
            onSuggestionSelected(state.selectedSuggestion!),
        child: BlocBuilder<AuthCubit, AuthState>(
          bloc: _authCubit,
          builder: (context, authState) =>
              BlocBuilder<AddEventFormCubit, AddEventFormState>(
                bloc: _formCubit,
                builder: (context, state) {
                  final content = authState.isAuthenticated
                      ? _buildForm(state)
                      : _buildLogin();
                  return isFullScreen ? SafeArea(child: content) : content;
                },
              ),
        ),
      ),
    );
  }

  Column _buildLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddEventHeader(onClose: onClose),
        Expanded(child: SocialLoginForm()),
      ],
    );
  }

  Column _buildForm(AddEventFormState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddEventHeader(onClose: onClose),
        const AddressSearchField(),
        Expanded(
          child: state.selectedSuggestion == null
              ? AddressSuggestionsList()
              : const AddEventForm(),
        ),
        if (state.selectedSuggestion != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ButtonPrimaryDark(
              label: 'map.save'.translated,
              onPressed: () => _save(_formCubit, _userEventsCubit),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  void _save(AddEventFormCubit formCubit, UserEventsCubit userEventsCubit) {
    final event = formCubit.buildEvent();
    if (event == null) {
      formCubit.markValidationAttempted();
      return;
    }
    userEventsCubit.addEvent(event);
    formCubit.reset();
  }
}
