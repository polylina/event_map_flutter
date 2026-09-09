import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/components/themed_text_field.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';

class AddressSearchField extends StatefulWidget {
  const AddressSearchField({super.key});

  @override
  State<AddressSearchField> createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends State<AddressSearchField> {
  final AddEventFormCubit _formCubit = GetIt.I.get<AddEventFormCubit>();
  late final TextEditingController _controller = TextEditingController(
    text: _formCubit.state.address,
  );
  // An address already filled in means the form step gets focus instead.
  late final bool _autofocus = _formCubit.state.address.isEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEventFormCubit, AddEventFormState>(
      bloc: _formCubit,
      listenWhen: (previous, current) => previous.address != current.address,
      listener: (context, state) {
        if (_controller.text != state.address) {
          _controller.text = state.address;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: ThemedTextField(
          controller: _controller,
          autofocus: _autofocus,
          onChanged: _formCubit.onAddressChanged,
          labelText: 'map.enterAddress'.translated,
        ),
      ),
    );
  }
}
