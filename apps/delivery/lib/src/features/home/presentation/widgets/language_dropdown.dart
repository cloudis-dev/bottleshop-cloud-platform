import 'package:delivery/src/core/data/models/preferences.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/widgets/dropdown.dart';
import 'package:delivery/src/core/utils/language_utils.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageDropdown extends HookConsumerWidget {
  const LanguageDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropDown<LanguageMode>(
      showUnderline: false,
      items: LanguageMode.values,
      customWidgets: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            kLanguageFlagsMap[LanguageMode.en]!,
            height: 16,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            kLanguageFlagsMap[LanguageMode.sk]!,
            height: 16,
          ),
        ),
      ],
      initialValue:
          ref.read(sharedPreferencesServiceProvider).getAppLanguage(),
      onChanged: (value) async {
        await ref.read(sharedPreferencesServiceProvider).setAppLocale(value!);
        await ref
            .read(userRepositoryProvider)
            .onUserChangedPreferredLanguage(value);
        ref.refresh(sharedPreferencesServiceProvider);
      },
    );
  }
}
