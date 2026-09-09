import 'package:flutter/material.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/components/themed_divider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/components/condition_builder.dart';
import 'package:event_map_flutter/core/components/section_title.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_cubit.dart';
import 'package:event_map_flutter/modules/map/store/add_event_form_state.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';

class AddressSuggestionsList extends StatelessWidget {
  final AddEventFormCubit _formCubit = GetIt.I.get<AddEventFormCubit>();

  AddressSuggestionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEventFormCubit, AddEventFormState>(
      bloc: _formCubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.generalPadding,
            vertical: AppSizes.generalPadding / 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConditionBuilder(
                condition: state.suggestions.isNotEmpty,
                truthyBuilder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.generalPadding / 2,
                  ),
                  child: SectionTitle(
                    'map.searchResults'.translatedWithArgs({
                      'count': state.suggestions.length,
                    }),
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: state.suggestions.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.generalPadding / 4,
                    ),
                    child: ThemedDivider(),
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = state.suggestions[index];
                    return ListTile(
                      title: Text(
                        suggestion.title.isEmpty
                            ? suggestion.address
                            : suggestion.title,
                      ),
                      subtitle: Text(
                        suggestion.title.isEmpty ? '' : suggestion.address,
                      ),
                      onTap: () => _formCubit.selectSuggestion(suggestion),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.listTileBorderRadius,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
