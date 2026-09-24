import 'package:event_map_flutter/core/components/theme_builder.dart';
import 'package:event_map_flutter/core/components/web_cursor_region.dart';
import 'package:event_map_flutter/core/constants/app_sizes.dart';
import 'package:event_map_flutter/core/constants/css_cursor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:event_map_flutter/core/constants/app_colors.dart';
import 'package:event_map_flutter/modules/settings/dto/language_dto.dart';
import 'package:event_map_flutter/modules/settings/extensions/translated_string.dart';
import 'package:event_map_flutter/modules/settings/store/settings_cubit.dart';
import 'package:event_map_flutter/modules/settings/store/settings_state.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({super.key});

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  final SettingsCubit _settingsCubit = GetIt.I.get<SettingsCubit>();
  final GlobalKey<PopupMenuButtonState<LanguageDto>> _popupMenuKey =
      GlobalKey();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: _settingsCubit,
      builder: (context, state) => ThemeBuilder(
        builder: (context, isDark) {
          if (state.supportedLanguages.isEmpty) {
            return const SizedBox.shrink();
          }
          return PopupMenuButton<LanguageDto>(
            key: _popupMenuKey,
            // Own tap disabled so the button below owns tap handling and its ripple shows.
            enabled: false,
            initialValue: state.language,
            position: PopupMenuPosition.under,
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            popUpAnimationStyle: AnimationStyle(
              duration: const Duration(milliseconds: 100),
              reverseDuration: const Duration(milliseconds: 0),
            ),
            onOpened: () => setState(() => _isOpen = true),
            onCanceled: () => setState(() => _isOpen = false),
            onSelected: (language) {
              setState(() => _isOpen = false);
              _settingsCubit.changeLanguage(language);
            },
            itemBuilder: (context) => state.supportedLanguages
                .map(
                  (language) => PopupMenuItem(
                    value: language,
                    child: WebCursorRegion(
                      cursor: CSSCursor.pointer,
                      child: SizedBox(
                        height: kMinInteractiveDimension,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_countryFlag(language.countryCode)}  '
                              '${_languageName(language.languageCode)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: WebCursorRegion(
                cursor: CSSCursor.pointer,
                child: SizedBox(
                  height: kMinInteractiveDimension,
                  width: kMinInteractiveDimension,
                  child: IconButton(
                    icon: state.language == null
                        ? const SizedBox.shrink()
                        : Text(
                            _countryFlag(state.language!.countryCode),
                            style: TextStyle(fontSize: AppSizes.langFlagSize),
                          ),
                    onPressed: () =>
                        _popupMenuKey.currentState?.showButtonMenu(),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      elevation: AppSizes.shadowElevation,
                      shadowColor: AppColors.shadow,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _countryFlag(String countryCode) {
    return countryCode
        .toUpperCase()
        .codeUnits
        .map((codeUnit) => String.fromCharCode(codeUnit + 0x1F1A5))
        .join();
  }

  String _languageName(String languageCode) {
    return 'settings.language.$languageCode'.translated;
  }
}
