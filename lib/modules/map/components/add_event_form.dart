import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/components/themed_text_field.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/modules/user_events/store/user_events_cubit.dart';
import 'package:event_map_flutter/modules/user_events/store/user_events_state.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final AddEventFormCubit _formCubit = GetIt.I.get<AddEventFormCubit>();
  final UserEventsCubit _userEventsCubit = GetIt.I.get<UserEventsCubit>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final bool _autofocusName = _formCubit.state.name.isEmpty;
  late final bool _autofocusDescription =
      !_autofocusName && _formCubit.state.description.isEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEventFormCubit, AddEventFormState>(
      bloc: _formCubit,
      builder: (context, formState) {
        return BlocBuilder<UserEventsCubit, UserEventsState>(
          bloc: _userEventsCubit,
          builder: (context, userEventsState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.generalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.generalPadding / 2),
                  ThemedTextField(
                    controller: _nameController,
                    labelText: '${'map.eventName'.translated} *',
                    autofocus: _autofocusName,
                    errorText:
                        formState.showValidationErrors && !formState.isNameValid
                        ? 'map.eventNameError'.translated
                        : null,
                    onChanged: _formCubit.onNameChanged,
                  ),
                  const SizedBox(height: AppSizes.generalPadding),
                  ThemedTextField(
                    controller: _descriptionController,
                    labelText: 'map.eventDescription'.translated,
                    autofocus: _autofocusDescription,
                    maxLines: 4,
                    onChanged: _formCubit.onDescriptionChanged,
                  ),
                  const SizedBox(height: AppSizes.generalPadding),
                  if (formState.showValidationErrors &&
                      !formState.isDateTimeValid)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSizes.generalPadding / 4,
                      ),
                      child: Text(
                        'map.dateTimeRequired'.translated,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSizes.generalPadding),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
